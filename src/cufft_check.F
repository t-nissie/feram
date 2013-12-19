program cufft_check
  use cufft_module
  use, intrinsic :: iso_c_binding
  implicit none
  integer, parameter :: Lx = 120
  integer, parameter :: Ly = 150
  integer, parameter :: Lz = 180
  integer, parameter :: N  = Lx * Ly * Lz
  integer, parameter :: N_half  = (Lx/2+1)*Ly*Lz
  real*8,  parameter :: N_inv = 1.0d0/N
  integer            :: plan_forward = 0
  integer            :: plan_backward = 0
  integer            :: ret
  type(c_ptr),target :: devptr
  complex*16,allocatable,target :: z(:,:,:)
  real*8,    allocatable,target :: d(:,:,:)
  complex*16           :: tmp
  complex*16,parameter :: z_check = (0.1d0, 0.2d0)
  real*8,    parameter :: d_check = 0.01d0
  real*8,    parameter :: accuracy = 1.0d-17
  integer              :: ix,iy,iz

  allocate(z(0:Lx-1, 0:Ly-1, 0:Lz-1))
  z(:,:,:) = z_check

  ret = cufftPlan3d(plan_forward, Lx, Ly, Lz, CUFFT_Z2Z)
  write(6,*) 'plan z2z', ret

  ret = cudaMalloc(c_loc(devptr), 16*N)
  write(6,*) 'malloc 1', ret

  ret = cudaMemcpy(devptr, c_loc(z), 16*N, cudaMemcpyHostToDevice)
  write(6,*) 'mcpy h2d', ret

  ret = cufftExecZ2Z(plan_forward, devptr, devptr, CUFFT_FORWARD)
  write(6,*) 'exec z2z', ret

  call cublasDscal(2*N, N_inv, devptr, 1)

  ret = cudaMemcpy(c_loc(z), devptr, 16*N, cudaMemcpyDeviceToHost)
  write(6,*) 'mcpy d2h', ret

  do iz = 0, Lz-1
     do iy = 0, Ly-1
        do ix = 0, Lx-1
           tmp = z(ix,iy,iz)
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
     
  ret = cufftDestroy(plan_forward)
  write(6,*) 'destroy ', ret

  ret = cudaFree(devptr)
  write(6,*) 'free dev', ret

  deallocate(z)

  allocate( d(0:2*(Lx/2+1)-1, 0:Ly-1, 0:Lz-1), &
       &    z(0:Lx/2,         0:Ly-1, 0:Lz-1) )
  d(:,:,:) = d_check

  ret = cufftPlan3d(plan_forward,  Lx, Ly, Lz, CUFFT_D2Z)
  write(6,*) 'plan d2z', ret
  ret = cufftPlan3d(plan_backward, Lx, Ly, Lz, CUFFT_Z2D)
  write(6,*) 'plan z2d', ret

  ret = cudaMalloc(c_loc(devptr), 16*N_half)
  write(6,*) 'malloc 2', ret

  ret = cudaMemcpy(devptr, c_loc(d), 16*N_half, cudaMemcpyHostToDevice)
  write(6,*) 'mcpy h z', ret

  ret = cufftExecD2Z(plan_forward, devptr, devptr, CUFFT_FORWARD)
  write(6,*) 'exec d2z', ret

  call cublasDscal(2*N_half, N_inv, devptr, 1)

  ret = cudaMemcpy(c_loc(z), devptr, 16*N_half, cudaMemcpyDeviceToHost)
  write(6,*) 'mcpy h d', ret

  write(6,*) z(0,0,0)
  write(6,*) z(1,0,0)

  deallocate(d,z)
end program cufft_check
!Local variables:
!  compile-command: "gfortran -Wall -ffree-form -c cufft_module.f && gfortran -Wall -ffree-form -c cufft_check.F && gfortran -Wall -o cufft_check cufft_check.o cufft_module.o -L/usr/local/cuda/lib64 -lcublas -lcufft -lcudart && ./cufft_check"
!End:
