! potentials.F -*-f90-*-
! Time-stamp: <2011-06-15 19:04:39 takeshi>
! Author: Takeshi NISHIMATSU
!!
#include "define.h"
subroutine potentials(p,c)
  use Param_module
  use Coord_module
  implicit none
  type(Param_type), intent(in)    :: p
  type(Coord_type), intent(inout) :: c 
  call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', ': construction of potentials.')
  call dipole_dipole(p,c)
  call elastic(p,c)
  call msg(UNIT_LOG, __FILE__, __LINE__, 'END',   ': construction of potentials.')
end subroutine potentials
