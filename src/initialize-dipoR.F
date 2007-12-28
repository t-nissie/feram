! initialize-dipoR.F -*-f90-*-
! Time-stamp: <2007-12-28 13:54:14 takeshi>
! Author: Takeshi NISHIMATSU
!!
#include "define.h"
subroutine initialize_dipoR(p,c,e)
  use Param_module
  use Coord_module
  use Energy_module
  implicit none
  type(Param_type),  intent(in)    :: p
  type(Coord_type),  intent(inout) :: c
  type(Energy_type), intent(out)   :: e
  integer ix, iy, iz, alpha, ios, dummy_x, dummy_y, dummy_z
  !integer sign
  real*8 normal_dist
  external normal_dist
  call msg(6, __FILE__, __LINE__, 'BEGIN', '')
  open(unit=UNIT_SYSTEM, file='restart.coord', status='old', action='read', iostat=ios)
  if (ios.eq.0) then
     call msg(6, __FILE__, __LINE__, 'FILE: ', 'restart.coord was found.')
     do iz = 0, p%Lz-1
        do iy = 0, p%Ly-1
           do ix = 0, p%Lx-1
              read(UNIT_SYSTEM,*) dummy_x, dummy_y, dummy_z, &
                   c%dipoR(ix,iy,iz,1),c%dipoR(ix,iy,iz,2),c%dipoR(ix,iy,iz,3),&
                   c%dipoP(ix,iy,iz,1),c%dipoP(ix,iy,iz,2),c%dipoP(ix,iy,iz,3)
           end do
        end do
     end do
     close(UNIT_SYSTEM)
  else
     call msg(6, __FILE__, __LINE__, 'FILE: ', 'restart.coord was NOT found.')
     do alpha = 1, 3
        do iz = 0, p%Lz-1
           do iy = 0, p%Ly-1
              do ix = 0, p%Lx-1
                 c%dipoR(ix,iy,iz,alpha) = &
                      & normal_dist(p%init_dipo_avg(alpha),p%init_dipo_dev(alpha))
                 if (p%init_dipo_stripe_lambda_2.ne.0 .and. mod(ix/p%init_dipo_stripe_lambda_2,2).eq.1) then
                    c%dipoR(ix,iy,iz,alpha) = -c%dipoR(ix,iy,iz,alpha)
                 end if
              end do
           end do
        end do
     end do
     c%dipoP(:,:,:,:) = 0.0d0
  end if

  ! deffect and mirror dipoR
  if (p%defect_position(1).ge.0) then
     c%dipoR(p%defect_position(1),p%defect_position(2),p%defect_position(3),:) = p%defect_u(:)
     c%m_inv(p%defect_position(1),p%defect_position(2),p%defect_position(3),:) = LARGE_MASS_INV
  end if
  if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
     call mirror(p, c%dipoR)
  end if

  call dipoFFT(p,c)
  call   dVddi_dipole_dipole(p,c,e)
  call      dVddi_unharmonic(p,c,e)
  call         dVddi_E_field(p,c,e)
  call  optimize_homo_strain(p,c,e)
  call  optimize_inho_strain(p,c,e)

  ! deffect
  if (p%defect_position(1).ge.0) then
     c%dVddi(p%defect_position(1),p%defect_position(2),p%defect_position(3),:) = 0.0d0
  end if

  ! mirror dVddi
  if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
     call mirror(p, c%dVddi)
  end if

  c%s_Nose  = 1.0d0   ! s0
  c%pi_Nose = 0.0d0   ! pi0
  e%dipo_kinetic    = SUM( c%dipoP(:,:,:,:) * c%dipoP(:,:,:,:) * c%m_inv(:,:,:,:) ) / 2
  e%H_Nose_Poincare = 0.0d0

  call msg(6, __FILE__, __LINE__, 'END', '')
end subroutine initialize_dipoR
