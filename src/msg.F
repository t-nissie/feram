! msg.F -*-f90-*-
! Time-stamp: <2011-06-16 11:27:14 takeshi>
! Author: Takeshi NISHIMATSU
!!
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
  character(20)      :: fmt
  !---------------------------------------------------

  if (begin_or_end.eq.'') then
     write(fmt,'(a,i3.3,a)') '(', indent*level(fd), 'x,a)'
     write(fd,fmt) trim(message)
  else
     if (begin_or_end.eq.'END') then
        level(fd) = level(fd) - 1
     end if
     if (level(fd).gt.0) then
        write(fmt,'(a,i3.3,a)') '(', indent*level(fd), 'x,2a,i3,4a)'
     else
        fmt =                                           '(2a,i3,4a)'
     end if
     write(fd,fmt) filename, ':', line, ': ', begin_or_end, ': ', trim(message)
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
