! initialize-dipoR.F -*-f90-*-
! Time-stamp: <2016-06-24 15:37:32 takeshi>
! Author: Takeshi NISHIMATSU
! Description: Initialize dipoR and c%mass_dipo_inv(:,:,:) with read_defects_u.F.
! Parents: hysteresis_loop.F or molecular-dynamics.F
!!
#include "define.h"
subroutine initialize_dipoR(p,c,e)
  use Param_module
  use Coord_module
  use Energy_module
  use marsaglia_tsang_uni64_module
  use msg_module
  implicit none
  type(Param_type),  intent(inout) :: p
  type(Coord_type),  intent(inout) :: c
  type(Energy_type), intent(out)   :: e
  integer ix, iy, iz, alpha, ios, dummy_x, dummy_y, dummy_z
  real*8 dmy,kinetic_energy_dipo,kinetic_energy_acou
  external kinetic_energy_dipo
  call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'initialize_dipoR().')
  open(unit=UNIT_SYSTEM, file=trim(p%filename)//'.restart', status='old', action='read', iostat=ios)
  if (ios.eq.0) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'FILE', trim(p%filename)//'.restart was found.')
     do iz = 0, p%Lz-1
        do iy = 0, p%Ly-1
           do ix = 0, p%Lx-1
              read(UNIT_SYSTEM,*) dummy_x, dummy_y, dummy_z, &
                   c%dipoR(1:3,ix,iy,iz),&
                   c%dipoP(1:3,ix,iy,iz),&
                   c%dVddi(1:3,ix,iy,iz),&
                   c%acouR(1:3,ix,iy,iz),&
                   c%acouP(1:3,ix,iy,iz)
           end do
        end do
     end do
     ! c%dipoP() must be multiplied by c%s_Nose ???
     close(UNIT_SYSTEM)
  else
     call msg(UNIT_LOG, __FILE__, __LINE__, 'FILE_NOT_FOUND', trim(p%filename)//'.restart was NOT found.')
     dmy = normal_dist(p%init_dipo_avg(1),p%init_dipo_dev(1),p%seed(1), p%seed(2))
     do alpha = 1, 3
        do iz = 0, p%Lz-1
           do iy = 0, p%Ly-1
              do ix = 0, p%Lx-1
                 c%dipoR(alpha,ix,iy,iz) = &
                      & normal_dist(p%init_dipo_avg(alpha),p%init_dipo_dev(alpha))
                 if ( cos(M_2PI*(p%k_stripe(1)*ix+p%k_stripe(2)*iy+p%k_stripe(3)*iz+1.0d-4)) < 0.0d0 ) then
                    c%dipoR(alpha,ix,iy,iz) = -c%dipoR(alpha,ix,iy,iz)
                 end if
              end do
           end do
        end do
     end do
     c%dipoP(:,:,:,:) = 0.0d0
     c%acouR(:,:,:,:) = 0.0d0
  end if

  call read_relaxor(p,c)
  call read_defects_u(p,c)   ! Prepares fixed u for defects and c%mass_dipo_inv(:,:,:).

  call mirror_force_mirror(p,c,e)

  c%s_Nose  = 1.0d0   ! s0
  c%pi_Nose = 0.0d0   ! pi0
  e%acou_kinetic    = kinetic_energy_acou(p,c)
  e%dipo_kinetic    = kinetic_energy_dipo(p,c)
  e%H_Nose_Poincare = 0.0d0

  call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '')
end subroutine initialize_dipoR
