program cufft_check
  use cufft_module
  use, intrinsic :: iso_c_binding
  implicit none
  character(len=100) :: str
  integer :: N_TIMES
  integer :: Lx
  integer :: Ly
  integer :: Lz
  integer :: N
  integer :: N_half
  real*8  :: N_inv
  integer            :: plan_forward = 0
  integer            :: plan_backward = 0
  integer            :: ret
  type(c_ptr),target :: devptr
  complex*16,allocatable,target :: z(:,:,:)
  real*8,    allocatable,target :: d(:,:,:)
  complex*16           :: tmp
  complex*16,parameter :: z_check = (0.1d0, 0.2d0)
  real*8,    parameter :: d_check = 0.3d0
  real*8,    parameter :: accuracy = 1.0d-15
  integer              :: i,ix,iy,iz
  integer                 :: c_ri(0:1)   ! count
  real*8                  :: t_ri        ! time
  real*8                  :: g_ri        ! GFLOPS
  real*8                  :: f_r         ! The numbers of floating point operations in [G]
  integer                 :: count_rate, count_max

  i = command_argument_count()
  if (i.eq.0) then
     ! default values
     N_TIMES = 1000
     Lx =  80
     Ly =  90
     Lz = 100
  else if (i.eq.4) then
     call get_command_argument(1,str); read(str,*) N_TIMES
     call get_command_argument(2,str); read(str,*) Lx
     call get_command_argument(3,str); read(str,*) Ly
     call get_command_argument(4,str); read(str,*) Lz
  else
     write(0,'(a,a,i3,a)') __FILE__, ':', __LINE__, ': Illegal number of arguments.'
     stop 1
  end if
  N  = Lx * Ly * Lz
  N_half  = (Lx/2+1)*Ly*Lz
  N_inv = 1.0d0/N
  write(0,'(i8,3i5,i11)') N_TIMES, Lx, Ly, Lz, N

  allocate(z(0:Lx-1, 0:Ly-1, 0:Lz-1))
  z(:,:,:) = z_check

  ret = cufftPlan3d(plan_forward, Lz, Ly, Lx, CUFFT_Z2Z)   !Note order of Lz, Ly, Lx!
  write(0,*) 'plan z2z', ret

  ret = cudaMalloc(c_loc(devptr), 16*N)
  write(0,*) 'malloc 1', ret

  ret = cudaMemcpy(devptr, c_loc(z), 16*N, cudaMemcpyHostToDevice)
  write(0,*) 'mcpy h2d', ret

  ret = cufftExecZ2Z(plan_forward, devptr, devptr, CUFFT_FORWARD)
  write(0,*) 'exec z2z', ret

  call cublasDscal(2*N, N_inv, devptr, 1)

  ret = cudaMemcpy(c_loc(z), devptr, 16*N, cudaMemcpyDeviceToHost)
  write(0,*) 'mcpy d2h', ret

!$omp parallel do private(iz, iy, ix, tmp)
  do iz = 0, Lz-1
     do iy = 0, Ly-1
        do ix = 0, Lx-1
           tmp = z(ix,iy,iz)
           if (ix.eq.0 .and. iy.eq.0 .and. iz.eq.0) then
              tmp = tmp - z_check
              if (abs(real(tmp))  > accuracy) then
                 write(0,'(a,a,i3,a,f21.16,a,d19.10)')   __FILE__, ':', __LINE__ ,  &
                      & ': Error in accuracy at real(z(0,0,0)) =',real(z(0,0,0)), &
                      & 'diff =',abs(real(tmp))
                 stop 1
              else if (abs(aimag(tmp)) > accuracy) then
                 write(0,'(a,a,i3,a,f21.16,a,d19.10)')   __FILE__, ':', __LINE__ ,  &
                      & ': Error in accuracy at aimag(z(0,0,0)) =',aimag(z(0,0,0)), &
                      & 'diff =',abs(aimag(tmp))
                 stop 2
              end if
           else if (abs(real(tmp))  > accuracy) then
              write(0,'(a,a,i3,a,3(i5,a),f21.16,a,d19.10)')   __FILE__, ':', __LINE__ ,  &
                   & ': Error in accuracy at real(z(',ix,',',iy,',',iz,')) =',real(tmp), &
                      & 'diff =',abs(real(tmp))
              stop 3
           else if (abs(aimag(tmp))  > accuracy) then
              write(0,'(a,a,i3,a,3(i5,a),f21.16,a,d19.10)')   __FILE__, ':', __LINE__ ,  &
                   & ': Error in accuracy at aimag(z(',ix,',',iy,',',iz,')) =',aimag(tmp), &
                      & ', diff =',abs(aimag(tmp))
              stop 4
           end if
        end do
     end do
  end do
