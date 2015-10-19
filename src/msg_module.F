! msg_module.F -*-f90-*-
! Time-stamp: <2015-10-19 19:26:16 takeshi>
! Author: Takeshi NISHIMATSU
!!
module msg_module
contains
subroutine msg(fd, filename, line, begin_or_end, message)
  implicit none
  !--- arguments -------------------------------------
  integer,      intent(in) :: fd
  character(*), intent(in) :: filename
  integer,      intent(in) :: line
  character(*), intent(in) :: begin_or_end !'BEGIN', 'END', 'FATAL', 'FILE', 'WARNING', 'COMMENT'
  character(*), intent(in) :: message
  !--- variables -------------------------------------
  integer, parameter :: indent=2
  integer, save      :: level(256)=0   ! for fd = 1 ... 256
  character(20)      :: fmt_str, line_str
  !---------------------------------------------------

  if (begin_or_end.eq.'') then
     write(fmt_str,'(a,i3.3,a)') '(', indent*level(fd), 'x,a)'
     write(fd,fmt_str) trim(message)
  else
     if (begin_or_end.eq.'END') then
        level(fd) = level(fd) - 1
     end if
     if (level(fd).gt.0) then
        write(fmt_str,'(a,i3.3,a)') '(', indent*level(fd), 'x,7a)'
     else
        fmt_str =                                           '(7a)'
     end if
     write(line_str,'(i20)') line
     line_str = adjustl(line_str)
     write(fd,fmt_str) filename, ':', trim(line_str), ': ', begin_or_end, ': ', trim(message)
     if (begin_or_end.eq.'BEGIN') then
        level(fd) = level(fd) + 1
     end if
  end if
end subroutine msg

subroutine msg_ez(fd, message)
  implicit none
  integer,      intent(in) :: fd
  character(*), intent(in) :: message
  call msg(fd, '', 0, '', message)
end subroutine msg_ez
end module msg_module
