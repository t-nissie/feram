! fft_check.F -*-f90-*-
! Time-stamp: <2012-05-30 14:31:28 takeshi>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif

#if defined(__PGI) || defined(HITACHI_SR) || defined(__sparc)
#  define command_argument_count iargc
#  define get_command_argument getarg
#endif

program fft_check
  implicit none
  complex*16, allocatable :: a(:,:,:)

  real*8,     allocatable :: r(:,:,:)
  complex*16, allocatable :: c(:,:,:)

  character(len=30)       :: str
  integer                 :: Lx, Ly, Lz, N_TIMES, N, NTHREADS, i, j, omp_get_max_threads
  real*8                  :: N_inv, t_plan, t_fwdbkd, t_r2cc2r, mflops_fwdbkd, mflops_r2cc2r
  integer                 :: count(0:3), count_rate, count_max
  integer                 :: cdiff(1:3)
  integer                 :: command_argument_count

#if defined(HAVE_LIBFFTW3)
  integer*8               :: plans_fwd
  integer*8               :: plans_bkd
  integer*8               :: plans_r2c
  integer*8               :: plans_c2r
  integer                 :: ireturn
# include "fftw3.f"
#endif

  i = command_argument_count()
  if (i.eq.0) then
     ! default values
     N_TIMES = 1000
     Lx = 32
     Ly = 32
     Lz = 243
  else if (i.eq.4) then
     call get_command_argument(1,str); read(str,*) N_TIMES
     call get_command_argument(2,str); read(str,*) Lx
     call get_command_argument(3,str); read(str,*) Ly
     call get_command_argument(4,str); read(str,*) Lz
  else
     stop 'fft_check: illegal number of arguments'
  end if

  NTHREADS = omp_get_max_threads()

  N = Lx * Ly * Lz
  N_inv = 1.0d0 / N

  write(6,'((a,i10),3(a,i4),(a,i10),(a,i3))') &
       &          'N_TIMES = ', N_TIMES, &
       &           '    Lx = ', Lx, &
       &             ', Ly = ', Ly, &
       &             ', Lz = ', Lz, &
       &           ',    N = ', N, &
       &    ',    NTHREADS = ', NTHREADS

  !
  ! Allocations and first touches
  !
  allocate(a(0:Lx-1, 0:Ly-1, 0:Lz-1))
  !$omp parallel do
  do j = 0, Lz-1
     a(:,:,j) = (0.1d0,0.1d0)
  end do
  !$omp end parallel do

  allocate(r(0:Lx-1, 0:Ly-1, 0:Lz-1))
  !$omp parallel do
  do j = 0, Lz-1
     r(:,:,j) = 0.1d0
  end do
  !$omp end parallel do

  allocate(c(0:Lx/2, 0:Ly-1, 0:Lz-1))
  !$omp parallel do
  do j = 0, Lz-1
     c(:,:,j) = (0.0d0,0.0d0)
  end do
  !$omp end parallel do

  call system_clock(count(0))

#if defined(HAVE_LIBFFTW3)
  call dfftw_init_threads(ireturn)
  call dfftw_plan_with_nthreads(NTHREADS)

  call     dfftw_plan_dft_3d(plans_fwd, Lx, Ly, Lz, a(0,0,0), a(0,0,0), FFTW_FORWARD,  FFTW_PATIENT)
  call     dfftw_plan_dft_3d(plans_bkd, Lx, Ly, Lz, a(0,0,0), a(0,0,0), FFTW_BACKWARD, FFTW_PATIENT)
  call dfftw_plan_dft_r2c_3d(plans_r2c, Lx, Ly, Lz, r(0,0,0), c(0,0,0),                FFTW_PATIENT)
  call dfftw_plan_dft_c2r_3d(plans_c2r, Lx, Ly, Lz, c(0,0,0), r(0,0,0),                FFTW_PATIENT)
#endif

  call system_clock(count(1))
  
#if defined(HAVE_LIBFFTW3)
  do i = 1, N_TIMES
     call dfftw_execute(plans_fwd)

     !$omp parallel do
     do j = 0, Lz-1
        a(:,:,j) = a(:,:,j) * N_inv
     end do
     !$omp end parallel do

     call dfftw_execute(plans_bkd)
  end do
#elif defined(HITACHI_SR)
#endif
  write(6,*) a(0, 0, 0)

  call system_clock(count(2))

#if defined(HAVE_LIBFFTW3)
  do i = 1, N_TIMES
     call dfftw_execute(plans_r2c)

     !$omp parallel do
     do j = 0, Lz-1
        c(:,:,j) = c(:,:,j) * N_inv
     end do
     !$omp end parallel do

     call dfftw_execute(plans_c2r)
  end do
#elif defined(HITACHI_SR)
#endif
  write(6,*) r(0, 0, 0)

  call system_clock(count(3), count_rate, count_max)

  do i = 1, 3
     cdiff(i) = count(i)-count(i-1)
     if (cdiff(i)<0) then
        cdiff(i) = cdiff(i) + count_max
     end if
  end do

  t_plan   = dble(cdiff(1))/count_rate
  t_fwdbkd = dble(cdiff(2))/count_rate
  t_r2cc2r = dble(cdiff(3))/count_rate

  write(6,'(a,f10.5)') ' t_plan   = ', t_plan
  write(6,'(a,f10.5)') ' t_fwdbkd = ', t_fwdbkd
  write(6,'(a,f10.5)') ' t_r2cc2r = ', t_r2cc2r

  mflops_fwdbkd = log(dble(N)) / log(2.0d0) / t_fwdbkd / 1000000.0d0 * N_TIMES * 5 * N * 2
  mflops_r2cc2r = log(dble(N)) / log(2.0d0) / t_r2cc2r / 1000000.0d0 * N_TIMES * 5 * N
  write(6,'(a,f10.2)') ' mflops_fwdbkd = ', mflops_fwdbkd
  write(6,'(a,f10.2)') ' mflops_r2cc2r = ', mflops_r2cc2r



#if defined(HAVE_LIBFFTW3)
  call dfftw_cleanup_threads(ireturn)
#endif
end program fft_check
!Local variables:
!  compile-command: "make -k fft_check && ./fft_check"
!End:
