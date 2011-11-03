! dVddi_E_field.F   -*-f90-*-
! Time-stamp: <2011-11-03 21:46:23 takeshi>
! Author: Takeshi NISHIMATSU
!!
subroutine dVddi_E_field(p,c,e)
  use Param_module
  use Coord_module
  use Energy_module
  implicit none
  type(Param_type),  intent(in)    :: p
  type(Coord_type),  intent(inout) :: c
  type(Energy_type), intent(out)   :: e
  !call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'Calculate dipole - E_field part of force and energy.')
!POPTION COALESCING(2)
  c%dVddi(:,:,:,:) = c%dVddi(:,:,:,:) - p%Z_star*c%E_field(:,:,:,:)
  e%dipole_E_field = - p%Z_star * sum(c%dipoR(:,:,:,:)*c%E_field(:,:,:,:))
  !call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '')
end subroutine dVddi_E_field
