! DDB2short.F -*-f90-*-
! Time-stamp: <2008-09-05 16:46:24 takeshi>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif

#if defined(SR11000)
   function command_argument_count()
     implicit none
     integer command_argument_count
     open(9, file='FILES')!, status='old', action='read')
     read(9,*) command_argument_count
   end function command_argument_count
   subroutine get_command_argument(i,a)
     implicit none
     integer i
     character (len=*) a
     read(9,*) a
   end subroutine get_command_argument
#elif defined(__PGI)
#  define command_argument_count iargc
#  define get_command_argument getarg
#endif

program DDB2short
  use Param_module
  implicit none
  type(Param_type) :: p
  character(70) message
  integer i, fd, argn, command_argument_count

  write(message,'(a,a)') ': Version ', PACKAGE_VERSION
  call msg(6, __FILE__, __LINE__, 'BEGIN', message)

  argn = command_argument_count()

  if (argn.eq.0) then
     argn = 1
     fd = 5
  else
     fd = 7
  end if

  do i=1,argn
     if (fd.eq.5) then
        p%filename = 'stdin'
     else
        call get_command_argument(i,p%filename)
        open(fd, FILE=p%filename, STATUS='OLD')
     end if
     call msg(6, __FILE__, __LINE__, 'FILENAME: ', trim(p%filename))

     call  read_Param(p,fd)
     call  make_Param(p)
  end do

  call msg(6, __FILE__, __LINE__, 'END', '')
end program DDB2short
