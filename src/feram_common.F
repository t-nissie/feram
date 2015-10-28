! feram_common.F -*-f90-*-
! Time-stamp: <2015-10-28 18:01:23 t-nissie>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
#include "define.h"
subroutine feram_common(fn)
  use Param_module
  use Coord_module
  use date_and_time_module
  use msg_module
  implicit none
  type(Param_type),save :: p
  type(Coord_type),save :: c
  character(len=FILE_NAME_LEN), intent(in) :: fn
  character(len=FILE_NAME_LEN)             :: fn_log, basename
  integer                                  :: fn_len_trim, suffix
  integer                                  :: OMP_GET_MAX_THREADS
  character(len=70) :: message
  integer           :: count_array(0:2)
  real*8            :: time_array(1:2)
  integer           :: count_rate, count_max, i

  include 'fftw3.f03'
  integer :: ireturn
  ireturn = fftw_init_threads()   ! It is safe to call this function many times. See fftw3/threads/api.c.
  call fftw_plan_with_nthreads(OMP_GET_MAX_THREADS())   ! Also safe. See "Usage of Multi-threaded FFTW" in doc.

  fn_len_trim = len_trim(fn)
  suffix = index(fn,'.feram',back=.true.)
  if (suffix.gt.0) then
     if (suffix.eq.fn_len_trim-5) then
        p%filename = fn(1:fn_len_trim-6)
     else if (index(fn,'.feram_check',back=.true.).eq.fn_len_trim-11) then
        p%filename = basename(fn(1:fn_len_trim-12)) ! ../../src/zzz16.feram_check -> zzz16 for `make distcheck`
     end if
  else
     p%filename = fn
  end if

  fn_log = trim(p%filename) // '.log'
  open(unit=UNIT_LOG,file=fn_log,status='replace')
  call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', PACKAGE_STRING)
  call hostnm(message)
  call msg(UNIT_LOG, __FILE__, __LINE__, 'HOSTNAME', message)

  call system_clock(count_array(0))
  call date_and_time2message(message)
  call msg(UNIT_LOG, __FILE__, __LINE__, 'DATE_AND_TIME', message)

  write(message,'(i5)') OMP_GET_MAX_THREADS()
  call msg(UNIT_LOG, __FILE__, __LINE__, 'N_THREADS', message)

#if defined(HAVE_LIBFFTW3) && !defined(WITH_FFT_MKL)
  ireturn = fftw_import_wisdom_from_filename(C_CHAR_"wisdom"//C_NULL_CHAR)
  if (ireturn.eq.1) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'FFTW_WISDOM', 'Successfully imported FFTW wisdom in current directory.')
  else
     call msg(UNIT_LOG, __FILE__, __LINE__, 'FFTW_WISDOM', 'Failed to import FFTW wisdom in current directory.')
     ireturn = fftw_import_system_wisdom()
     if (ireturn.eq.1) then
        call msg(UNIT_LOG, __FILE__, __LINE__, 'FFTW_WISDOM', 'Successfully imported FFTW system wisdom, /etc/fftw/wisdom.')
     else
        call msg(UNIT_LOG, __FILE__, __LINE__, 'FFTW_WISDOM', 'Could not import FFTW system wisdom. All FFTW plans will be made by myself.')
     end if
  end if
#endif

  call  read_Param(p,fn)
  call  make_Param(p)
  call write_Param(p)
  if (p%continue) then
     if (.not.allocated(c%dipoR)) then
        write(0,'(a,a,i2,a)') __FILE__, ':', __LINE__, ': continue=.true. but cannot continue the calculation, because there is no previous result.'
        stop 1
     end if
  else
     call alloc_Coord(p,c)
  end if
  call dipole_dipole(p,c)
  call elastic(p,c)
  !Instead, read_defects_u(p,c) is called in initialize_dipoR()! call make_mass_matrix(p,c)

  call system_clock(count_array(1))
  call date_and_time2message(message)
  call msg(UNIT_LOG, __FILE__, __LINE__, 'DATE_AND_TIME', trim(message)//' Ready for simulation!!!')
  flush(UNIT_LOG)

  select case (p%method)
  case ('md','vs','lf')
     call molecular_dynamics(p,c)
  case ('hl')
     call hysteresis_loop(p,c)
  case default
     write(message,'(a,a,a)') &
          ": '", trim(p%method), "' is an illegal or not-yet-implemented method. Stop."
     call msg(UNIT_LOG, __FILE__, __LINE__, 'FATAL', message)
  end select

  call system_clock(count_array(2),count_rate,count_max)
  call date_and_time2message(message)
  call msg(UNIT_LOG, __FILE__, __LINE__, 'DATE_AND_TIME', message)

  do i = 1, 2
     time_array(i) = dble(count_array(i)-count_array(i-1))/count_rate
     if (time_array(i)<0.0d0) time_array(i)=time_array(i)+dble(count_max)/count_rate
  end do
  write(message,'(a,a,a)') &
       & 't_initialization, ', &
       & ' t_simulation, ', &
       & '      t_total, n_threads'
  call msg_ez(UNIT_LOG, message)
  write(message,'(f16.2,2f15.2,i5,a)') time_array(1),time_array(2), &
       &                               time_array(1)+time_array(2), &
       & OMP_GET_MAX_THREADS(), "     #TIMING_REPORT"
  call msg_ez(UNIT_LOG, message)

  ! We do NOT call fftw_cleanup_threads().
  call msg(UNIT_LOG, __FILE__, __LINE__, 'END', 'love && peace && free_software')
  close(unit=UNIT_LOG)
end subroutine feram_common

function basename(fn)
  implicit none
  character(len=FILE_NAME_LEN) :: basename
  character(len=*), intent(in) :: fn
  integer :: len, pos
  len = len_trim(fn)
  pos = index(fn,'/',back=.true.)
  if (pos.gt.0) then
     basename = fn(pos+1:len)
  else
     basename = fn
  end if
end function basename
