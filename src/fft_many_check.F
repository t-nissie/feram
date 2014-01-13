! fft_many_check.F -*-f90-*-
! Time-stamp: <2014-01-13 19:54:17 takeshi>
! Author: Takeshi NISHIMATSU
!!
program fft_many_check
  use, intrinsic :: iso_c_binding
  implicit none
  include 'fftw3.f03'
  character(len=100) :: str
  integer :: N_TIMES
  integer :: Lx
  integer :: Ly
  integer :: Lz
  integer :: padding_y
  integer :: N
  integer :: N_half
  real*8  :: N_inv
  integer :: OMP_GET_MAX_THREADS
  integer :: ret, i, rank, LzLyLx(3), howmany, inembed(3), istride, idist, onembed(3), ostride, odist
  type(C_PTR) :: plan_r2c
  complex*16,allocatable :: z(:,:,:,:)
  real*8,    allocatable :: d(:,:,:,:)

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
  else if (i.eq.5) then
     call get_command_argument(1,str); read(str,*) N_TIMES
     call get_command_argument(2,str); read(str,*) Lx
     call get_command_argument(3,str); read(str,*) Ly
     call get_command_argument(4,str); read(str,*) Lz
     call get_command_argument(5,str); read(str,*) padding_y
  else
     write(0,'(a,a,i3,a)') __FILE__, ':', __LINE__, ': Illegal number of arguments.'
     stop 1
  end if
  N  = Lx * Ly * Lz
  N_half  = (Lx/2+1)*Ly*Lz
  N_inv = 1.0d0/N
  write(0,'(i8,4i5,i11)') N_TIMES, Lx, Ly, Lz, padding_y, N

  LzLyLx(1) = Lz
  LzLyLx(2) = Ly
  LzLyLx(3) = Lx
  inembed(1) = Lz
  inembed(2) = Ly+padding_y
  inembed(3) = 2*(Lx/2+1)
  onembed(1) = Lz
  onembed(2) = Ly+padding_y
  onembed(3) = Lx/2+1

  rank = 3

  howmany = 3
  istride = 3
  ostride = 3

  idist = 1
  odist = 1

  allocate( d(3, 0:2*(Lx/2+1)-1, 0:Ly+padding_y-1, 0:Lz-1), &
       &    z(3, 0:Lx/2,         0:Ly+padding_y-1, 0:Lz-1) )

!!!first touch
!$omp parallel do
  do i = 0,Lz-1
     d(:,:,:,i) = 0.0d0
  end do
!$omp end parallel do
!$omp parallel do
  do i = 0,Lz-1
     z(:,:,:,i) = (0.0d0,0.0d0)
  end do
!$omp end parallel do

  plan_r2c = fftw_plan_many_dft_r2c(rank,LzLyLx,howmany,d,inembed,istride,idist,z,onembed,ostride,odist,FFTW_MEASURE)

!$omp parallel do
  do i = 0,Lz-1
     d(:,:,:,i) = 0.1d0
  end do
!$omp end parallel do

  call fftw_execute_dft_r2c(plan_r2c, d, z)

  write(6,*) z(:,0,0,0)

  call fftw_cleanup_threads()
end program fft_many_check
!local variables:
!  compile-command: "make -k -f fft_many_check.Makefile.Intel-gfortran-fftw3_omp && ./fft_many_check 100 128 128 64 3"
!End:
