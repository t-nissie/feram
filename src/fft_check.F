! fft_check.F -*-f90-*-
! Time-stamp: <2012-07-29 09:46:32 t-nissie>
! Author: Takeshi NISHIMATSU
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#ifdef FFT_CHECK_DOCUMENT
= fft_check.F, a 3-dimensional FFT benchmark program written in Fortran 
fft_check.F is a benchmark program. It times
in-place double-precision complex 3-dimensional FFT and
in-place and out-of-place double-precision real 3-dimensional FFT.
It is written in Fortran and parallelized with OpenMP.

== Homepage and download
http://loto.sourceforge.net/feram/src/fft_check.html is the homepage of fft_check.

Its GPLed source code is in feram-X.YY.ZZ/src/ in the feram package.
You can freely download a tar ball of feram (feram-X.YY.ZZ.tar.xz) from
http://sourceforge.net/projects/loto/files/feram/ .
feram is molecular dynamics (MD) simulator for bulk and
thin-film ferroelectrics and GPLed free software.

== How to build fft_check
Although fft_check can be built by the usual 'configure && make' manner
along with feram (See ../INSTALL), makefiles for several compilers and
architectures are provided in names of fft_check.Makefile.*.
You can build fft_check with GNU Fortran (gfortran), Intel Fortran (ifort),
IBM XL Fortran (xlf90_r), etc. You can link FFTW, Intel MKL, Hitach MATRIX/MPP
as a FFT library. For example,
 $ make -f fft_check.Makefile.Intel-gfortran-fftw3_omp


=== FFTW
If fft_check.F is compiled with FFTW library and f90_wisdom.f,
it imports 'wisdom' file in currnet directory or /etc/fftw/wisdom
and exports 'wisdom_new' into currnet directory.

=== PGI Fortran and ACML
Use fft_acml.f and fft_acml.Makefile.
 $ make -f fft_acml.Makefile

== How to execute fft_check
If you wan to FFT with a size of 80x90x100 10000 times,
 $ OMP_NUM_THREADS=6 ./fft_check 10000 80 90 100

#endif
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif

#if defined(__PGI) || defined(HITACHI_SR) || defined(__sparc)
#  define command_argument_count iargc
#  define get_command_argument getarg
#endif

#define C_CHECK 0.1d0

#if defined(__INTEL_COMPILER) && defined(HAVE_LIBFFTW3)
#  define TOLERANCE 1.0d-10
#else
#  define TOLERANCE 1.0d-15
#endif

program fft_check
  implicit none
  complex*16, allocatable :: a(:,:,:)

  real*8,     allocatable :: r(:,:,:)
  complex*16, allocatable :: c(:,:,:)

  character(len=30)       :: str
  integer                 :: Lx, Ly, Lz, N_TIMES, N, NTHREADS, i, j, omp_get_max_threads
  real*8                  :: N_inv
  integer                 :: c_ci(0:2), c_ri(0:2), c_ro(0:2)   ! count
  real*8                  :: t_ci(1:2), t_ri(1:2), t_ro(1:2)   ! time
  real*8                  :: g_ci,      g_ri,      g_ro        ! GFLOPS
  real*8                  :: f_c,       f_r   ! The numbers of floating point operations in [G]
  integer                 :: count_rate, count_max
  integer                 :: command_argument_count

#if defined(HAVE_LIBFFTW3)
  integer*8               :: plan_cif
  integer*8               :: plan_cib
  integer*8               :: plan_rif
  integer*8               :: plan_rib
  integer*8               :: plan_rof
  integer*8               :: plan_rob
  integer                 :: ireturn, ios
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
     write(0,'(a,a,i3,a)') __FILE__, ':', __LINE__, ': Illegal number of arguments.'
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

#if defined(HAVE_LIBFFTW3)
  call dfftw_init_threads(ireturn)
  call dfftw_plan_with_nthreads(NTHREADS)

  open(unit=20, file='wisdom', status='old', action='read', iostat=ios)
  if (ios.eq.0) then
     call import_wisdom_from_file(ireturn,20)
     close(20)
     if (ireturn.eq.1) then
        write(0,'(a,a,i3,a)') __FILE__, ':', __LINE__, ': Successfully read FFTW wisdom in current directory.'
     else
        write(0,'(a,a,i3,a)') __FILE__, ':', __LINE__, ': Failed to read FFTW wisdom in current directory.'
     end if
  else
     write(0,'(a,a,i3,a)') __FILE__, ':', __LINE__, ': FFTW wisdom is not in current directory.'
     call dfftw_import_system_wisdom(ireturn)
     if (ireturn.eq.1) then
        write(0,'(a,a,i3,a)') __FILE__, ':', __LINE__, ': Successfully read FFTW system wisdom, /etc/fftw/wisdom.'
     else
        write(0,'(a,a,i3,a)') __FILE__, ':', __LINE__, ': Could not import FFTW system wisdom. All FFTW plans will be made by myself.'
     end if
  endif
#endif


  !!!!! complex to complex, in-place (cif and cib) !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  ! Allocation and first touch
  allocate(a(0:Lx-1, 0:Ly-1, 0:Lz-1))
!$omp parallel do
  do j = 0, Lz-1
     a(:,:,j) = (C_CHECK,C_CHECK)
  end do
!$omp end parallel do

  call system_clock(c_ci(0))

#if defined(HAVE_LIBFFTW3)
  call     dfftw_plan_dft_3d(plan_cif, Lx, Ly, Lz, a(0,0,0), a(0,0,0), FFTW_FORWARD,  FFTW_PATIENT)
  call     dfftw_plan_dft_3d(plan_cib, Lx, Ly, Lz, a(0,0,0), a(0,0,0), FFTW_BACKWARD, FFTW_PATIENT)
!$omp parallel do
  do j = 0, Lz-1
     a(:,:,j) = (C_CHECK,C_CHECK)   ! Re-substitution of a(:,:,:), because contents of them are broken by planner.
  end do
!$omp end parallel do
#endif

  call system_clock(c_ci(1))

  do i = 1, N_TIMES
#   if defined(HAVE_LIBFFTW3)
     call dfftw_execute(plan_cif)
!$omp parallel do
     do j = 0, Lz-1
        a(:,:,j) = a(:,:,j) * N_inv
     end do
!$omp end parallel do
     call dfftw_execute(plan_cib)
#   else
     call fft_3d_fwd_or_bkd(.true.,  Lx, Ly, Lz, a)
!$omp parallel do
     do j = 0, Lz-1
        a(:,:,j) = a(:,:,j) * N_inv
     end do
!$omp end parallel do
     call fft_3d_fwd_or_bkd(.false., Lx, Ly, Lz, a)
#   endif
  end do
  ! check results
  if (abs( dble(a(0, 0, 0))-C_CHECK)>TOLERANCE) then
     write(0,*) a(0, 0, 0)
     write(0,'(a,a,i3,a)') __FILE__, ':', __LINE__, ': There is something wrong in dble(a).'
     stop 2
  end if
  if (abs(aimag(a(0, 0, 0))-C_CHECK)>TOLERANCE) then
     write(0,*) a(0, 0, 0)
     write(0,'(a,a,i3,a)') __FILE__, ':', __LINE__, ': There is something wrong in aimag(a).'
     stop 3
  end if

  call system_clock(c_ci(2))
  deallocate(a)


  !!!!! real, in-place (rif and rib) !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  ! Allocation and first touch
  allocate( r(0:2*(Lx/2+1)-1, 0:Ly-1, 0:Lz-1))
  ! Lx=8        2*(Lx/2+1)-1=10
  ! Lx=9        2*(Lx/2+1)-1=10
  ! Or use allocate(c(0:Lx/2, 0:Ly-1, 0:Lz-1))
!$omp parallel do
  do j = 0, Lz-1
     r(:,:,j) = C_CHECK
  end do
!$omp end parallel do

  call system_clock(c_ri(0))

#if defined(HAVE_LIBFFTW3)
  call dfftw_plan_dft_r2c_3d(plan_rif, Lx, Ly, Lz, r(0,0,0), r(0,0,0), FFTW_PATIENT)
  call dfftw_plan_dft_c2r_3d(plan_rib, Lx, Ly, Lz, r(0,0,0), r(0,0,0), FFTW_PATIENT)
!$omp parallel do
  do j = 0, Lz-1
     r(:,:,j) = C_CHECK   ! Re-substitution of r(:,:,:), because contents of them are broken by planner.
  end do
!$omp end parallel do
#endif

  call system_clock(c_ri(1))

  do i = 1, N_TIMES
#   if defined(HAVE_LIBFFTW3)
     call dfftw_execute(plan_rif)
!$omp parallel do
     do j = 0, Lz-1
        r(:,:,j) = r(:,:,j) * N_inv
     end do
!$omp end parallel do
     call dfftw_execute(plan_rib)
#   else
#    if defined(HAVE_LIBMATMPP)
     if (mod(Lx,2).eq.1) exit
#    endif
     call fft_3d_r2c_or_c2r_in_place(.true.,  Lx, Ly, Lz, r)
     do j = 0, Lz-1
        r(:,:,j) = r(:,:,j) * N_inv
     end do
     call fft_3d_r2c_or_c2r_in_place(.false., Lx, Ly, Lz, r)
#   endif
  end do
  ! check results
  if (abs(r(0, 0, 0)-C_CHECK)>TOLERANCE) then
     write(0,*) r(0, 0, 0)
     write(0,'(a,a,i3,a)') __FILE__, ':', __LINE__, ': There is something wrong in r.'
     stop 4
  end if

  call system_clock(c_ri(2))
  deallocate(r)


  !!!!! real, out-of-place (rof and rob) !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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

#if defined(HAVE_LIBFFTW3)
  call dfftw_plan_dft_r2c_3d(plan_rof, Lx, Ly, Lz, r(0,0,0), c(0,0,0), FFTW_PATIENT)
  call dfftw_plan_dft_c2r_3d(plan_rob, Lx, Ly, Lz, c(0,0,0), r(0,0,0), FFTW_PATIENT)
!$omp parallel do
  do j = 0, Lz-1
     r(:,:,j) = C_CHECK   ! Re-substitution of r(:,:,:), because contents of them are broken by planner.
  end do
!$omp end parallel do
#endif

  call system_clock(c_ro(1))

  do i = 1, N_TIMES
#   if defined(HAVE_LIBFFTW3)
     call dfftw_execute(plan_rof)
!$omp parallel do
     do j = 0, Lz-1
        c(:,:,j) = c(:,:,j) * N_inv
     end do
!$omp end parallel do
     call dfftw_execute(plan_rob)
#   else
#    if defined(HAVE_LIBMATMPP)
     if (mod(Lx,2).eq.1) exit
#    endif
     call fft_3d_r2c_or_c2r_out_of_place(.true.,  Lx, Ly, Lz, r, c)
     do j = 0, Lz-1
        c(:,:,j) = c(:,:,j) * N_inv
     end do
     call fft_3d_r2c_or_c2r_out_of_place(.false., Lx, Ly, Lz, r, c)
#   endif
  end do
  ! check results
  if (abs(r(0, 0, 0)-C_CHECK)>TOLERANCE) then
     write(0,*) r(0, 0, 0)
     write(0,'(a,a,i3,a)') __FILE__, ':', __LINE__, ': There is something wrong in r.'
     stop 5
  end if

  call system_clock(c_ro(2), count_rate, count_max)
  deallocate(r,c)

  do i = 1, 2
     t_ci(i) = dble(c_ci(i)-c_ci(i-1))/count_rate ; if (t_ci(i)<0.0d0) t_ci(i)=t_ci(i)+dble(count_max)/count_rate
     t_ri(i) = dble(c_ri(i)-c_ri(i-1))/count_rate ; if (t_ri(i)<0.0d0) t_ri(i)=t_ri(i)+dble(count_max)/count_rate
     t_ro(i) = dble(c_ro(i)-c_ro(i-1))/count_rate ; if (t_ro(i)<0.0d0) t_ro(i)=t_ro(i)+dble(count_max)/count_rate
  end do

  f_c = log(dble(N)) / log(2.0d0) / 1.0d9 * N_TIMES * 5 * N * 2
  f_r = f_c / 2
  write(0,'(a)') ' The number of floating point operations:'
  write(0,'(a,f9.2,a)') '  f_c = ', f_c, ' [G]'
  write(0,'(a,f9.2,a)') '  f_r = ', f_r, ' [G]'

  g_ci = f_c / t_ci(2)
  g_ri = f_r / t_ri(2)
  g_ro = f_r / t_ro(2)

  if (t_ri(2)<0.00001d0 .and. mod(Lx,2).eq.1) then   ! In the case of Lx=odd on SR16000 with MATRIX/MPP
     write(0,              '(a,f14.5,f10.5,f8.3)') &
          & ' p_ci, t_ci, g_ci = ', t_ci(1), t_ci(2), g_ci
     write(6,'(i8,3i5,i11,i4,  f14.5,f10.5,f8.3)') N_TIMES, Lx, Ly, Lz, N, NTHREADS, &
          &                         t_ci(1), t_ci(2), g_ci
  else
     write(0,              '(a,f14.5,f10.5,f8.3)') &
          & ' p_ci, t_ci, g_ci = ', t_ci(1), t_ci(2), g_ci, &
          & ' p_ri, t_ri, g_ri = ', t_ri(1), t_ri(2), g_ri, &
          & ' p_ro, t_ro, g_ro = ', t_ro(1), t_ro(2), g_ro
     write(6,'(i8,3i5,i11,i4,3(f14.5,f10.5,f8.3))') N_TIMES, Lx, Ly, Lz, N, NTHREADS, &
          &                         t_ci(1), t_ci(2), g_ci, &
          &                         t_ri(1), t_ri(2), g_ri, &
          &                         t_ro(1), t_ro(2), g_ro
  end if

#if defined(HAVE_LIBFFTW3)
  open(unit=17, file='wisdom_new', status='replace')
  call export_wisdom_to_file(17)
  close(17)
  call dfftw_cleanup_threads(ireturn)
#endif

end program fft_check
!Local variables:
!  compile-command: "make -k fft_check fft_check.html && OMP_NUM_THREADS=6 ./fft_check"
!End:
