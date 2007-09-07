! decay-functions.F -*-f90-*-
! Time-stamp: <2005-11-22 11:21:12 t-nissie>
! Author: Takeshi NISHIMATSU
!
!OPTION FORM(FREE)
!!
real*8 function B_decay(r,rr,kappa)
  implicit none
  real*8 r,rr,kappa,derfc
  real*8, parameter :: M_2_SQRTPI = 1.12837916709551257390d0
  B_decay  =  derfc(kappa*r)/(r*rr) + M_2_SQRTPI * kappa * exp(-kappa**2*rr) / rr
end function B_decay

real*8 function Crr(r,rr,kappa)
  implicit none
  real*8 r,rr,kappa,derfc
  real*8, parameter :: M_2_SQRTPI = 1.12837916709551257390d0
  Crr=3*derfc(kappa*r)/(r*rr) + M_2_SQRTPI * kappa * exp(-kappa**2*rr) * (2*kappa**2+3/rr)
end function Crr

real*8 function C_decay(r,rr,kappa)
  implicit none
  real*8 r,rr,kappa,Crr
  external Crr
  C_decay=Crr(r,rr,kappa)/rr
end function C_decay
