! decay_function_module.f -*-f90-*-
! Decay functions for the Ewald sum of dipoles
! Author: Takeshi NISHIMATSU
! $Date$
! $Rev$
! $Author$
! Reference: M. P. Allen and D. J. Tildesley: "Computer Simulation of Liquids",
!            sec. 5.5.2 The Ewald sum, p. 160, Oxford Science Publications (1989).
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
