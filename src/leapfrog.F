! leapfrog.F   -*-f90-*-
! Time-stamp: <2010-10-10 19:36:59 takeshi>
! Author: Takeshi NISHIMATSU
!!
subroutine leapfrog(p,c,e)
  use Param_module
  use Coord_module
  use Energy_module
  implicit none
  type(Param_type),  intent(in)    :: p
  type(Coord_type),  intent(inout) :: c
  type(Energy_type), intent(out)   :: e
  call msg(6, __FILE__, __LINE__, 'BEGIN', '')

  c%dipoP(:,:,:,:) = c%dipoP(:,:,:,:) - p%dt_2 * c%dVddi(:,:,:,:)
  c%dipoR(:,:,:,:) = c%dipoR(:,:,:,:) + p%dt   * c%dipoP(:,:,:,:) * c%M_inv(:,:,:,:)
  call msg(6, __FILE__, __LINE__, 'dipoR', ' is updated.')

  call mirror_force_mirror(p,c,e)

  c%dipoP(:,:,:,:) = c%dipoP(:,:,:,:) - p%dt_2 * c%dVddi(:,:,:,:)
  e%dipo_kinetic = SUM( c%dipoP(:,:,:,:) * c%dipoP(:,:,:,:) * c%m_inv(:,:,:,:) ) / 2
  call msg(6, __FILE__, __LINE__, 'END', ': dipoP is updated at this end.')
end subroutine leapfrog
