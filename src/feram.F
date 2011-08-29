! feram.F -*-f90-*-
! Time-stamp: <2011-08-29 14:26:00 z48325w>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
#include "define.h"

#if defined(__PGI) || defined(SR11000) || defined(__sparc)
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
     call feram_common(fn)
  end do
end program feram
