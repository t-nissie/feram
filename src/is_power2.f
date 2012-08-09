! is_power2.f -*-f90-*-
! is_power2(a) Returns .true. if a is power of 2, i.e. a==2**n.
! Author: Takeshi Nishimatsu
!!
logical function is_power2(a)
  implicit none
  integer, intent(in) :: a
  integer             :: x
  x = a
  if (x<=0) then
     is_power2 = .false.
  else
     do while (mod(x,2).eq.0)
        x = x/2
     end do
     if (x.eq.1) then
        is_power2 = .true.
     else
        is_power2 = .false.
     end if
  end if
end function is_power2
