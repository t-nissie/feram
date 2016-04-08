! decay_fuction_check.f   -*-f90-*-
! Time-stamp: <2016-04-08 17:52:51 takeshi>
! Author: Takeshi NISHIMATSU
! Usage:  ./decay_function_check 4.0 16 0.22
! $Date: 2012-07-06 21:27:09 +0900 (金, 06  7 2012) $
! $Rev: 1340 $
! $Author: t-nissie $
!!
program decay_function_check
  use decay_function_module
  implicit none
  real*8   a0
  integer  L
  real*8   kappa
  integer,parameter :: max_real = 3
  integer     :: i
  real*8      :: r,rr
  character(len=30) :: str
  if (command_argument_count().ne.3) then
     write(0,'(a,a,i2,a)') __FILE__, ':', __LINE__, ': ERROR: Three command-line arguments are required.'
     stop 1
  end if
  call get_command_argument(1,str); read(str,*) a0
  call get_command_argument(2,str); read(str,*) L
  call get_command_argument(3,str); read(str,*) kappa
  do i=1,L*max_real
     r=i*a0
     rr=r**2
     write(6,'(i3,f6.1,2e16.7E3)') i, r, B_decay(r,rr,kappa), Crr(r,rr,kappa)
  end do
end program decay_function_check