!$omp end parallel do

  ret = cufftDestroy(plan_forward)
  write(0,*) 'destroy ', ret

  ret = cudaFree(devptr)
  write(0,*) 'free dev', ret

  deallocate(z)

  allocate( d(0:2*(Lx/2+1)-1, 0:Ly-1, 0:Lz-1), &
       &    z(0:Lx/2,         0:Ly-1, 0:Lz-1) )
  d(:,:,:) = d_check

  ret = cufftPlan3d(plan_forward,  Lz, Ly, Lx, CUFFT_D2Z)   !Note order of Lz, Ly, Lx!
  write(0,*) 'plan d2z', ret
  ret = cufftPlan3d(plan_backward, Lz, Ly, Lx, CUFFT_Z2D)   !Note order of Lz, Ly, Lx!
  write(0,*) 'plan z2d', ret

  ret = cudaMalloc(c_loc(devptr), 16*N_half)
  write(0,*) 'malloc 2', ret

  ret = cudaMemcpy(devptr, c_loc(d), 16*N_half, cudaMemcpyHostToDevice)
  write(0,*) 'mcpy h z', ret

  call system_clock(c_ri(0))
  do i = 1, N_TIMES
     ret = cufftExecD2Z(plan_forward,  devptr, devptr, CUFFT_FORWARD)
     call cublasDscal(2*N_half, N_inv, devptr, 1)
     ret = cufftExecZ2D(plan_backward, devptr, devptr, CUFFT_INVERSE)
  end do
  ret = cudaThreadSynchronize()
  call system_clock(c_ri(1), count_rate, count_max)
  write(0,*) 'thrd syn', ret

  ret = cudaMemcpy(c_loc(d), devptr, 16*N_half, cudaMemcpyDeviceToHost)
  write(0,*) 'mcpy h d', ret
!$omp parallel do private(iz, iy, ix)
  do iz = 0, Lz-1
     do iy = 0, Ly-1
        do ix = 0, Lx-1
           if (abs(d(ix,iy,iz)-d_check)>d_check*accuracy) then
              write(0,'(a,a,i3,a,3(i5,a),f21.16)')   __FILE__, ':', __LINE__ ,  &
                   & ': Error in accuracy at d(',ix,',',iy,',',iz,') =',d(ix,iy,iz)
           end if
        end do
     end do
  end do
!$omp end parallel do

  t_ri = dble(c_ri(1)-c_ri(0))/count_rate
  if (t_ri<0.0d0) t_ri=t_ri+dble(count_max)/count_rate
  f_r = log(dble(N)) / log(2.0d0) / 1.0d9 * N_TIMES * 5 * N
  g_ri = f_r / t_ri

  write(6,'(i8,3i5,i11,  f8.3,f8.3)') N_TIMES, Lx, Ly, Lz, N,  t_ri, g_ri

  ret = cufftDestroy(plan_forward)
  write(0,*) 'destroy ', ret

  ret = cufftDestroy(plan_backward)
  write(0,*) 'destroy ', ret

  ret = cudaFree(devptr)
  write(0,*) 'free dev', ret

  deallocate(d,z)
end program cufft_check
!Local variables:
!  compile-command: "gfortran -Wall -fopenmp -ffree-form -c cufft_module.f && gfortran -Wall -fopenmp -ffree-form -c cufft_check.F && gfortran -Wall -fopenmp -o cufft_check cufft_check.o cufft_module.o -L/usr/local/cuda/lib64 -lcublas -lcufft -lcudart && ./cufft_check"
!End:
