! fft_acml.F -*-f90-*-
! Time-stamp: <2012-07-24 17:04:02 t-nissie>
! Author: Takeshi NISHIMATSU
!!
program fft_check
  implicit none
  real*8,     parameter   :: C_CHECK = 0.1d0
  real*8,     parameter   :: TOLERANCE = 1.0d-9
  complex*16, allocatable :: a(:,:,:)
  complex*16, allocatable :: b(:,:,:)
  real*8,     allocatable :: r(:,:,:)
  complex*16, allocatable :: c(:,:,:)
  character(len=30)       :: str
  integer                 :: Lx, Ly, Lz, N_TIMES, N, NTHREADS, i, j, omp_get_max_threads
  real*8                  :: N_inv
  integer                 :: c_ci(0:2), c_co(0:2), c_ro(0:2)   ! count
  real*8                  :: t_ci(1:2), t_co(1:2), t_ro(1:2)   ! time
  real*8                  :: g_ci,      g_co,      g_ro        ! GFLOPS
  real*8                  :: f_c,       f_r         ! The numbers of floating point operations in [G]
  integer                 :: count_rate, count_max
  integer                 :: iargc

  complex*16, allocatable :: comm1(:),comm2(:)
  integer                 :: info

  i = iargc()
  if (i.eq.0) then
     ! default values
     N_TIMES = 1000
     Lx = 32
     Ly = 32
     Lz = 243
  else if (i.eq.4) then
     call getarg(1,str); read(str,*) N_TIMES
     call getarg(2,str); read(str,*) Lx
     call getarg(3,str); read(str,*) Ly
     call getarg(4,str); read(str,*) Lz
  else
     write(0,'(a)') 'fft_acml: Illegal number of arguments.'
     stop 1
  end if

  NTHREADS = omp_get_max_threads()

  N = Lx * Ly * Lz
  N_inv = 1.0d0 / N

  write(0,'((a,i8),3(a,i4),(a,i10),(a,i3))') &
       &          'N_TIMES = ', N_TIMES, &
       &           '    Lx = ', Lx, &
       &             ', Ly = ', Ly, &
       &             ', Lz = ', Lz, &
       &           ',    N = ', N, &
       &    ',    NTHREADS = ', NTHREADS


  !!!!! complex to complex, in-place (ci) !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  ! Allocation and first touch
  allocate(a(0:Lx-1, 0:Ly-1, 0:Lz-1),b(1,1,1))
  !$omp parallel do
  do j = 0, Lz-1
     a(:,:,j) = (C_CHECK,C_CHECK)
  end do
  !$omp end parallel do

  call system_clock(c_ci(0))
  allocate(comm1(Lx*Ly*Lz+3*(Lx+Ly+Lz)+300))
  call zfft3dx(100,N_inv,.true.,.true.,Lx,Ly,Lz,a,b,comm1,info)
  call system_clock(c_ci(1))
  do i = 1, N_TIMES
     call zfft3dx(-1,N_inv,.true.,.true.,Lx,Ly,Lz,a,b,comm1,info)
     call zfft3dx( 1,1.0d0,.true.,.true.,Lx,Ly,Lz,a,b,comm1,info)
  end do
  call system_clock(c_ci(2))
  ! check results
  if (abs( dble(a(0, 0, 0))-C_CHECK)>TOLERANCE) then
     write(0,*) a(0, 0, 0)
     write(0,'(a)') 'fft_acml: There is something wrong in dble(a).'
     stop 2
  end if
  if (abs(aimag(a(0, 0, 0))-C_CHECK)>TOLERANCE) then
     write(0,*) a(0, 0, 0)
     write(0,'(a)') 'fft_acml: There is something wrong in aimag(a).'
     stop 3
  end if
  deallocate(a,b,comm1)


  !!!!! complex to complex, out-of-place (co) !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  ! Allocation and first touch
  allocate(a(0:Lx-1, 0:Ly-1, 0:Lz-1))
  !$omp parallel do
  do j = 0, Lz-1
     a(:,:,j) = (C_CHECK,C_CHECK)
  end do
  !$omp end parallel do
  allocate(b(0:Lx-1, 0:Ly-1, 0:Lz-1))
  !$omp parallel do
  do j = 0, Lz-1
     b(:,:,j) = (C_CHECK,C_CHECK)
  end do
  !$omp end parallel do

  call system_clock(c_co(0))
  allocate(comm1(Lx*Ly*Lz+3*(Lx+Ly+Lz)+300))
  call    zfft3dx(100,N_inv,.true.,.false.,Lx,Ly,Lz,a,b,comm1,info)
  call system_clock(c_co(1))
  do i = 1, N_TIMES
     call zfft3dx( -1,N_inv,.true.,.false.,Lx,Ly,Lz,a,b,comm1,info)
     call zfft3dx(  1,1.0d0,.true.,.false.,Lx,Ly,Lz,a,b,comm1,info)
  end do
  call system_clock(c_co(2))
  ! check results
  if (abs( dble(a(0, 0, 0))-C_CHECK)>TOLERANCE) then
     write(0,*) a(0, 0, 0)
     write(0,'(a)') 'fft_acml: There is something wrong in dble(a).'
     stop 4
  end if
  if (abs(aimag(a(0, 0, 0))-C_CHECK)>TOLERANCE) then
     write(0,*) a(0, 0, 0)
     write(0,'(a)') 'fft_acml:: There is something wrong in aimag(a).'
     stop 5
  end if
  deallocate(a,b,comm1)


  !!!!! real, out-of-place (rof and rob) !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  ! Allocation and first touch
  allocate(r(0:Lx-1, 0:Ly-1, 0:Lz-1))
  !$omp parallel do
  do j = 0, Lz-1
     r(:,:,j) = C_CHECK
  end do
  !$omp end parallel do
  allocate(c(0:Lx/2, 0:Ly-1, 0:Lz-1))
  !$omp parallel do
  do j = 0, Lz-1
     c(:,:,j) = (0.0d0,0.0d0)
  end do
  !$omp end parallel do

  call system_clock(c_ro(0))
  allocate(comm1(4*Lx+6*Ly+6*Lz+500))
  call dzfft3d(100,Lx,Ly,Lz,r,c,comm1,info)
  allocate(comm2(4*Lx+6*Ly+6*Lz+500))
  call zdfft3d(100,Lx,Ly,Lz,c,r,comm2,info)
  call system_clock(c_ro(1))
  do i = 1, N_TIMES
     call dzfft3d(1,Lx,Ly,Lz,r,c,comm1,info)
     call zdfft3d(1,Lx,Ly,Lz,c,r,comm2,info)   !This subroutine normalizes r. No way!
  end do
  call system_clock(c_ro(2), count_rate, count_max)
  ! check results
  if (abs(r(0, 0, 0)-C_CHECK)>TOLERANCE) then
     write(0,*) r(0, 0, 0)
     write(0,'(a)') 'fft_acml: There is something wrong in r.'
     stop 6
  end if
  deallocate(r,c,comm1,comm2)


  !!!!! write timing results !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  do i = 1, 2
     t_ci(i) = dble(c_ci(i)-c_ci(i-1))/count_rate ; if (t_ci(i)<0.0d0) t_ci(i)=t_ci(i)+dble(count_max)/count_rate
     t_co(i) = dble(c_co(i)-c_co(i-1))/count_rate ; if (t_co(i)<0.0d0) t_co(i)=t_co(i)+dble(count_max)/count_rate
     t_ro(i) = dble(c_ro(i)-c_ro(i-1))/count_rate ; if (t_ro(i)<0.0d0) t_ro(i)=t_ro(i)+dble(count_max)/count_rate
  end do

  f_c = log(dble(N)) / log(2.0d0) / 1.0d9 * N_TIMES * 5 * N * 2
  f_r = log(dble(N)) / log(2.0d0) / 1.0d9 * N_TIMES * 5 * N

  g_ci = f_c / t_ci(2)
  g_co = f_c / t_co(2)
  g_ro = f_r / t_ro(2)

  write(0,'(a,f14.5,f10.5,f8.3)') &
       & ' p_ci, t_ci, g_ci = ', t_ci(1), t_ci(2), g_ci, &
       & ' p_co, t_co, g_co = ', t_co(1), t_co(2), g_co, &
       & ' p_ro, t_ro, g_ro = ', t_ro(1), t_ro(2), g_ro
end program fft_check
!Local variables:
!  compile-command: "make -k fft_acml -f fft_acml.Makefile && ./fft_acml"
!End:
