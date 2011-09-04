! feram_common.F -*-f90-*-
! Time-stamp: <2011-09-04 21:07:14 takeshi>
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
  character(len=70) :: message

  fn_len_trim = len_trim(fn)
  if (fn_len_trim-5 .eq. index(fn,'.feram',back=.true.)) then
     p%filename = fn(1:fn_len_trim-6)
  else
     p%filename = fn
  end if

  fn_log = trim(p%filename) // '.log'
  open(unit=UNIT_LOG,file=fn_log,status='replace')
  call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', PACKAGE_STRING)
  call date_and_time2message(message)
  call msg_ez(UNIT_LOG, message)
  call msg(UNIT_LOG, __FILE__, __LINE__, 'INPUT_FILENAME', fn)

  call  read_Param(p,fn)
  call  make_Param(p)
  call write_Param(p)
  call alloc_Coord(p,c)
  call  potentials(p,c)
  !Instead, read_defects_u(p,c) is called in initialize_dipoR()! call make_mass_matrix(p,c)

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

  call date_and_time2message(message)
  call msg_ez(UNIT_LOG, message)
  call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '')
  close(unit=UNIT_LOG)
end subroutine feram_common
