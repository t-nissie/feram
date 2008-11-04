! DDB2short.F -*-f90-*-
! Time-stamp: <2008-11-04 17:33:24 takeshi>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif

#include "define.h"

#if defined(SR11000)
   function command_argument_count()
     implicit none
     integer command_argument_count
     open(9, file='FILES')!, status='old', action='read')
     read(9,*) command_argument_count
   end function command_argument_count
   subroutine get_command_argument(i,a)
     implicit none
     integer i
     character (len=*) a
     read(9,*) a
   end subroutine get_command_argument
#elif defined(__PGI)
#  define command_argument_count iargc
#  define get_command_argument getarg
#endif

program DDB2short
  use Param_module
  implicit none
  type(Param_type) :: p
  character(70) message
  integer i, fd, argn, command_argument_count, INFO, IPIV(8)
  ! solve A*x=b
  real*8 :: A(8,8)
  real*8 :: b(8) !kappa_2, j_1, j_2, j_3, j_4, j_5, j_6, j_7, j_8

  write(message,'(a,a)') ': Version ', PACKAGE_VERSION
  call msg(6, __FILE__, __LINE__, 'BEGIN', message)

  argn = command_argument_count()

  if (argn.eq.0) then
     argn = 1
     fd = 5
  else
     fd = 7
  end if

  do i=1,argn
     if (fd.eq.5) then
        p%filename = 'stdin'
     else
        call get_command_argument(i,p%filename)
        open(fd, FILE=p%filename, STATUS='OLD')
     end if
     call msg(6, __FILE__, __LINE__, 'FILENAME: ', trim(p%filename))

     call  read_Param(p,fd)
     call  make_Param(p)
  end do

  b(1) = p%DDB_a * HARTREE_IN_EV / p%a0**2  -  ( -4.188790 * p%Z_star**2 * HARTREE_BOHR / p%epsilon_inf / p%a0**3 )  !(a) 4*pi/3
  b(2) = p%DDB_b * HARTREE_IN_EV / p%a0**2  -  (  9.687445 * p%Z_star**2 * HARTREE_BOHR / p%epsilon_inf / p%a0**3 )  !(b)
  b(3) = p%DDB_c * HARTREE_IN_EV / p%a0**2  -  ( -4.843723 * p%Z_star**2 * HARTREE_BOHR / p%epsilon_inf / p%a0**3 )  !(c)
  b(4) = p%DDB_d * HARTREE_IN_EV / p%a0**2  -  ( -5.353578 * p%Z_star**2 * HARTREE_BOHR / p%epsilon_inf / p%a0**3 )  !(d)
  b(5) = p%DDB_e * HARTREE_IN_EV / p%a0**2  -  (  2.676787 * p%Z_star**2 * HARTREE_BOHR / p%epsilon_inf / p%a0**3 )  !(e)
  b(6) = p%DDB_f * HARTREE_IN_EV / p%a0**2  -  (  0.0      * p%Z_star**2 * HARTREE_BOHR / p%epsilon_inf / p%a0**3 )  !(f)
  b(7) = p%DDB_g * HARTREE_IN_EV / p%a0**2  -  (  5.864529 * p%Z_star**2 * HARTREE_BOHR / p%epsilon_inf / p%a0**3 )  !(g)
  b(8) = 0.0d0




  call DGESV( 8, 1, A, 8, IPIV, b, 8, INFO )

  call msg(6, __FILE__, __LINE__, 'END', '')
end program DDB2short
!local variables:
!  compile-command: "make -k DDB2short && cd 10-example-PbTiO3-DDB2short && ../DDB2short PbTiO3a3.9500.in"
!End:
