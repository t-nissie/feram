! feram_fftw_wisdom.F -*-f90-*-
! Time-stamp: <2015-05-01 12:18:33 takeshi>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif

program feram_fftw_wisdom
  use, intrinsic :: iso_c_binding
  implicit none
  include 'fftw3.f03'
  integer :: N_TIMES
  integer :: Lx
  integer :: Ly
  integer :: Lz
  integer :: padding_y
  character(len=100) :: str
  integer :: OMP_GET_MAX_THREADS
  integer :: narg, ireturn
  type(C_PTR) :: plan_r2c_3_out = c_null_ptr
  type(C_PTR) :: plan_c2r_3_out = c_null_ptr

  type(C_PTR) :: plan_r2c_6_out = c_null_ptr
  type(C_PTR) :: plan_c2r_6_out = c_null_ptr   ! It is not used in feram.

  ! type(C_PTR)             :: inho_ptr = c_null_ptr
  ! integer(C_SIZE_T) :: n_alloc_inho
  ! complex*16,pointer :: inhoK(:,:,:,:)
  ! real*8,    pointer :: inhoR(:,:,:,:)
  ! type(C_PTR) ::         plan_r2c_6_in  = c_null_ptr   ! It is not used in feram.
  ! type(C_PTR) ::         plan_c2r_6_in  = c_null_ptr

  ireturn = fftw_init_threads()
  call fftw_plan_with_nthreads(OMP_GET_MAX_THREADS())

  narg = command_argument_count()
  if (narg.eq.0) then
     ! default values
     N_TIMES = 1000
     Lx =  64
     Ly =  64
     Lz =  64
     padding_y = 3
  else if (narg.eq.5) then
     call get_command_argument(1,str); read(str,*) N_TIMES
     call get_command_argument(2,str); read(str,*) Lx
     call get_command_argument(3,str); read(str,*) Ly
     call get_command_argument(4,str); read(str,*) Lz
     call get_command_argument(5,str); read(str,*) padding_y
  else
     write(0,'(a,a,i3,a)') __FILE__, ':', __LINE__, ': Illegal number of arguments.'
     stop 1
  end if

  call feram_fftw_wisdom_out(3, N_TIMES, Lx, Ly, Lz, padding_y, plan_r2c_3_out, &
       &                                                        plan_c2r_3_out)
  call feram_fftw_wisdom_out(6, N_TIMES, Lx, Ly, Lz, padding_y, plan_r2c_6_out, &
       &                                                        plan_c2r_6_out)

! !=== plan_????? ===============================================================================
!   allocate(dipoR(6, 0:2*(Lx/2+1)-1, 0:Ly+padding_y-1, 0:Lz-1))
!   allocate(dipoK(6, 0:Lx/2,         0:Ly+padding_y-1, 0:Lz-1)) !"/2" for real<->complex FFT
! !!!first touch
! !$omp parallel do
!   do iz = 0,Lz-1
!      dipoR(:,:,:,iz) = 0.1d0
!   end do
! !$omp end parallel do
! !$omp parallel do
!   do iz = 0,Lz-1
!      dipoK(:,:,:,iz) = (0.0d0,0.0d0)
!   end do
! !$omp end parallel do

!   howmany = 6
!   stride = howmany
!   plan_R2C = fftw_plan_many_dft_r2c(rank,LzLyLx,howmany,&
!        &                              dipoR,d_embed,stride,dist,&
!        &                              dipoK,z_embed,stride,dist,FFTW_MEASURE)

! !$omp parallel do
!   do iz = 0,Lz-1
!      dipoR(:,:,:,iz) = 0.1d0
!   end do
! !$omp end parallel do

!   call fftw_execute_dft_r2c(plan_R2C, dipoR, dipoK)
!   write(6,*) dipoK(1,0,0,0)/N

!   call fftw_destroy_plan(plan_R2C)
!   deallocate(dipoR)
!   deallocate(dipoK)

! !=== plan_c2r_6_in ===============================================================================
!   howmany = 6
!   n_alloc_inho = howmany * (Lx/2+1) * (Ly+padding_y) * Lz
!   inho_ptr = fftw_alloc_complex(n_alloc_inho)
!   call c_f_pointer(inho_ptr, inhoK, [howmany,   (p%Lx/2+1), p%Ly+p%padding_y, p%Lz])
!     call c_f_pointer(inho_ptr, inhoR, [howmany, 2*(p%Lx/2+1), p%Ly+p%padding_y, p%Lz])
! !!!first touch!!! Here, indexes of arrays do not have to start from 0. It is simpler than dVddi_inho_coupling.F.
! !$omp parallel do
!     do iz = 1, p%Lz
!        inhoK(:,:,:,iz) = (0.0d0,0.0d0)
!     end do
! !$omp end parallel do
!     stride = howmany
!     plan_c2r_6_in = fftw_plan_many_dft_c2r(rank,LzLyLx,howmany,&
!          &                                   inhoK,z_embed,stride,dist,&
!          &                                   inhoR,d_embed,stride,dist,FFTW_MEASURE)




#ifndef WITH_FFT_MKL
  ireturn = fftw_export_wisdom_to_filename('wisdom_new')
#endif
  call fftw_cleanup_threads()

end program feram_fftw_wisdom
