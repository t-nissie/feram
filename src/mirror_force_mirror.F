! mirror_force_mirror.F -*-f90-*-
! Time-stamp: <2011-11-04 17:21:10 takeshi>
! Author: Takeshi NISHIMATSU
!!
subroutine mirror_force_mirror(p,c,e)
  use Param_module
  use Coord_module
  use Energy_module
  implicit none
  type(Param_type),  intent(inout) :: p
  type(Coord_type),  intent(inout) :: c
  type(Energy_type), intent(out)   :: e

  ! mirror
  if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
     call mirror(p, c%dipoR)
     !call mirror(p, c%m_inv)
  end if

  ! force
  call dipoFFT(p,c)
  call  dVddi_dipole_dipole(p,c,e)
  call     dVddi_unharmonic(p,c,e)
  if (p%E_field_always_zero) then   ! This was "call dVddi_E_field(p,c,e)".
     e%dipole_E_field = 0.0d0
  else
!POPTION COALESCING(2)
     c%dVddi(:,:,:,:) = c%dVddi(:,:,:,:) - p%Z_star*c%E_field(:,:,:,:)
     e%dipole_E_field = - p%Z_star * sum(c%dipoR(:,:,:,:)*c%E_field(:,:,:,:))
  end if
  call optimize_homo_strain(p,c,e)   ! It calls dVddi_homo_coupling().
  call optimize_inho_strain(p,c,e)

  ! mirror (Maybe, it is not necessary.)
  if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
     call mirror(p, c%dVddi)
  end if

  ! Fixed u of defects must be really fixed after this.
end subroutine mirror_force_mirror
