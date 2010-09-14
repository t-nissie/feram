! potentials.F -*-f90-*-
! Time-stamp: <2010-09-14 18:52:11 takeshi>
! Author: Takeshi NISHIMATSU
!!
subroutine potentials(p,c)
  use Param_module
  use Coord_module
  implicit none
  type(Param_type), intent(in)    :: p
  type(Coord_type), intent(inout) :: c 
  call msg(6, __FILE__, __LINE__, 'BEGIN', ': construction of potentials.')
  call dipole_dipole(p,c)
  call elastic(p,c)
  call msg(6, __FILE__, __LINE__, 'END',   ': construction of potentials.')
end subroutine potentials
