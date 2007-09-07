! leapfrog.F   -*-f90-*-
! Time-stamp: <2007-08-07 14:48:19 t-nissie>
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

  ! MIRROR dipoR HERE
  if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
     call mirror(p, c%dipoR)
  end if

  call dipoFFT(p,c)
  call  dVddi_dipole_dipole(p,c,e)
  call     dVddi_unharmonic(p,c,e)
  call        dVddi_E_field(p,c,e)
  call optimize_homo_strain(p,c,e)
  call optimize_inho_strain(p,c,e)
  if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
     call mirror(p, c%dVddi)
  end if
  c%dipoP(:,:,:,:) = c%dipoP(:,:,:,:) - p%dt_2 * c%dVddi(:,:,:,:)
  e%dipo_kinetic = SUM( c%dipoP(:,:,:,:) * c%dipoP(:,:,:,:) * c%m_inv(:,:,:,:) ) / 2
  call msg(6, __FILE__, __LINE__, 'END', ': dipoP is updated at this end.')
end subroutine leapfrog
