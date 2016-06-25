! mirror_force_mirror.F -*-f90-*-
! Time-stamp: <2016-06-25 16:49:16 takeshi>
! Author: Takeshi NISHIMATSU
!!
#include "define.h"
subroutine mirror_force_mirror(p,c,e)
  use Param_module
  use Coord_module
  use Energy_module
  use msg_module
  implicit none
  type(Param_type),  intent(inout) :: p
  type(Coord_type),  intent(inout) :: c
  type(Energy_type), intent(out)   :: e
  integer ix,iy,iz
  real*8 tmp_dipole_E_field

  if (p%verbose>=4) call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'mirror_force_mirror().')

  ! mirror
  if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
     call    mirror(p, c%dipoR)
     !call   mirror(p, c%mass_dipo_inv)
     !if (p%mass_acou > 0.0d0) then
     !   call mirror(p, c%acouR)
     !end if
  end if

  ! FFT
  call    dipoFFT(p,c)
  if (p%mass_acou(1) > 0.0d0) then
     call acouFFT(p,c)
  end if

  ! dVddi and dVdac
  call  dVddi_dipole_dipole(p,c,e)
  call     dVddi_unharmonic(p,c,e)

  if (p%E_field_always_zero) then   ! This was "call dVddi_E_field(p,c,e)".
     e%dipole_E_field = 0.0d0
  else
!$omp parallel do
     do iz = 0, p%Lz-1
        do iy = 0, p%Ly-1
           do ix = 0, p%Lx-1
              c%dVddi(:,ix,iy,iz) = c%dVddi(:,ix,iy,iz) - c%Z_starR(ix,iy,iz) * c%E_field(:,ix,iy,iz)
           end do
        end do
     end do
!$omp end parallel do

     tmp_dipole_E_field = 0.0d0
!$omp parallel do reduction(+:tmp_dipole_E_field)
     do iz = 0, p%Lz-1
        do iy = 0, p%Ly-1
           do ix = 0, p%Lx-1
              tmp_dipole_E_field = tmp_dipole_E_field + c%Z_starR(ix,iy,iz) * &
                   &                        dot_product(c%dipoR(:,ix,iy,iz),  &
                   &                                  c%E_field(:,ix,iy,iz))
           end do
        end do
     end do
!$omp end parallel do
     e%dipole_E_field = - tmp_dipole_E_field
  end if

  call optimize_homo_strain(p,c,e)
  call dVddi_homo_coupling(p,c)

  if (p%mass_acou(1) > 0.0d0) then
     call dVdac(p,c)
  else
     call optimize_inho_strain(p,c)
  end if
  call inhomogeneous_strain_energy(p,c,e)
  call inhomogeneous_coupling_energy(p,c,e)
  call inhomogeneous_modulation_energy(p,c,e)
  call dVddi_inho_coupling(p,c)

  ! mirror (Maybe, it is not necessary.)
  if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
     call mirror(p, c%dVddi)
     !call mirror(p, c%dVdacR)
  end if

  ! Fixed u of defects must be really fixed after this.

  if (p%verbose>=4) call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '  mirror_force_mirror().')
end subroutine mirror_force_mirror
