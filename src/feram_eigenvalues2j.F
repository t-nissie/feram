! feram_eigenvalues2j.F -*-f90-*-
! Time-stamp: <2016-04-06 12:23:10 takeshi>
! Author: Takeshi NISHIMATSU
! ref_1: W. Zhong, David Vanderbilt and K. M. Rabe: PRB Vol.52 p.6301 (1995)
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
#include "define.h"

#if defined(__PGI) || defined(__sparc)
#  define command_argument_count iargc
#  define get_command_argument getarg
#endif

program feram_eigenvalues2j
  use Param_module
  use msg_module
  implicit none
  type(Param_type) :: p
  integer command_argument_count, INFO, IPIV(8)
  ! solve A*x=b
  real*8            :: A(8,8)
  real*8            :: Az(6,6)
  real*8            :: b(0:7) !kappa_2, j_1, j_2, j_3, j_4, j_5, j_6, j_7, j_8
  logical           :: j5j7zero
  character(len=110):: message
  if (command_argument_count().ne.1) then
     write(0,'(a,a,i2,a)') __FILE__, ':', __LINE__, ': ERROR: Only one input file is required.'
     stop 1
  end if
  call get_command_argument(1,p%filename)
  open(unit=UNIT_LOG, file=trim(p%filename)//'.log', status='replace')
  call msg(UNIT_LOG, __FILE__, __LINE__, 'START', PACKAGE_STRING)
  call msg(UNIT_LOG, __FILE__, __LINE__, 'feram_eigenvalues2j', &
       & 'calculates coefficients j of short range interaction from eigenvalues of IFC matrices.')
  call  read_Param(p,p%filename)
  call  make_Param(p)

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

  if (p%DDB_g.eq.0.0d0) then
     j5j7zero = .true.
  else
     j5j7zero = .false.
  end if

  b(0) = p%DDB_a  -  ( -4.188790d0 * p%Z_star(1)**2 * HARTREE_BOHR / p%epsilon_inf / p%a0**3 )  !(a) 4*pi/3
  b(1) = p%DDB_b  -  (  9.687445d0 * p%Z_star(1)**2 * HARTREE_BOHR / p%epsilon_inf / p%a0**3 )  !(b)
  b(2) = p%DDB_c  -  ( -4.843723d0 * p%Z_star(1)**2 * HARTREE_BOHR / p%epsilon_inf / p%a0**3 )  !(c)
  b(3) = p%DDB_d  -  ( -5.353578d0 * p%Z_star(1)**2 * HARTREE_BOHR / p%epsilon_inf / p%a0**3 )  !(d)
  b(4) = p%DDB_e  -  (  2.676787d0 * p%Z_star(1)**2 * HARTREE_BOHR / p%epsilon_inf / p%a0**3 )  !(e)
  b(5) = p%DDB_f  -  (  0.0d0      * p%Z_star(1)**2 * HARTREE_BOHR / p%epsilon_inf / p%a0**3 )  !(f)
  b(6) = p%DDB_g  -  (  5.864529d0 * p%Z_star(1)**2 * HARTREE_BOHR / p%epsilon_inf / p%a0**3 )  !(g)
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
  call msg_ez(UNIT_LOG, message)
  write(message,'(a,f9.5,a)') 'a0          = ', p%a0, '    [Angstrom]'
  call msg_ez(UNIT_LOG, message)
  write(message,'(a,f9.5)')   'Z_star(1)   = ', p%Z_star(1)
  call msg_ez(UNIT_LOG, message)
  write(message,'(a,f9.5)')   'epsilon_inf = ', p%epsilon_inf
  call msg_ez(UNIT_LOG, message)

  call msg(UNIT_LOG, __FILE__, __LINE__, 'FINISH', trim(p%filename)//'.log')
  close(unit=UNIT_LOG)
end program feram_eigenvalues2j

subroutine write_kappa2_and_j_i(str,c)
  use msg_module
  implicit none
  character (len=*)            :: str
  real*8                       :: c
  character(len=30), parameter :: fmt_short = '(a,f16.10,a,f16.10,a)'
  character(len=80)            :: message
  write(message,fmt_short) str, c, ' [eV/Angstrom^2] =', c * BOHR_RADIUS**2 / HARTREE_IN_EV, ' [Hartree/Bohr^2]'
  call msg_ez(UNIT_LOG, message)
end subroutine write_kappa2_and_j_i

!local variables:
!  compile-command: "make check TESTS=feram_eigenvalues2j_check.sh"
!End:
