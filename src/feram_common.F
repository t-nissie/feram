! feram_common.F -*-f90-*-
! Time-stamp: <2012-08-22 13:43:57 t-nissie>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
#include "define.h"
subroutine feram_common(fn)
  use Param_module
  use Coord_module
  implicit none
  type(Param_type) :: p
  type(Coord_type) :: c
  character(len=FILE_NAME_LEN), intent(in) :: fn
  character(len=FILE_NAME_LEN)             :: fn_log
  integer                                  :: fn_len_trim
  integer                                  :: OMP_GET_MAX_THREADS
  character(len=70) :: message
  integer           :: count_array(0:2)
  real*8            :: time_array(1:2)
  integer           :: count_rate, count_max, i

# if defined(HAVE_LIBFFTW3)
  integer :: ireturn, ios
  call dfftw_init_threads(ireturn)
  call dfftw_plan_with_nthreads(OMP_GET_MAX_THREADS())
# endif

  fn_len_trim = len_trim(fn)
  if (fn_len_trim-5 .eq. index(fn,'.feram',back=.true.)) then
     p%filename = fn(1:fn_len_trim-6)
  else
     p%filename = fn
  end if

  fn_log = trim(p%filename) // '.log'
  open(unit=UNIT_LOG,file=fn_log,status='replace')
  call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', PACKAGE_STRING)

  call system_clock(count_array(0))
  call date_and_time2message(message)
  call msg_ez(UNIT_LOG, message)

# if defined(HAVE_LIBFFTW3)
  open(unit=UNIT_WISDOM, file='wisdom', status='old', action='read', iostat=ios)
  if (ios.eq.0) then
     call import_wisdom_from_file(ireturn,UNIT_WISDOM)
     close(UNIT_WISDOM)
     if (ireturn.eq.1) then
        call msg(UNIT_LOG, __FILE__, __LINE__, 'FFTW_WISDOM', 'Successfully imported FFTW wisdom in current directory.')
     else
        call msg(UNIT_LOG, __FILE__, __LINE__, 'FFTW_WISDOM', 'Failed to import FFTW wisdom in current directory.')
     end if
  else
     call    msg(UNIT_LOG, __FILE__, __LINE__, 'FFTW_WISDOM', 'FFTW wisdom is not in current directory.')
     call dfftw_import_system_wisdom(ireturn)
     if (ireturn.eq.1) then
        call msg(UNIT_LOG, __FILE__, __LINE__, 'FFTW_WISDOM', 'Successfully imported FFTW system wisdom, /etc/fftw/wisdom.')
     else
        call msg(UNIT_LOG, __FILE__, __LINE__, 'FFTW_WISDOM', 'Could not import FFTW system wisdom. All FFTW plans will be made by myself.')
     end if
  endif
# endif

  call  read_Param(p,fn)
  call  make_Param(p)
  call write_Param(p)
  call alloc_Coord(p,c)
  call  potentials(p,c)
  !Instead, read_defects_u(p,c) is called in initialize_dipoR()! call make_mass_matrix(p,c)

  call system_clock(count_array(1))
  call date_and_time2message(message)
  call msg_ez(UNIT_LOG, trim(message)//' Ready for simulation!!!')
  flush(UNIT_LOG)

  if (p%method.eq.'md ' .or. p%method.eq.'lf ') then
     call molecular_dynamics(p,c)
  else if (p%method.eq.'hl ') then
     call hysteresis_loop(p,c)
  else
     write(message,'(a,a,a)') &
          ": '", p%method, "' is an illegal or not-yet-implemented method. Stop."
     call msg(UNIT_LOG, __FILE__, __LINE__, 'FATAL', message)
     return
  end if

  call system_clock(count_array(2),count_rate,count_max)
  call date_and_time2message(message)
  call msg_ez(UNIT_LOG, message)

  do i = 1, 2
     time_array(i) = dble(count_array(i)-count_array(i-1))/count_rate
     if (time_array(i)<0.0d0) time_array(i)=time_array(i)+dble(count_max)/count_rate
  end do
  write(message,'(a,a,a)') &
       & 't_initialization, ', &
       & ' t_simulation, ', &
       & '      t_total'
  call msg_ez(UNIT_LOG, message)
  write(message,'(f16.2,2f15.2,a)') time_array(1),time_array(2), &
       &                            time_array(1)+time_array(2), "     #TIMING_REPORT"
  call msg_ez(UNIT_LOG, message)

  call msg(UNIT_LOG, __FILE__, __LINE__, 'END', 'love && peace && free_software')
  close(unit=UNIT_LOG)

# if defined(HAVE_LIBFFTW3)
  call dfftw_cleanup_threads(ireturn)
# endif
end subroutine feram_common
