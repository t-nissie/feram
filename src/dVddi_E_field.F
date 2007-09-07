! dVddi_E_field.F   -*-f90-*-
! Time-stamp: <2007-08-08 16:20:52 t-nissie>
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
  !call msg(6, __FILE__, __LINE__, 'BEGIN', ': Calculate dipole - E_field part of force and energy.')
  c%dVddi(:,:,:,:) = c%dVddi(:,:,:,:) - p%Z_star*c%E_field(:,:,:,:)
  call dipole_E_field_energy(p,c,e)
  !call msg(6, __FILE__, __LINE__, 'END', '')
end subroutine dVddi_E_field
