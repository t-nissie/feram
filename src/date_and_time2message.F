! date_and_time2message.F -*-f90-*-
! Time-stamp: <2012-07-27 17:37:10 takeshi>
! Author: Takeshi NISHIMATSU
!!
subroutine date_and_time2message(message)
  implicit none
  character(len= 8) :: date
  character(len=10) :: time
  character(len= 5) :: zone
  character(*), intent(out) :: message
  call date_and_time(date, time, zone)
  write(message,'(a,"-",a,"-",a,"T",a,":",a,":",a,a)') &
       & date(1:4), date(5:6), date(7:8), time(1:2), time(3:4), time(5:10), zone
end subroutine date_and_time2message
