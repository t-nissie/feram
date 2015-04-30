! feram_fftw_wisdom.F -*-f90-*-
! Time-stamp: <2015-04-30 18:32:05 t-nissie>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif

program feram_fftw_wisdom
  use, intrinsic :: iso_c_binding
  implicit none
  character(len=100) :: str
  integer i,ix,iy,iz
  real*8,     allocatable :: dipoR(:,:,:,:)   ! Optical dipole displacements as a function of R
  complex*16, allocatable :: dipoK(:,:,:,:)   ! FT of dipoQ

  integer                 :: c_ri(0:1)   ! count
  real*8                  :: t_ri        ! time
  real*8                  :: g_ri        ! GFLOPS
  real*8                  :: f_r         ! The numbers of floating point operations in [G]
  integer                 :: count_rate, count_max

  integer :: OMP_GET_MAX_THREADS
  integer :: ireturn
  type(C_PTR) :: plan_R2C
  type(C_PTR) :: plan_C2R

  include 'fftw3.f03'
  integer howmany,stride
  integer :: N_TIMES
  integer :: Lx
  integer :: Ly
  integer :: Lz
  integer :: padding_y
  integer, parameter :: rank=3
  integer, parameter :: dist=1
  real*8  :: N_inv
  integer :: N
  integer ::  LzLyLx(3)
  integer :: d_embed(3)
  integer :: z_embed(3)

  ireturn = fftw_init_threads()
  call fftw_plan_with_nthreads(OMP_GET_MAX_THREADS())

  i = command_argument_count()
  if (i.eq.0) then
     ! default values
     N_TIMES = 1000
     Lx =  64
     Ly =  64
     Lz =  64
     padding_y = 3
  else if (i.eq.5) then
     call get_command_argument(1,str); read(str,*) N_TIMES
     call get_command_argument(2,str); read(str,*) Lx
     call get_command_argument(3,str); read(str,*) Ly
     call get_command_argument(4,str); read(str,*) Lz
     call get_command_argument(5,str); read(str,*) padding_y
  else
     write(0,'(a,a,i3,a)') __FILE__, ':', __LINE__, ': Illegal number of arguments.'
     stop 1
  end if

  LzLyLx( 1)=Lz; LzLyLx( 2)=Ly;           LzLyLx( 3)=Lx
  d_embed(1)=Lz; d_embed(2)=Ly+padding_y; d_embed(3)=2*(Lx/2+1)
  z_embed(1)=Lz; z_embed(2)=Ly+padding_y; z_embed(3)=   Lx/2+1
  N = Lx * Ly *Lz
  N_inv = 1.0d0/N

  allocate(dipoR(3, 0:2*(Lx/2+1)-1, 0:Ly+padding_y-1, 0:Lz-1))
  allocate(dipoK(3, 0:Lx/2,         0:Ly+padding_y-1, 0:Lz-1)) !"/2" for real<->complex FFT

!!!first touch
!$omp parallel do
  do iz = 0,Lz-1
     dipoR(:,:,:,iz) = 0.1d0
  end do
!$omp end parallel do
!$omp parallel do
  do iz = 0,Lz-1
     dipoK(:,:,:,iz) = (0.0d0,0.0d0)
  end do
!$omp end parallel do

  howmany = 3
  stride = howmany
  plan_R2C = fftw_plan_many_dft_r2c(rank,LzLyLx,howmany,&
       &                              dipoR,d_embed,stride,dist,&
       &                              dipoK,z_embed,stride,dist,FFTW_MEASURE)
  plan_C2R = fftw_plan_many_dft_c2r(rank,LzLyLx,howmany,&
       &                              dipoK,z_embed,stride,dist,&
       &                              dipoR,d_embed,stride,dist,FFTW_MEASURE)

!$omp parallel do
  do iz = 0,Lz-1
     dipoR(:,:,:,iz) = 0.1d0
  end do
!$omp end parallel do

  call system_clock(c_ri(0))
  do i = 1, N_TIMES
     call fftw_execute_dft_r2c(plan_R2C, dipoR, dipoK)
!$omp parallel do
     do iz = 0,Lz-1
        dipoK(:,:,:,iz) = dipoK(:,:,:,iz) * N_inv
     end do
!$omp end parallel do
     call fftw_execute_dft_c2r(plan_C2R, dipoK, dipoR)
  end do
  call system_clock(c_ri(1), count_rate, count_max)

!$omp parallel do private(iz, iy, ix, i)
  do iz = 0, Lz-1
     do iy = 0, Ly-1
        do ix = 0, Lx-1
           do i = 1, howmany
              if (isnan(dipoR(i,ix,iy,iz)) .or. abs(dipoR(i,ix,iy,iz)-0.1d0)>1.0d-15) then
                 write(0,'(a,a,i3,a,4(i5,a),f21.16)')   __FILE__, ':', __LINE__ ,  &
                      & ': Error in accuracy at d(',i,',',ix,',',iy,',',iz,') =',dipoR(i,ix,iy,iz)
                 stop 2
              end if
           end do
        end do
     end do
  end do
!$omp end parallel do

  t_ri = dble(c_ri(1)-c_ri(0))/count_rate
  if (t_ri<0.0d0) t_ri=t_ri+dble(count_max)/count_rate
  f_r = log(dble(N)) / log(2.0d0) / 1.0d9 * N_TIMES * 5 * N * howmany
  g_ri = f_r / t_ri

  ! Use the same output format with fft_many_check.F
  write(6,'(i8,4i5,i11,L3,  f8.3,f8.3)') N_TIMES, Lx, Ly, Lz, padding_y, N, .false.,  t_ri, g_ri

  call fftw_destroy_plan(plan_R2C)
  call fftw_destroy_plan(plan_C2R)
  deallocate(dipoR)
  deallocate(dipoK)

  allocate(dipoR(6, 0:2*(Lx/2+1)-1, 0:Ly+padding_y-1, 0:Lz-1))
  allocate(dipoK(6, 0:Lx/2,         0:Ly+padding_y-1, 0:Lz-1)) !"/2" for real<->complex FFT

!!!first touch
!$omp parallel do
  do iz = 0,Lz-1
     dipoR(:,:,:,iz) = 0.1d0
  end do
!$omp end parallel do
!$omp parallel do
  do iz = 0,Lz-1
     dipoK(:,:,:,iz) = (0.0d0,0.0d0)
  end do
!$omp end parallel do

  howmany = 6
  stride = howmany
  plan_R2C = fftw_plan_many_dft_r2c(rank,LzLyLx,howmany,&
       &                              dipoR,d_embed,stride,dist,&
       &                              dipoK,z_embed,stride,dist,FFTW_MEASURE)

!$omp parallel do
  do iz = 0,Lz-1
     dipoR(:,:,:,iz) = 0.1d0
  end do
!$omp end parallel do

  call fftw_execute_dft_r2c(plan_R2C, dipoR, dipoK)
  write(6,*) dipoK(1,0,0,0)/N

  call fftw_destroy_plan(plan_R2C)
  deallocate(dipoR)
  deallocate(dipoK)
#ifndef WITH_FFT_MKL
  ireturn = fftw_export_wisdom_to_filename('wisdom_new')
#endif
  call fftw_cleanup_threads()

end program feram_fftw_wisdom
