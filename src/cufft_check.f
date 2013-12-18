program cufft_check
  use cufft_module
  use, intrinsic :: iso_c_binding
  implicit none
  integer, parameter :: Nx=100
  integer, parameter :: Ny=100
  integer, parameter :: Nz=100
  integer            :: plan = 0
  integer            :: ret!, f_cudafree
  integer            :: f_cudamemcpy_host_to_device
  integer            :: f_cudamemcpy_device_to_host
  integer            :: f_cufftExecZ2Z
  integer*8,target   :: z_device = 0
  complex*16         :: z(0:Nx-1, 0:Ny-1, 0:Nz-1)

  ret = cufftPlan3d(plan, Nx, Ny, Nz, CUFFT_Z2Z)
  write(6,*) 'pln', ret

  z(:,:,:) = (0.1d0, 0.2d0)

  !write(6,*) z_device
  ret = cudamalloc(c_loc(z_device),16*Nx*Ny*Nz)
  write(6,*) 'mlc', ret
  !write(6,*) '1: z_device = ', z_device

  ret = f_cudamemcpy_host_to_device(z, z_device, 16*Nx*Ny*Nz);
  write(6,*) 'h2d', ret
  !write(6,*) '2: z_device = ', z_device

  z(:,:,:) = (0.0d0, 0.0d0)

  ret = f_cufftExecZ2Z(plan, z_device, z_device, CUFFT_FORWARD)
  write(6,*) 'z2z', ret

  ret = f_cudamemcpy_device_to_host(z_device, z, 16*Nx*Ny*Nz);
  write(6,*) 'd2h', ret

  write(6,*) z(0,0,0)/Nx/Ny/Nz
  write(6,*) z(0,0,1)

  ret = cufftDestroy(plan)
  write(6,*) 'dst', ret

  ret = cudafree(z_device)
  write(6,*) 'fre', ret
end program cufft_check
!Local variables:
!  compile-command: "gfortran -Wall -ffree-form -c cufft_module.f && gcc -I/usr/local/cuda/include -c cufft_functions.c && gfortran -Wall -ffree-form -c cufft_check.f && gfortran -Wall -o cufft_check cufft_check.o cufft_functions.o cufft_module.o -L/usr/local/cuda/lib64 -lcufft -lcudart && ./cufft_check"
!End:
