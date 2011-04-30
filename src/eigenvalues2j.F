! eigenvalues2j.F -*-f90-*-
! Time-stamp: <2011-04-30 18:16:57 takeshi>
! Author: Takeshi NISHIMATSU
! ref_1: W. Zhong, David Vanderbilt and K. M. Rabe: PRB Vol.52 p.6301 (1995)
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

program eigenvalues2j
  use Param_module
  implicit none
  type(Param_type) :: p
  integer i, fd, argn, command_argument_count, INFO, IPIV(8)
  ! solve A*x=b
  real*8            :: A(8,8)
  real*8            :: Az(6,6)
  real*8            :: b(0:7) !kappa_2, j_1, j_2, j_3, j_4, j_5, j_6, j_7, j_8
  logical           :: j5j7zero
  character(len=110) :: message

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

  A = reshape((/ 1.0d0,  1.0d0,  1.0d0,  1.0d0,  1.0d0,  1.0d0,  1.0d0,  0.0d0, &
                 2.0d0,  2.0d0,  0.0d0, -2.0d0,  0.0d0, -2.0d0,  1.0d0,  0.0d0, &
                 1.0d0, -1.0d0,  1.0d0,  1.0d0, -1.0d0, -1.0d0,  0.0d0,  0.0d0, &
                 4.0d0, -4.0d0,  0.0d0, -4.0d0,  0.0d0,  4.0d0,  0.0d0,  0.0d0, &
                 2.0d0,  2.0d0, -2.0d0,  2.0d0, -2.0d0,  2.0d0,  0.0d0,  0.0d0, &
                 0.0d0,  0.0d0,  0.0d0,  0.0d0,  0.0d0,  0.0d0, -2.0d0,  0.0d0, &
                 4.0d0, -4.0d0, -4.0d0,  4.0d0,  4.0d0, -4.0d0,  0.0d0,  1.0d0, &
                 0.0d0,  0.0d0,  0.0d0,  0.0d0,  0.0d0,  0.0d0, -4.0d0, -2.0d0/),(/8,8/))

  Az= reshape((/ 1.0d0,  1.0d0,  1.0d0,  1.0d0,  1.0d0,  1.0d0, &
                 2.0d0,  2.0d0,  0.0d0, -2.0d0,  0.0d0, -2.0d0, &
                 1.0d0, -1.0d0,  1.0d0,  1.0d0, -1.0d0, -1.0d0, &
                 4.0d0, -4.0d0,  0.0d0, -4.0d0,  0.0d0,  4.0d0, &
                 2.0d0,  2.0d0, -2.0d0,  2.0d0, -2.0d0,  2.0d0, &
                 4.0d0, -4.0d0, -4.0d0,  4.0d0,  4.0d0, -4.0d0/),(/6,6/))

  if (p%DDB_g.eq.0) then
     j5j7zero = .true.
  else
     j5j7zero = .false.
  end if

  b(0) = p%DDB_a  -  ( -4.188790 * p%Z_star**2 * HARTREE_BOHR / p%epsilon_inf / p%a0**3 )  !(a) 4*pi/3
  b(1) = p%DDB_b  -  (  9.687445 * p%Z_star**2 * HARTREE_BOHR / p%epsilon_inf / p%a0**3 )  !(b)
  b(2) = p%DDB_c  -  ( -4.843723 * p%Z_star**2 * HARTREE_BOHR / p%epsilon_inf / p%a0**3 )  !(c)
  b(3) = p%DDB_d  -  ( -5.353578 * p%Z_star**2 * HARTREE_BOHR / p%epsilon_inf / p%a0**3 )  !(d)
  b(4) = p%DDB_e  -  (  2.676787 * p%Z_star**2 * HARTREE_BOHR / p%epsilon_inf / p%a0**3 )  !(e)
  b(5) = p%DDB_f  -  (  0.0      * p%Z_star**2 * HARTREE_BOHR / p%epsilon_inf / p%a0**3 )  !(f)
  b(6) = p%DDB_g  -  (  5.864529 * p%Z_star**2 * HARTREE_BOHR / p%epsilon_inf / p%a0**3 )  !(g)
  b(7) = 0.0d0

  b(:) = 0.5d0 * b(:)

  if (j5j7zero) then
     call DGESV( 6, 1, Az, 6, IPIV, b, 6, INFO )
     b(6) = b(5)
     b(5) = 0.0d0
     b(7) = 0.0d0
  else
     call DGESV( 8, 1, A,  8, IPIV, b, 8, INFO )
  end if

  call write_kappa2_and_j_i('     j_1 =', b(1))
  call write_kappa2_and_j_i('     j_2 =', b(2))
  call write_kappa2_and_j_i('     j_3 =', b(3))
  call write_kappa2_and_j_i('     j_4 =', b(4))
  call write_kappa2_and_j_i('     j_5 =', b(5))
  call write_kappa2_and_j_i('     j_6 =', b(6))
  call write_kappa2_and_j_i('     j_7 =', b(7))
  call write_kappa2_and_j_i('P_kappa2 =', b(0))
  write(message,'(a,7f9.5,a)') 'j = ', b(1:7), '    [eV/Angstrom^2]'
  call msg_ez(6, message)
  write(message,'(a,f9.5,a)') 'a0          = ', p%a0, '    [Angstrom]'
  call msg_ez(6, message)
  write(message,'(a,f9.5)')   'Z_star      = ', p%Z_star
  call msg_ez(6, message)
  write(message,'(a,f9.5)')   'epsilon_inf = ', p%epsilon_inf
  call msg_ez(6, message)

  call msg(6, __FILE__, __LINE__, 'END', '')
end program eigenvalues2j

subroutine write_kappa2_and_j_i(str,c)
  implicit none
  character (len=*)            :: str
  real*8                       :: c
  character(len=30), parameter :: fmt_short = '(a,f16.10,a,f16.10,a)'
  character(len=80)            :: message
  write(message,fmt_short) str, c, ' [eV/Angstrom^2] =', c * BOHR_RADIUS**2 / HARTREE_IN_EV, ' [Hartree/Bohr^2]'
  call msg_ez(6, message)
end subroutine write_kappa2_and_j_i

!local variables:
!  compile-command: "make -k eigenvalues2j && ./eigenvalues2j eigenvalues2j.in"
!End:
