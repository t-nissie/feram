! decay_function_module.f -*-f90-*-
! Author: Takeshi NISHIMATSU
! $Date: 2012-07-06 21:27:09 +0900 (金, 06  7 2012) $
! $Rev: 1340 $
! $Author: t-nissie $
!!
module decay_function_module
implicit none
contains
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
  real*8 r,rr,kappa,Crr,derfc
  real*8, parameter :: M_2_SQRTPI = 1.12837916709551257390d0
  Crr=3*derfc(kappa*r)/(r*rr) + M_2_SQRTPI * kappa * exp(-kappa**2*rr) * (2*kappa**2+3/rr)
  C_decay=Crr/rr
end function C_decay
end module decay_function_module
