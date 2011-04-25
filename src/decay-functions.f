! decay-functions.f -*-f90-*-
! Time-stamp: <2011-04-25 14:06:36 t-nissie>
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
  real*8, parameter :: M_2_SQRTPI = 1.12837916709551257390d0
  Crr=3*derfc(kappa*r)/(r*rr) + M_2_SQRTPI * kappa * exp(-kappa**2*rr) * (2*kappa**2+3/rr)
  C_decay=Crr/rr
end function C_decay
