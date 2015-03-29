! leapfrog.F   -*-f90-*-
! Time-stamp: <2015-03-29 19:47:04 takeshi>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
#include "define.h"
subroutine leapfrog(p,c,e,i_step)
  use Param_module
  use Coord_module
  use Energy_module
  implicit none
  type(Param_type),  intent(inout) :: p
  type(Coord_type),  intent(inout) :: c
  type(Energy_type), intent(out)   :: e
  integer i_step
  real*8 Lx_Ly_delta_e
  real*8 Lx_Ly_delta_e_acou
  integer Lz_1_4
  integer Lz_3_4
  integer alpha,ix,iy,iz
  real*8   kinetic_energy_dipo, kinetic_energy_acou
  external kinetic_energy_dipo, kinetic_energy_acou
  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', '')
  end if

  Lx_Ly_delta_e      = p%Lx * p%Ly * p%delta_e
  Lx_Ly_delta_e_acou = p%Lx * p%Ly * p%delta_e_acou
  Lz_1_4 = p%Lz/4
  Lz_3_4 = Lz_1_4*3

  if (p%delta_e.ne.0.0d0 .or. p%delta_e_acou.ne.0.0d0) then
!$omp parallel do private(iz, iy, ix, alpha)
     do iz=0,p%Lz-1
        do iy=0, p%Ly-1
           do ix=0, p%Lx-1
              do alpha = 1,3
                 c%e_layer_dipo(iz) = c%e_layer_dipo(iz) + &
                      & c%dipoP(alpha,ix,iy,iz)**2 * &
                      & c%m_inv(alpha,ix,iy,iz)
              end do
           end do
        end do
        c%e_layer_dipo(iz) = c%e_layer_dipo(iz) / 2
     end do
!$omp end parallel do
     if (p%mass_acou>0.0d0) then
!$omp parallel do private(iz, iy, ix, alpha)
        do iz=0,p%Lz-1
           do iy=0, p%Ly-1
              do ix=0, p%Lx-1
                 do alpha = 1,3
                    c%e_layer_acou(iz) = c%e_layer_acou(iz) + c%acouP(alpha,ix,iy,iz)**2
                 end do
              end do
           end do
           c%e_layer_acou(iz) = c%e_layer_acou(iz) * p%mass_acou_inv / 2
        end do
!$omp end parallel do
     else
        c%e_layer_acou(:) = 0.0d0
     end if
  end if

  if (p%delta_e.ne.0.0d0) then
     c%dipoP(:,:,:,Lz_1_4) = c%dipoP(:,:,:,Lz_1_4) * sqrt((c%e_layer_dipo(Lz_1_4)+Lx_Ly_delta_e)/c%e_layer_dipo(Lz_1_4))
     c%dipoP(:,:,:,Lz_3_4) = c%dipoP(:,:,:,Lz_3_4) * sqrt((c%e_layer_dipo(Lz_3_4)-Lx_Ly_delta_e)/c%e_layer_dipo(Lz_3_4))
  end if

  if (p%delta_e_acou.ne.0.0d0) then
     c%acouP(:,:,:,Lz_1_4) = c%acouP(:,:,:,Lz_1_4) * sqrt((c%e_layer_acou(Lz_1_4)+Lx_Ly_delta_e_acou)/c%e_layer_acou(Lz_1_4))
     c%acouP(:,:,:,Lz_3_4) = c%acouP(:,:,:,Lz_3_4) * sqrt((c%e_layer_acou(Lz_3_4)-Lx_Ly_delta_e_acou)/c%e_layer_acou(Lz_3_4))
  end if

  if (i_step.eq.0) then
     call mirror_force_mirror(p,c,e)
!$omp parallel do
     do iz=0, p%Lz-1
        c%dipoP(:,:,:,iz) = c%dipoP(:,:,:,iz) - p%dt_2 * c%dVddi(:,:,:,iz)
     end do
!$omp end parallel do
     if (p%mass_acou > 0.0d0) then
!$omp parallel do
        do iz=0, p%Lz-1
           c%acouP(:,:,:,iz) = c%acouP(:,:,:,iz) - p%dt_2 * c%dVdacR(:,:,:,iz)
        end do
!$omp end parallel do
     end if
  else
!$omp parallel do
     do iz=0, p%Lz-1
        do iy=0, p%Ly-1
           c%dipoR(:,:,iy,iz) = c%dipoR(:,:,iy,iz) + p%dt   * c%dipoP(:,:,iy,iz) * c%m_inv(:,:,iy,iz)
        end do
     end do
!$omp end parallel do
     if (p%mass_acou > 0.0d0) then
!$omp parallel do
        do iz=0, p%Lz-1
              c%acouR(:,:,:,iz) = c%acouR(:,:,:,iz) + (p%dt*p%mass_acou_inv) * c%acouP(:,:,:,iz)
        end do
!$omp end parallel do
     end if
     if (p%verbose>=2) then
        call msg(UNIT_LOG, __FILE__, __LINE__, 'dipoR', 'updated.')
     end if

     call mirror_force_mirror(p,c,e)

!$omp parallel do
     do iz=0, p%Lz-1
        c%dipoP(:,:,:,iz) = c%dipoP(:,:,:,iz) - p%dt * c%dVddi(:,:,:,iz)
     end do
!$omp end parallel do
     if (p%mass_acou > 0.0d0) then
!$omp parallel do
        do iz=0, p%Lz-1
           c%acouP(:,:,:,iz) = c%acouP(:,:,:,iz) - p%dt * c%dVdacR(:,:,:,iz)
        end do
!$omp end parallel do
     end if
  end if

  e%dipo_kinetic    = kinetic_energy_dipo(p,c)
  if (p%mass_acou > 0.0d0) then
     e%acou_kinetic = kinetic_energy_acou(p,c)
  end if

  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'END', 'dipoP is updated at this end.')
  end if
end subroutine leapfrog
