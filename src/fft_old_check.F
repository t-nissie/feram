! fft_old_check.F -*-f90-*-
! Time-stamp: <2014-04-22 13:54:28 takeshi>
! Author: Takeshi NISHIMATSU
!!
program fft_old_check
  use, intrinsic :: iso_c_binding
  implicit none
  include 'fftw3.f03'
  character(len=100) :: str
  integer :: N_TIMES
  integer :: Lx
  integer :: Ly
  integer :: Lz
  integer :: padding_y
  logical :: in_or_out
  integer :: N
  integer :: N_half
  real*8  :: N_inv
  integer :: OMP_GET_MAX_THREADS
  integer :: ret, i,ix,iy,iz, rank, LzLyLx(3), howmany, d_dist, d_embed(3), stride, z_dist, z_embed(3)
  type(C_PTR) :: plan_r2c, plan_c2r, d_ptr, z_ptr
  integer(C_SIZE_T) :: n_tmp
  real*8,    pointer :: d_linear(:)
  real*8,    pointer :: d(:,:,:,:)
  complex*16,pointer :: z_linear(:)
  complex*16,pointer :: z(:,:,:,:)
  integer                 :: c_ri(0:1)   ! count
  real*8                  :: t_ri        ! time
  real*8                  :: g_ri        ! GFLOPS
  real*8                  :: f_r         ! The numbers of floating point operations in [G]
  integer                 :: count_rate, count_max

  ret = fftw_init_threads()
  call fftw_plan_with_nthreads(OMP_GET_MAX_THREADS())

  i = command_argument_count()
  if (i.eq.0) then
     ! default values
     N_TIMES = 1000
     Lx =  64
     Ly =  64
     Lz =  64
     padding_y = 3
     in_or_out = .true.
  else if (i.eq.6) then
     call get_command_argument(1,str); read(str,*) N_TIMES
     call get_command_argument(2,str); read(str,*) Lx
     call get_command_argument(3,str); read(str,*) Ly
     call get_command_argument(4,str); read(str,*) Lz
     call get_command_argument(5,str); read(str,*) padding_y
     call get_command_argument(6,str); read(str,*) in_or_out
  else
     write(0,'(a,a,i3,a)') __FILE__, ':', __LINE__, ': Illegal number of arguments.'
     stop 1
  end if
  N  = Lx * Ly * Lz
  N_half  = (Lx/2+1)*Ly*Lz
  N_inv = 1.0d0/N
  write(0,'(i8,4i5,i11,l3)') N_TIMES, Lx, Ly, Lz, padding_y, N, in_or_out

  LzLyLx(1) = Lz
  LzLyLx(2) = Ly
  LzLyLx(3) = Lx
  d_embed(1) = Lz
  d_embed(2) = Ly+padding_y
  d_embed(3) = 2*(Lx/2+1)
  z_embed(1) = Lz
  z_embed(2) = Ly+padding_y
  z_embed(3) = Lx/2+1

  rank = 3
  howmany = 3
  stride  = 1
  z_dist = (Lx/2+1) * (Ly+padding_y) * Lz
  d_dist = 2 * z_dist

  n_tmp = 2 * howmany * (Lx/2+1) * (Ly+padding_y) * Lz
  d_ptr = fftw_alloc_real(n_tmp)
  call    c_f_pointer(d_ptr, d_linear, [n_tmp])

  n_tmp =     howmany * (Lx/2+1) * (Ly+padding_y) * Lz
  if (in_or_out) then
     z_ptr = c_null_ptr
     call c_f_pointer(d_ptr, z_linear, [n_tmp])
  else
     z_ptr = fftw_alloc_complex(n_tmp)
     call c_f_pointer(z_ptr, z_linear, [n_tmp])
  end if
  d(0:2*(Lx/2+1)-1, 0:Ly+padding_y-1, 0:Lz-1, 1:howmany) => d_linear
  z(0:Lx/2,         0:Ly+padding_y-1, 0:Lz-1, 1:howmany) => z_linear

!!!first touch
!$omp parallel do
  do iz = 0,Lz-1
     d(:,:,iz,:) = 0.0d0
  end do
!$omp end parallel do
!$omp parallel do
  do iz = 0,Lz-1
     z(:,:,iz,:) = (0.0d0,0.0d0)
  end do
!$omp end parallel do

  plan_r2c = fftw_plan_many_dft_r2c(rank,LzLyLx,howmany,d,d_embed,stride,d_dist,z,z_embed,stride,z_dist,FFTW_MEASURE)
  plan_c2r = fftw_plan_many_dft_c2r(rank,LzLyLx,howmany,z,z_embed,stride,z_dist,d,d_embed,stride,d_dist,FFTW_MEASURE)

!$omp parallel do
  do i = 0,Lz-1
     d(:,:,i,:) = 0.1d0
  end do
!$omp end parallel do

  call system_clock(c_ri(0))
  do i = 1, N_TIMES
     call fftw_execute_dft_r2c(plan_r2c, d, z)
!$omp parallel do
     do iz = 0,Lz-1
        z(:,:,iz,:) = z(:,:,iz,:) * N_inv
     end do
!$omp end parallel do
     call fftw_execute_dft_c2r(plan_c2r, z, d)
  end do
  call system_clock(c_ri(1), count_rate, count_max)

!   do iz = 0, Lz-1
!      do iy = 0, Ly-1
!         do ix = 0, Lx-1
!            do i = 1, howmany
!               write(0,'(a,4(i5,a),f21.16)') 'd(',i,',',ix,',',iy,',',iz,') =',d(i,ix,iy,iz)
!            end do
!         end do
!      end do
!   end do

!$omp parallel do private(iz, iy, ix)
  do iz = 0, Lz-1
     do iy = 0, Ly-1
        do ix = 0, Lx-1
           do i = 1, howmany
              if (abs(d(ix,iy,iz,i)-0.1d0)>1.0d-15) then
                 write(0,'(a,a,i3,a,4(i5,a),f21.16)')   __FILE__, ':', __LINE__ ,  &
                      & ': Error in accuracy at d(',ix,',',iy,',',iz,',',i,') =',d(ix,iy,iz,i)
              end if
           end do
        end do
     end do
  end do
!$omp end parallel do

  t_ri = dble(c_ri(1)-c_ri(0))/count_rate
  if (t_ri<0.0d0) t_ri=t_ri+dble(count_max)/count_rate
  f_r = log(dble(N)) / log(2.0d0) / 1.0d9 * N_TIMES * 5 * N * howmany
  g_ri = f_r / t_ri

  write(6,'(i8,4i5,i11,L3,  f8.3,f8.3)') N_TIMES, Lx, Ly, Lz, padding_y, N, in_or_out,  t_ri, g_ri
  call fftw_destroy_plan(plan_r2c)
  call fftw_destroy_plan(plan_c2r)
  call fftw_free(d_ptr)
  call fftw_free(z_ptr)
  call fftw_cleanup_threads()
end program fft_old_check
!local variables:
!  compile-command: "make -k -f fft_old_check.Makefile.Intel-gfortran-fftw3_omp && OMP_NUM_THREADS=2 ./fft_old_check 100 128 128 64 3 T"
!End:
