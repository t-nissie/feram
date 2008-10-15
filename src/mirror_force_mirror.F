! mirror_force_mirror.F -*-f90-*-
! Time-stamp: <2008-10-14 20:28:56 takeshi>
! Author: Takeshi NISHIMATSU
!!
subroutine mirror_force_mirror(p,c,e)
  use Param_module
  use Coord_module
  use Energy_module
  implicit none
  type(Param_type),  intent(in)    :: p
  type(Coord_type),  intent(inout) :: c
  type(Energy_type), intent(out)   :: e

  ! deffect and mirror dipoR
  if (p%defect_position(1).ge.0) then
     c%dipoR(p%defect_position(1),p%defect_position(2),p%defect_position(3),:) = p%defect_u(:)
  end if

  ! mirror
  if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
     call mirror(p, c%dipoR)
  end if

  ! force
  call dipoFFT(p,c)
  call  dVddi_dipole_dipole(p,c,e)
  call     dVddi_unharmonic(p,c,e)
  call        dVddi_E_field(p,c,e)
  call optimize_homo_strain(p,c,e)   ! It calls dVddi_homo_coupling().
  call optimize_inho_strain(p,c,e)

  ! deffect
  if (p%defect_position(1).ge.0) then
     c%dVddi(p%defect_position(1),p%defect_position(2),p%defect_position(3),:) = 0.0d0
  end if

  ! mirror
  if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
     call mirror(p, c%dVddi)
  end if
end subroutine mirror_force_mirror
