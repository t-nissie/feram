program cufft_check
  use cufft_module
  use, intrinsic :: iso_c_binding
  implicit none
  integer, parameter :: Nx = 120
  integer, parameter :: Ny = 150
  integer, parameter :: Nz = 180
  integer, parameter :: N  = Nx * Ny * Nz
  real*8,  parameter :: N_inv = 1.0d0/N
  integer            :: plan = 0
  integer            :: ret
  type(c_ptr),target :: z_device
  complex*16,allocatable,target :: z(:,:,:)
  complex*16           :: tmp
  complex*16,parameter :: z_check = (0.1d0, 0.2d0)
  real*8,    parameter :: accuracy = 1.0d-17
  integer              :: ix,iy,iz

  allocate(z(0:Nx-1, 0:Ny-1, 0:Nz-1))
  z(:,:,:) = z_check

  ret = cufftPlan3d(plan, Nx, Ny, Nz, CUFFT_Z2Z)
  write(6,*) 'pln', ret

  ret = cudaMalloc(c_loc(z_device), 16*N)
  write(6,*) 'mlc', ret

  ret = cudaMemcpy(z_device, c_loc(z), 16*N, cudaMemcpyHostToDevice);
  write(6,*) 'h2d', ret

  ret = cufftExecZ2Z(plan, z_device, z_device, CUFFT_FORWARD)
  write(6,*) 'z2z', ret

  ret = cudaMemcpy(c_loc(z), z_device, 16*N, cudaMemcpyDeviceToHost);
  write(6,*) 'd2h', ret

  do iz = 0, Nz-1
     do iy = 0, Ny-1
        do ix = 0, Nx-1
           tmp = z(ix,iy,iz) * N_inv
           if (ix.eq.0 .and. iy.eq.0 .and. iz.eq.0) then
              tmp = tmp - z_check
              if (abs(real(tmp))  > accuracy) then
                 write(0,'(a,a,i3,a)')   __FILE__, ':', __LINE__ ,  &
                      & ': Error in accuracy at real(z(0,0,0)).'
                 stop 1
              else if (abs(aimag(tmp)) > accuracy) then
                 write(0,'(a,a,i3,a)')   __FILE__, ':', __LINE__ ,  &
                      & ': Error in accuracy at aimag(z(0,0,0)).'
                 stop 2
              end if
           else if (abs(real(tmp))  > accuracy) then
              write(0,'(a,a,i3,a,3(i5,a))')   __FILE__, ':', __LINE__ ,  &
                   & ': Error in accuracy at real(z(',ix,',',iy,',',iz,')).'
              stop 3
           else if (abs(aimag(tmp))  > accuracy) then
              write(0,'(a,a,i3,a,3(i5,a))')   __FILE__, ':', __LINE__ ,  &
                   & ': Error in accuracy at aimag(z(',ix,',',iy,',',iz,')).'
              stop 4
           end if
        end do
     end do
  end do
     
  ret = cufftDestroy(plan)
  write(6,*) 'dst', ret

  ret = cudaFree(z_device)
  write(6,*) 'fre', ret
end program cufft_check
!Local variables:
!  compile-command: "gfortran -Wall -ffree-form -c cufft_module.f && gfortran -Wall -ffree-form -c cufft_check.F && gfortran -Wall -o cufft_check cufft_check.o cufft_module.o -L/usr/local/cuda/lib64 -lcufft -lcudart && ./cufft_check"
!End:
