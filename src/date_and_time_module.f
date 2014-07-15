! date_and_time_module.f -*-f90-*-
! Time-stamp: <2014-07-16 06:38:44 takeshi>
! Author: Takeshi NISHIMATSU
!!
module date_and_time_module
  implicit none
  private
  public :: date_and_time2message
contains
  subroutine date_and_time2message(message)
    ! Call internal date_and_time(), convert it into ISO 8601 format, then return the string.
    implicit none
    character(len= 8) :: date
    character(len=10) :: time
    character(len= 5) :: zone
    character(*), intent(out) :: message
    call date_and_time(date, time, zone)
    write(message,'(a,"-",a,"-",a,"T",a,":",a,":",a,a)') &
         & date(1:4), date(5:6), date(7:8), time(1:2), time(3:4), time(5:10), zone
  end subroutine date_and_time2message
end module date_and_time_module
