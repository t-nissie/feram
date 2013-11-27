! cufft_module.F -*-f90-*-
! Time-stamp: <2013-11-27 18:44:33 takeshi>
! Author: Takeshi NISHIMATSU
! Reference: http://www.softek.co.jp/SPG/Pgi/TIPS/public/accel/cufft.html
!!
module cufft_module
  implicit none
  integer, parameter, public :: CUFFT_FORWARD = -1
  integer, parameter, public :: CUFFT_INVERSE = 1
  integer, parameter, public :: CUFFT_R2C=X"2a"
  integer, parameter, public :: CUFFT_C2R=X"2c"
  integer, parameter, public :: CUFFT_C2C=X"29"
  integer, parameter, public :: cudaMemcpyHostToDevice=1
  integer, parameter, public :: cudaMemcpyDeviceToHost=2

  interface cufftPlan3d
     function cufftPlan3d(plan, nx, ny, nz, type) bind(C,name='cufftPlan3d')
       use iso_c_binding
       implicit none
       integer(c_int)        :: cufftPlan3d
       integer(c_int)        :: plan
       integer(c_int), value :: nx, ny, nz, type
     end function cufftPlan3d
  end interface

  interface cufftDestroy
     function cufftDestroy(plan) bind(C,name='cufftDestroy')
       use iso_c_binding
       implicit none
       integer(c_int):: cufftDestroy
       integer(c_int),value:: plan
     end function cufftDestroy
  end interface

end module cufft_module

!Local variables:
!  compile-command: "gfortran -Wall -ffree-form -c cufft_module.F && gfortran -Wall -ffree-form -c cufft_check.F && gfortran -Wall -o cufft_check.o cufft_module.o -L/usr/local/cuda/lib64 -lcufft -lcudart"
!End:
