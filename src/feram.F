! feram.F -*-f90-*-
! Time-stamp: <2017-09-09 14:19:26 takeshi>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
#include "define.h"

#if defined(__PGI) || defined(__sparc)
#  define command_argument_count iargc
#  define get_command_argument getarg
#endif

program feram
  implicit none
  integer i, argn, command_argument_count
  character(len=FILE_NAME_LEN) :: fn
  argn = command_argument_count()
  do i=1,argn
     call get_command_argument(i,fn)
     if (i.eq.1.and.fn.eq.'--version') then
        write(6,'(a)') PACKAGE_STRING
        exit
     end if
     if (i.eq.1.and.fn.eq.'--help') then
        write(6,'(a)') "Usage: feram foo.feram bar.feram ..."
        write(6,'(a)') "For more details, see http://loto.sourceforge.net/feram/ ."
        exit
     end if
     call feram_common(fn)
  end do
end program feram
