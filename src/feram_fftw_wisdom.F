! feram_fftw_wisdom.F -*-f90-*-
! Time-stamp: <2015-12-09 14:54:38 takeshi>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
program feram_fftw_wisdom
  use, intrinsic :: iso_c_binding
  implicit none
  include 'fftw3.f03'
  integer :: N_TIMES = 100
  integer :: Lx = 64
  integer :: Ly = 64
  integer :: Lz = 64
  integer :: padding_y = 1
  integer :: flags = FFTW_MEASURE
  character(len=100) :: str = 'FFTW_MEASURE'
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
  else if (narg.eq.6) then
     call get_command_argument(1,str); read(str,*) N_TIMES
     call get_command_argument(2,str); read(str,*) Lx
     call get_command_argument(3,str); read(str,*) Ly
     call get_command_argument(4,str); read(str,*) Lz
     call get_command_argument(5,str); read(str,*) padding_y
     call get_command_argument(6,str)
     select case(str)
     case(     'FFTW_ESTIMATE')
        flags = FFTW_ESTIMATE
     case(     'FFTW_PATIENT')
        flags = FFTW_PATIENT
     case(     'FFTW_MEASURE')
        flags = FFTW_MEASURE
     case(     'FFTW_EXHAUSTIVE')
        flags = FFTW_EXHAUSTIVE
     case default
        write(0,   '(a,a,i2,a)') __FILE__, ':', __LINE__, ': No such FFTW flag.'
        stop 2
     end select
  else
     write(0,   '(a,a,i2,a)') __FILE__, ':', __LINE__, ': Illegal number of arguments.'
     stop 1
  end if
  write(0,'(a,a,i2,a)') __FILE__, ':', __LINE__, ': flags = '//trim(str)

   call feram_fftw_wisdom_in(3, N_TIMES, Lx, Ly, Lz, padding_y, flags, &
       &                                                        plan_r2c_3_in, &
       &                                                        plan_c2r_3_in)
   call feram_fftw_wisdom_in(6, N_TIMES, Lx, Ly, Lz, padding_y, flags, &
       &                                                        plan_r2c_6_in, &
       &                                                        plan_c2r_6_in)

  call feram_fftw_wisdom_out(3, N_TIMES, Lx, Ly, Lz, padding_y, flags, &
       &                                                        plan_r2c_3_out, &
       &                                                        plan_c2r_3_out)
  call feram_fftw_wisdom_out(6, N_TIMES, Lx, Ly, Lz, padding_y, flags, &
       &                                                        plan_r2c_6_out, &
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
