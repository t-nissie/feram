! coord2deviation.F -*-f90-*-
! Time-stamp: <2012-08-22 13:43:57 t-nissie>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif

#if defined(__PGI) || defined(__sparc)
#  define command_argument_count iargc
#  define get_command_argument getarg
#endif

program coord2deviation
  implicit none
  integer i, argn, command_argument_count
  character(len=300) :: fn
  argn = command_argument_count()
  do i=1,argn
     call get_command_argument(i,fn)
     call coord2deviation_main(fn)
  end do
end program coord2deviation

subroutine coord2deviation_main(fn)
  implicit none
  character(len=*) :: fn
  integer N, ix,iy,iz, ios
  real*8 u(3), sum_u(3), sum_uu(3), avg_u(3), deviation(3)

  open(8,FILE=fn, status='old', action='read')

  N = 0
  sum_u( 1:3) = 0.0d0
  sum_uu(1:3) = 0.0d0
  do
     read(8, *, IOSTAT=ios) ix,iy,iz,u(1:3)
     if (ios.ne.0) exit
     N = N+1
     sum_u( 1:3) = sum_u( 1:3) + u(1:3)
     sum_uu(1:3) = sum_uu(1:3) + u(1:3)*u(1:3)
  end do

  avg_u(1:3) = sum_u(1:3)/N
  deviation(1:3) = sqrt(sum_uu(1:3)/N - avg_u(1:3)*avg_u(1:3))

  write(6,*)
  write(6,'(a)') '==> ' // trim(fn) // ' <=='
  write(6,'(i10)') N
  write(6,'(3f10.6)') avg_u(1:3)
  write(6,'(3f10.6)') deviation(1:3)
 end subroutine coord2deviation_main
