! cufft_module.f -*-f90-*-
! Time-stamp: <2013-12-21 13:58:06 t-nissie>
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

  integer, parameter, public :: cudaMemcpyHostToHost     = 0 ! Host   -> Host
  integer, parameter, public :: cudaMemcpyHostToDevice   = 1 ! Host   -> Device
  integer, parameter, public :: cudaMemcpyDeviceToHost   = 2 ! Device -> Host
  integer, parameter, public :: cudaMemcpyDeviceToDevice = 3 ! Device -> Device
  integer, parameter, public :: cudaMemcpyDefault        = 4 ! Default based unified virtual address space

  interface cudaMalloc
     function cudaMalloc(dv,n) bind(C,name='cudaMalloc')
       use, intrinsic :: iso_c_binding
       implicit none
       integer(c_int)        :: cudaMalloc
       type(c_ptr),value     :: dv
       integer(c_int), value :: n
     end function cudaMalloc
  end interface

  interface cudaFree
     function cudaFree(devPtr) bind(C,name='cudaFree')
       use, intrinsic :: iso_c_binding
       implicit none
       integer(c_int)    :: cudaFree
       type(c_ptr),value :: devPtr
     end function cudaFree
  end interface

  interface cudaMemcpy
     function cudaMemcpy(dst, src, count, kind) bind(C,name='cudaMemcpy')
       use, intrinsic :: iso_c_binding
       implicit none
       integer(c_int)       :: cudaMemcpy
       type(c_ptr),value    :: dst, src
       integer(c_int),value :: count, kind
     end function cudaMemcpy
  end interface

  interface cufftPlan3d
     function cufftPlan3d(plan, nx, ny, nz, type) bind(C,name='cufftPlan3d')
       use, intrinsic :: iso_c_binding
       implicit none
       integer(c_int)        :: cufftPlan3d
       integer(c_int)        :: plan
       integer(c_int), value :: nx, ny, nz, type
     end function cufftPlan3d
  end interface

  interface cufftExecZ2Z
     function cufftExecZ2Z(plan,id,od,direction) bind(C,name='cufftExecZ2Z')
       use, intrinsic :: iso_c_binding
       implicit none
       integer(c_int)        :: cufftExecZ2Z
       integer(c_int), value :: plan, direction
       type(c_ptr),value     :: id, od
     end function cufftExecZ2Z
  end interface

  interface cufftExecD2Z
     function cufftExecD2Z(plan,id,od,direction) bind(C,name='cufftExecD2Z')
       use, intrinsic :: iso_c_binding
       implicit none
       integer(c_int)        :: cufftExecD2Z
       integer(c_int), value :: plan, direction
       type(c_ptr),value     :: id, od
     end function cufftExecD2Z
  end interface

  interface cufftExecZ2D
     function cufftExecZ2D(plan,id,od,direction) bind(C,name='cufftExecZ2D')
       use, intrinsic :: iso_c_binding
       implicit none
       integer(c_int)        :: cufftExecZ2D
       integer(c_int), value :: plan, direction
       type(c_ptr),value     :: id, od
     end function cufftExecZ2D
  end interface

  interface cublasDscal
     subroutine cublasDscal(n, alpha, x, incx) bind(C,name='cublasDscal')
       use, intrinsic :: iso_c_binding
       implicit none
       integer(c_int), value :: n, incx
       real(c_double), value :: alpha
       type(c_ptr),    value :: x
     end subroutine cublasDscal
  end interface

  interface cufftDestroy
     function cufftDestroy(plan) bind(C,name='cufftDestroy')
       use, intrinsic :: iso_c_binding
       implicit none
       integer(c_int)       :: cufftDestroy
       integer(c_int),value :: plan
     end function cufftDestroy
  end interface
end module cufft_module
!Local variables:
!  compile-command: "gfortran -Wall -ffree-form -c cufft_module.f && gfortran -Wall -ffree-form -c cufft_check.F && gfortran -Wall -o cufft_check cufft_check.o cufft_module.o -L/usr/local/cuda/lib64 -lcublas -lcufft -lcudart && ./cufft_check"
!End:
