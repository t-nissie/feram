! feram_fftw_wisdom.F -*-f90-*-
! Time-stamp: <2015-05-07 15:30:10 t-nissie>
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
  type(C_PTR) :: plan_r2c_3_in  = c_null_ptr
  type(C_PTR) :: plan_c2r_3_in  = c_null_ptr

  type(C_PTR) :: plan_r2c_6_in  = c_null_ptr
  type(C_PTR) :: plan_c2r_6_in  = c_null_ptr

  type(C_PTR) :: plan_r2c_3_out = c_null_ptr
  type(C_PTR) :: plan_c2r_3_out = c_null_ptr

  type(C_PTR) :: plan_r2c_6_out = c_null_ptr
  type(C_PTR) :: plan_c2r_6_out = c_null_ptr

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

  call feram_fftw_wisdom_in(3, N_TIMES, Lx, Ly, Lz, padding_y,  plan_r2c_3_in, &
       &                                                        plan_c2r_3_in)
  call feram_fftw_wisdom_in(6, N_TIMES, Lx, Ly, Lz, padding_y,  plan_r2c_6_in, &
       &                                                        plan_c2r_6_in)

  call feram_fftw_wisdom_out(3, N_TIMES, Lx, Ly, Lz, padding_y, plan_r2c_3_out, &
       &                                                        plan_c2r_3_out)
  call feram_fftw_wisdom_out(6, N_TIMES, Lx, Ly, Lz, padding_y, plan_r2c_6_out, &
       &                                                        plan_c2r_6_out)

#ifndef WITH_FFT_MKL
  ireturn = fftw_export_wisdom_to_filename(C_CHAR_"wisdom_new"//C_NULL_CHAR)
#endif
  call fftw_destroy_plan(plan_r2c_3_in)
  call fftw_destroy_plan(plan_c2r_3_in)
  call fftw_destroy_plan(plan_r2c_6_in)
  call fftw_destroy_plan(plan_c2r_6_in)
  call fftw_destroy_plan(plan_r2c_3_out)
  call fftw_destroy_plan(plan_c2r_3_out)
  call fftw_destroy_plan(plan_r2c_6_out)
  call fftw_destroy_plan(plan_c2r_6_out)
  call fftw_cleanup_threads()
end program feram_fftw_wisdom
