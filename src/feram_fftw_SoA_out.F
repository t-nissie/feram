! feram_fftw_SoA_out.F -*-f90-*-
! Time-stamp: <2015-09-13 08:02:47 takeshi>
! Author: Takeshi NISHIMATSU
!!
subroutine feram_fftw_SoA_out(howmany, N_TIMES, Lx, Ly, Lz, padding_y, flags, plan_r2c, plan_c2r)
  use, intrinsic :: iso_c_binding
  implicit none
  include 'fftw3.f03'
  integer, intent(in) :: howmany, N_TIMES, Lx, Ly, Lz, padding_y, flags
  type(C_PTR), intent(out) :: plan_r2c, plan_c2r

  integer, parameter :: rank=3
  integer, parameter :: stride = 1

  real*8  :: N_inv
  integer :: N
  integer ::  LzLyLx(3)
  integer :: d_embed(3)
  integer :: z_embed(3)
  integer :: z_dist, d_dist

  integer i,ix,iy,iz

  real*8,     allocatable :: dipoR(:,:,:,:)   ! Optical dipole displacements as a function of R
  complex*16, allocatable :: dipoK(:,:,:,:)   ! FT of dipoQ

  integer :: count_begin, count_end, count_rate, count_max

  logical :: isnan   ! IBM XL Fortran (xlf) version 14.1 reauires it.

  LzLyLx( 1)=Lz; LzLyLx( 2)=Ly;           LzLyLx( 3)=Lx
  d_embed(1)=Lz; d_embed(2)=Ly+padding_y; d_embed(3)=2*(Lx/2+1)
  z_embed(1)=Lz; z_embed(2)=Ly+padding_y; z_embed(3)=   Lx/2+1
  z_dist = (Lx/2+1) * (Ly+padding_y) * Lz
  d_dist = 2 * z_dist   ! For large distance, you should use FFTW_PATIENT.
  N = Lx * Ly *Lz
  N_inv = 1.0d0/N

  allocate(dipoR(0:2*(Lx/2+1)-1, 0:Ly+padding_y-1, 0:Lz-1, 1:howmany))
  allocate(dipoK(0:Lx/2,         0:Ly+padding_y-1, 0:Lz-1, 1:howmany)) !"/2" for real<->complex FFT
!!!first touch
!$omp parallel do
  do iz = 0,Lz-1
     dipoR(:,:,iz,:) = 0.1d0
  end do
!$omp end parallel do
!$omp parallel do
  do iz = 0,Lz-1
     dipoK(:,:,iz,:) = (0.0d0,0.0d0)
  end do
!$omp end parallel do

    plan_r2c = fftw_plan_many_dft_r2c(rank,LzLyLx,howmany,&
         &                                   dipoR,d_embed,stride,d_dist,&
         &                                   dipoK,z_embed,stride,z_dist,flags)
    plan_c2r = fftw_plan_many_dft_c2r(rank,LzLyLx,howmany,&
         &                                   dipoK,z_embed,stride,z_dist,&
         &                                   dipoR,d_embed,stride,d_dist,flags)

!$omp parallel do
  do iz = 0,Lz-1
     dipoR(:,:,iz,:) = 0.1d0
  end do
!$omp end parallel do

  call system_clock(count_begin)
  do i = 1, N_TIMES
     call fftw_execute_dft_r2c(plan_r2c, dipoR, dipoK)
!$omp parallel do
     do iz = 0,Lz-1
        dipoK(:,:,iz,:) = dipoK(:,:,iz,:) * N_inv
     end do
!$omp end parallel do
     call fftw_execute_dft_c2r(plan_c2r, dipoK, dipoR)
  end do
  call system_clock(count_end, count_rate, count_max)

!$omp parallel do private(iz, iy, ix, i)
  do iz = 0, Lz-1
     do i = 1, howmany
        do iy = 0, Ly-1
           do ix = 0, Lx-1
              if (isnan(dipoR(ix,iy,iz,i)) .or. abs(dipoR(ix,iy,iz,i)-0.1d0)>1.0d-15) then
                 write(0,'(a,a,i3,a,4(i5,a),f21.16)')   __FILE__, ':', __LINE__ , &
                      & ': Error in accuracy at d(',ix,',',iy,',',iz,',',i,') =',dipoR(ix,iy,iz,i)
                 stop 2
              end if
           end do
        end do
     end do
  end do
!$omp end parallel do

  call feram_fftw_wisdom_timing(howmany, N_TIMES, Lx, Ly, Lz, padding_y, ' out', &
     &                              count_begin, count_end, count_rate, count_max)

  deallocate(dipoR)
  deallocate(dipoK)
end subroutine feram_fftw_SoA_out
