! cufft_module.F -*-f90-*-
! Time-stamp: <2013-11-27 20:38:20 t-nissie>
! Author: Takeshi NISHIMATSU
! Reference: http://www.softek.co.jp/SPG/Pgi/TIPS/public/accel/cufft.html
!!
module cufft_module
  implicit none
  integer, parameter, public :: CUFFT_FORWARD = -1
  integer, parameter, public :: CUFFT_INVERSE =  1

  integer, parameter, public :: CUFFT_R2C = X"2a"
  integer, parameter, public :: CUFFT_C2R = X"2c"
  integer, parameter, public :: CUFFT_C2C = X"29"
  integer, parameter, public :: CUFFT_D2Z = X"6a"
  integer, parameter, public :: CUFFT_Z2D = X"6c"
  integer, parameter, public :: CUFFT_Z2Z = X"69"

  integer, parameter, public :: cudaMemcpyHostToHost     = 0
  integer, parameter, public :: cudaMemcpyHostToDevice   = 1
  integer, parameter, public :: cudaMemcpyDeviceToHost   = 2
  integer, parameter, public :: cudaMemcpyDeviceToDevice = 3
  integer, parameter, public :: cudaMemcpyDefault        = 4

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

  interface cufftExecZ2Z
     function cufftExecZ2Z(plan, idata, odata, direction) bind(C,name='cufftExecZ2Z')
       use iso_c_binding
       implicit none
       integer(c_int)            :: cufftExecZ2Z
       integer(c_int), value     :: plan
       complex(c_double_complex) :: idata, odata
       integer(c_int), value     :: direction
     end function cufftExecZ2Z
  end interface
end module cufft_module

!Local variables:
!  compile-command: "gfortran -Wall -ffree-form -c cufft_module.f && gfortran -Wall -ffree-form -c cufft_check.f && gfortran -Wall -o cufft_check cufft_check.o cufft_module.o -L/usr/local/cuda/lib64 -lcufft -lcudart && ./cufft_check"
!End:
