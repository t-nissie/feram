! feram.F -*-f90-*-
! Time-stamp: <2012-08-22 13:43:57 t-nissie>
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
     call feram_common(fn)
  end do
end program feram
