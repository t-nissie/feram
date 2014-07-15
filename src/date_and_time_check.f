! date_and_time_check.f -*-f90-*-
! Time-stamp: <2014-07-16 06:48:31 takeshi>
! Author: Takeshi NISHIMATSU
!!
program date_and_time_check
  use date_and_time_module
  implicit none
  character(len=70) :: message
  integer           :: count, count_rate, count_max
  call date_and_time2message(message)
  write(6,'(a)') message
  call system_clock(count,count_rate,count_max)
  write(6,'(a,i11,i6,i11)') 'system_clock:', count, count_rate, count_max
end program date_and_time_check
