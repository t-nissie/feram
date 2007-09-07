! decay-test.f   -*-f90-*-
! Time-stamp: <2005-08-29 17:06:38 t-nissie>
! Author: Takeshi NISHIMATSU
!
! Example$ echo 4.0 16 0.22 | ./decay-test
!
!!
program decay_test
  implicit none
  real*8   a0
  integer  L
  real*8   kappa
  integer,parameter :: max_real = 3
  !--- etc -------------------------------------------
  integer     :: i
  real*8      :: r,rr
  !--- decay functions -------------------------------
  real*8   B_decay,Crr
  external B_decay,Crr

  read(5,*) a0, L, kappa

  do i=1,L*max_real
     r=i*a0
     rr=r**2
     write(6,'(i3,f6.1,2e16.7E3)') i, r, B_decay(r,rr,kappa), Crr(r,rr,kappa)
  end do
end program decay_test
