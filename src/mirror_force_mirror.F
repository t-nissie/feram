! mirror_force_mirror.F -*-f90-*-
! Time-stamp: <2012-08-22 13:42:38 t-nissie>
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
  integer ix,iy,iz, alpha
  real*8 tmp_dipole_E_field

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
!$omp parallel do
     do iz = 0, p%Lz-1
     c%dVddi(:,:,iz,:) = c%dVddi(:,:,iz,:) - p%Z_star*c%E_field(:,:,iz,:)
     end do
!$omp end parallel do

     tmp_dipole_E_field = 0.0d0
! HITACHI's compiler is too fool to parallelize e%dipole_E_field = - p%Z_star * sum(c%dipoR(:,:,:,:)*c%E_field(:,:,:,:)).
!$omp parallel do reduction(+:tmp_dipole_E_field)
      do iz = 0, p%Lz-1
         do iy = 0, p%Ly-1
            do ix = 0, p%Lx-1
              do alpha = 1, 3
                 tmp_dipole_E_field = tmp_dipole_E_field + c%dipoR(ix,iy,iz,alpha)*c%E_field(ix,iy,iz,alpha)
              end do
           end do
        end do
     end do
!$omp end parallel do
     e%dipole_E_field = - p%Z_star * tmp_dipole_E_field
  end if

  call optimize_homo_strain(p,c,e)   ! It calls dVddi_homo_coupling().
  call optimize_inho_strain(p,c,e)

  ! mirror (Maybe, it is not necessary.)
  if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
     call mirror(p, c%dVddi)
  end if

  ! Fixed u of defects must be really fixed after this.
end subroutine mirror_force_mirror
