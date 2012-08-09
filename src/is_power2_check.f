! is_power2_check.f -*-f90-*-
! check is_power2.f
! Author: Takeshi Nishimatsu
!!
program is_power2_check
  implicit none
  logical is_power2
  external is_power2
  if (is_power2(-2)) stop 1
  if (is_power2(-1)) stop 2
  if (is_power2( 0)) stop 3
  if (is_power2( 6)) stop 4
  if (is_power2(48)) stop 5

  if (.not.is_power2( 1)) stop 6
  if (.not.is_power2( 2)) stop 7
  if (.not.is_power2( 4)) stop 8
  if (.not.is_power2( 8)) stop 9
end program
