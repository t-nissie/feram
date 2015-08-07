! feram_fftw_SoA_in.F -*-f90-*-
! Time-stamp: <2015-08-07 17:46:44 takeshi>
! Author: Takeshi NISHIMATSU
!!
subroutine feram_fftw_SoA_in(howmany, N_TIMES, Lx, Ly, Lz, padding_y, flags, plan_r2c, plan_c2r)
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

  type(C_PTR)        :: inho_ptr = c_null_ptr
  integer(C_SIZE_T)  :: n_alloc_inho
  complex*16,pointer :: inhoK(:,:,:,:)
  real*8,    pointer :: inhoR(:,:,:,:)

  integer :: count_begin, count_end, count_rate, count_max

  logical :: isnan   ! IBM XL Fortran (xlf) version 14.1 reauires it.

  LzLyLx( 1)=Lz; LzLyLx( 2)=Ly;           LzLyLx( 3)=Lx
  d_embed(1)=Lz; d_embed(2)=Ly+padding_y; d_embed(3)=2*(Lx/2+1)
  z_embed(1)=Lz; z_embed(2)=Ly+padding_y; z_embed(3)=   Lx/2+1
  z_dist = (Lx/2+1) * (Ly+padding_y) * Lz
  d_dist = 2 * z_dist   ! For large distance, you should use FFTW_PATIENT.
  N = Lx * Ly *Lz
  N_inv = 1.0d0/N

  n_alloc_inho = howmany * (Lx/2+1) * (Ly+padding_y) * Lz
  inho_ptr = fftw_alloc_complex(n_alloc_inho)
  call c_f_pointer(inho_ptr, inhoK, [  (Lx/2+1), Ly+padding_y, Lz, howmany])
  call c_f_pointer(inho_ptr, inhoR, [2*(Lx/2+1), Ly+padding_y, Lz, howmany])
!!!first touch!!! Here, indexes of arrays do not have to start from 0.
!$omp parallel do
    do iz = 1, Lz
       inhoK(:,:,iz,:) = (0.0d0,0.0d0)
    end do
!$omp end parallel do
    plan_r2c = fftw_plan_many_dft_r2c(rank,LzLyLx,howmany,&
         &                                   inhoR,d_embed,stride,d_dist,&
         &                                   inhoK,z_embed,stride,z_dist,flags)
    plan_c2r = fftw_plan_many_dft_c2r(rank,LzLyLx,howmany,&
         &                                   inhoK,z_embed,stride,z_dist,&
         &                                   inhoR,d_embed,stride,d_dist,flags)

!$omp parallel do
  do iz = 1,Lz
     inhoR(:,:,iz,:) = 0.1d0
  end do
!$omp end parallel do

  call system_clock(count_begin)
  do i = 1, N_TIMES
     call fftw_execute_dft_r2c(plan_r2c, inhoR, inhoK)
!$omp parallel do
     do iz = 1,Lz
        inhoK(:,:,iz,:) = inhoK(:,:,iz,:) * N_inv
     end do
!$omp end parallel do
     call fftw_execute_dft_c2r(plan_c2r, inhoK, inhoR)
  end do
  call system_clock(count_end, count_rate, count_max)

!$omp parallel do private(iz, iy, ix, i)
  do iz = 1, Lz
     do i = 1, howmany
        do iy = 1, Ly
           do ix = 1, Lx
              if (isnan(inhoR(ix,iy,iz,i)) .or. abs(inhoR(ix,iy,iz,i)-0.1d0)>1.0d-15) then
                 write(0,'(a,a,i3,a,4(i5,a),f21.16)')   __FILE__, ':', __LINE__ , &
                      & ': Error in accuracy at d(',ix,',',iy,',',iz,',',i,') =',inhoR(ix,iy,iz,i)
                 stop 2
              end if
           end do
        end do
     end do
  end do
!$omp end parallel do

  call feram_fftw_wisdom_timing(howmany, N_TIMES, Lx, Ly, Lz, padding_y, '  in', &
     &                              count_begin, count_end, count_rate, count_max)

  call fftw_free(inho_ptr)
end subroutine feram_fftw_SoA_in
