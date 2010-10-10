! mirror_force_mirror.F -*-f90-*-
! Time-stamp: <2010-10-10 19:40:59 takeshi>
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

  ! mirror
  if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
     call mirror(p,c, c%dipoR)
     !call mirror(p,c, c%m_inv)
  end if

  ! force
  call dipoFFT(p,c)
  call  dVddi_dipole_dipole(p,c,e)
  call     dVddi_unharmonic(p,c,e)
  call        dVddi_E_field(p,c,e)
  call optimize_homo_strain(p,c,e)   ! It calls dVddi_homo_coupling().
  call optimize_inho_strain(p,c,e)

  ! mirror (Maybe, it is not necessary.)
  if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
     call mirror(p,c, c%dVddi)
  end if

  ! Fixed u of defects must be really fixed after this.
end subroutine mirror_force_mirror
