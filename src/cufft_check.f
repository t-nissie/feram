program cufft_check
  use cufft_module
  implicit none
  integer, parameter :: Nx=100
  integer, parameter :: Ny=100
  integer, parameter :: Nz=100
  integer            :: plan
  integer            :: ret
  complex*16         :: z(0:Nx-1, 0:Ny-1, 0:Nz-1)

  z(:,:,:) = (0.1d0, 0.2d0)

  ret = cufftPlan3d(plan, Nx, Ny, Nz, CUFFT_Z2Z)

  ret = cufftExecZ2Z(plan, z(0,0,0), z(0,0,0), CUFFT_FORWARD)

  write(6,*) z(0,0,0)/Nx/Ny/Nz
  write(6,*) z(0,0,1)/Nx/Ny/Nz

  ret = cufftDestroy(plan)
end program cufft_check
!Local variables:
!  compile-command: "gfortran -Wall -ffree-form -c cufft_module.f && gfortran -Wall -ffree-form -c cufft_check.f && gfortran -Wall -o cufft_check cufft_check.o cufft_module.o -L/usr/local/cuda/lib64 -lcufft -lcudart && ./cufft_check"
!End:
