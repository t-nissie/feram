! decay_fuction_check.f   -*-f90-*-
! Author: Takeshi NISHIMATSU
! Usage1: ./decay_function_check
! Usage2: ./decay_function_check 3.94 16 0.1125
! $Date$
! $Rev$
! $Author$
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
  if (command_argument_count().eq.3) then
     call get_command_argument(1,str); read(str,*) a0
     call get_command_argument(2,str); read(str,*) L
     call get_command_argument(3,str); read(str,*) kappa
  else if (command_argument_count().eq.0) then
     a0=3.94d0
     L=16
     kappa=0.1125d0
  else
     write(0,'(a,a,i2,a)') __FILE__, ':', __LINE__, &
          & ': ERROR: Zero or three command-line argument(s) are required.'
     stop 1
  end if
  do i=1,L*max_real
     r=i*a0
     rr=r**2
     write(6,'(i3,f6.1,2e16.7E3)') i, r, B_decay(r,rr,kappa), Crr(r,rr,kappa)
  end do
end program decay_function_check
