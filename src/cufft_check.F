program cufft_check
  use cufft_module
  use, intrinsic :: iso_c_binding
  implicit none
  integer, parameter :: Nx=100
  integer, parameter :: Ny=100
  integer, parameter :: Nz=100
  integer            :: plan = 0
  integer            :: ret
  type(c_ptr),target :: z_device
  complex*16,target  :: z(0:Nx-1, 0:Ny-1, 0:Nz-1)

  complex*16           :: tmp
  complex*16,parameter :: z_check = (0.1d0, 0.2d0)
  real*8,    parameter :: accuracy = 1.0d-14

  ret = cufftPlan3d(plan, Nx, Ny, Nz, CUFFT_Z2Z)
  write(6,*) 'pln', ret

  z(:,:,:) = z_check

  !write(6,*) z_device
  ret = cudaMalloc(c_loc(z_device),16*Nx*Ny*Nz)
  write(6,*) 'mlc', ret
  !write(6,*) '1: z_device = ', z_device

  ret = cudaMemcpy(z_device, c_loc(z), 16*Nx*Ny*Nz, cudaMemcpyHostToDevice);
  write(6,*) 'h2d', ret
  !write(6,*) '2: z_device = ', z_device

  z(:,:,:) = (0.0d0, 0.0d0)

  ret = cufftExecZ2Z(plan, z_device, z_device, CUFFT_FORWARD)
  write(6,*) 'z2z', ret

  ret = cudaMemcpy(c_loc(z), z_device, 16*Nx*Ny*Nz, cudaMemcpyDeviceToHost);
  write(6,*) 'd2h', ret

  tmp = z(0,0,0)/Nx/Ny/Nz - z_check
  if (abs(aimag(tmp)) > accuracy) then
     write(0,'(a,a,i3,a)')   __FILE__, ':', __LINE__ ,  &
          & ': Error in accuracy at aimag(z(0,0,0)).'
     stop 1
  end if
  
  write(6,*) z(0,0,1)

  ret = cufftDestroy(plan)
  write(6,*) 'dst', ret

  ret = cudaFree(z_device)
  write(6,*) 'fre', ret
end program cufft_check
!Local variables:
!  compile-command: "gfortran -Wall -ffree-form -c cufft_module.f && gfortran -Wall -ffree-form -c cufft_check.f && gfortran -Wall -o cufft_check cufft_check.o cufft_module.o -L/usr/local/cuda/lib64 -lcufft -lcudart && ./cufft_check"
!End:
