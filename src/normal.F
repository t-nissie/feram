! normal.F   -*-f90-*-
! Time-stamp: <2009-11-06 16:26:52 takeshi>
! Author: Takeshi NISHIMATSU
! Reference: Haruhiko Okumura: C-gengo niyoru saishin algorithm jiten
!            (New Algorithm handbook in C language) (Gijyutsu hyouron
!            sha, Tokyo, 1991) [in Japanese]
!!
#include "define.h"

! N(mu,sigma^2) normal-distributed random number generator
! N(mu,sigma^2) = N(0,1)*sigma + mu
real*8 function normal_dist(mu,sigma)
  real*8 mu, sigma
  real*8 std_normal_dist
  external std_normal_dist
  normal_dist = std_normal_dist()*sigma+mu
end function normal_dist

! N(0,1) standard-normal-distributed random number generator
real*8 function std_normal_dist()
  logical, save :: sw = .true.
  real*8,  save :: t, u
  real*8        :: x(2)
  if (sw) then
     sw = .false.
     call random_number(x)
     t = sqrt(-2 * log(1 - x(1)))
     u = M_2PI * x(2)
     std_normal_dist = t * cos(u)
  else
     sw = .true.
     std_normal_dist = t * sin(u)
  end if
end function std_normal_dist
