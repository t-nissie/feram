! msg_check.F -*-f90-*-
! Time-stamp: <2016-03-22 19:43:08 takeshi>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
#include "define.h"

subroutine msg_check_sub(ia)
  use msg_module
  implicit none
  integer, intent(in) :: ia
  call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'subroutine msg_check_sub')
  call msg(UNIT_LOG, __FILE__, ia,       'FILE',  'test a large line number')
  call msg(UNIT_LOG, __FILE__, __LINE__, 'END',   'subroutine msg_check_sub')
end subroutine msg_check_sub

program msg_check
  use msg_module
  implicit none
  character(len=100) :: hn
  open(unit=UNIT_LOG,file='msg_check.output',status='replace')
  call msg(UNIT_LOG, __FILE__, __LINE__, 'START', PACKAGE_STRING)
  call hostnm(hn)
  call msg(UNIT_LOG, __FILE__, __LINE__, 'HOSTNAME', hn)
  call msg_ez(UNIT_LOG, 'Hello, world!')
  call msg_check_sub(99999)
  call msg(UNIT_LOG, __FILE__, __LINE__, 'FINISH', 'love && peace && free_software')
  close(unit=UNIT_LOG)
end program msg_check
!Local variables:
!  compile-command: "make check TESTS=msg_check && head msg_check.output msg_check.log msg_check.trs"
!End:
