! feram_fftw_1d.F -*-f90-*-
! Time-stamp: <2016-05-03 16:30:37 takeshi>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
program feram_fftw_1d
  use, intrinsic :: iso_c_binding
  implicit none
  include 'fftw3.f03'
  integer :: N_TIMES = 100
  integer :: n_average = 64
  integer :: flags = FFTW_MEASURE
  character(len=100) :: str = 'FFTW_MEASURE'
  integer :: OMP_GET_MAX_THREADS
  integer :: narg, ireturn
  type(C_PTR) :: plan_r2c_3_in  = c_null_ptr
  type(C_PTR) :: plan_c2r_3_in  = c_null_ptr

  ireturn = fftw_init_threads()
  call fftw_plan_with_nthreads(OMP_GET_MAX_THREADS())

  narg = command_argument_count()
  if (narg.eq.0) then
     ! default values
  else if (narg.eq.3) then
     call get_command_argument(1,str); read(str,*) N_TIMES
     call get_command_argument(2,str); read(str,*) n_average
     call get_command_argument(3,str)
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

  call feram_fftw_1d_in(3, N_TIMES, n_average, flags, &
       &                                                        plan_r2c_3_in, &
       &                                                        plan_c2r_3_in)

#ifndef WITH_FFT_MKL
  ireturn = fftw_export_wisdom_to_filename(C_CHAR_"wisdom_1d_new"//C_NULL_CHAR)
#endif
  call fftw_destroy_plan(plan_r2c_3_in)
  call fftw_destroy_plan(plan_c2r_3_in)
end program feram_fftw_1d
!local variables:
!  compile-command: "gfortran -I/usr/local/include -g -Wall -O3 -fopenmp -ffree-form -ffree-line-length-none feram_fftw_1d_in.F feram_fftw_1d.F -lfftw3_omp -lfftw3 -o feram_fftw_1d && ./feram_fftw_1d 100 1024 FFTW_MEASURE"
!End:
