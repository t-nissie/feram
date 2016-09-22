! msg_module.F -*-f90-*-
! Time-stamp: <2016-03-22 19:51:54 takeshi>
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
  character(*), intent(in) :: begin_or_end !'START', 'FINISH', 'BEGIN', 'END', 'FATAL', 'FILE', 'WARNING', 'COMMENT'
  character(*), intent(in) :: message
  !--- variables -------------------------------------
  integer, parameter :: indent=2
  integer, save      :: level(256)=0   ! for fd = 1 ... 256
  !---------------------------------------------------
  if (begin_or_end.eq.'') then
     write(fd,'(a,a)') repeat(' ', indent*level(fd)+indent/2), trim(message)
  else
     if (begin_or_end.eq.'BEGIN') level(fd) = level(fd) + 1
     write(fd,'(3a,i0,4a)') repeat('  ', level(fd)), filename, ':', line, ': ', begin_or_end, ': ', trim(message)
     if (begin_or_end.eq.'END')   level(fd) = level(fd) - 1
  end if
end subroutine msg

subroutine msg_ez(fd, message)
  implicit none
  integer,      intent(in) :: fd
  character(*), intent(in) :: message
  call msg(fd, '', 0, '', message)
end subroutine msg_ez
end module msg_module
