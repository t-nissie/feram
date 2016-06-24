! leapfrog.F   -*-f90-*-
! Time-stamp: <2016-06-24 22:54:24 takeshi>
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
  use msg_module
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
  integer(C_SIZE_T) :: n_alloc_dVdac
  real*8,    pointer :: dVdacR_linear(:)
  real*8,    pointer :: dVdacR(:,:,:,:)
  integer, parameter :: howmany = 3

  if (p%mass_acou(1)>0.0d0) then
     n_alloc_dVdac = howmany * (p%Lx/2+1) * (p%Ly+p%padding_y) * p%Lz
     call c_f_pointer(c%dVdac_ptr, dVdacR_linear, [n_alloc_dVdac * 2])
     dVdacR(1:howmany, 0:2*(p%Lx/2+1)-1, 0:p%Ly+p%padding_y-1, 0:p%Lz-1) => dVdacR_linear
  end if

  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'leapfrog().')
  end if

  Lx_Ly_delta_e      = p%Lx * p%Ly * p%delta_e
  Lx_Ly_delta_e_acou = p%Lx * p%Ly * p%delta_e_acou
  Lz_1_4 = p%Lz/4
  Lz_3_4 = Lz_1_4*3

  if (p%delta_e.ne.0.0d0 .or. p%delta_e_acou.ne.0.0d0) then
!$omp parallel do private(iz, iy, ix, alpha)
     do iz=0,p%Lz-1
        c%e_layer_dipo(iz) = 0.0d0
        do iy=0, p%Ly-1
           do ix=0, p%Lx-1
              do alpha = 1,3
                 c%e_layer_dipo(iz) = c%e_layer_dipo(iz) + &
                      & c%dipoP(alpha,ix,iy,iz)**2 * &
                      & c%mass_dipo_inv(ix,iy,iz)
              end do
           end do
        end do
        c%e_layer_dipo(iz) = c%e_layer_dipo(iz) / 2 * p%Lx * p%Ly / c%n_sum_layer(iz)
     end do
!$omp end parallel do
     if (p%mass_acou(1)>0.0d0) then
!$omp parallel do private(iz, iy, ix, alpha)
        do iz=0,p%Lz-1
           c%e_layer_acou(iz) = 0.0d0
           do iy=0, p%Ly-1
              do ix=0, p%Lx-1
                 do alpha = 1,3
                    c%e_layer_acou(iz) = c%e_layer_acou(iz) + c%acouP(alpha,ix,iy,iz)**2 * c%mass_acou_inv(ix,iy,iz)
                 end do
              end do
           end do
           c%e_layer_acou(iz) = c%e_layer_acou(iz) / 2
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
     if (p%mass_acou(1) > 0.0d0) then
!$omp parallel do
        do iz=0, p%Lz-1
           c%acouP(:,:,:,iz) = c%acouP(:,:,:,iz) - p%dt_2 * dVdacR(:,:,:,iz)
        end do
!$omp end parallel do
     end if
  else
!$omp parallel do
     do iz=0, p%Lz-1
        do iy=0, p%Ly-1
           do ix=0, p%Lx-1
              do alpha = 1,3
                 c%dipoR(alpha,ix,iy,iz)  =  c%dipoR(alpha,ix,iy,iz)  +  p%dt * c%dipoP(alpha,ix,iy,iz) * c%mass_dipo_inv(ix,iy,iz)
              end do
           end do
        end do
     end do
!$omp end parallel do
     if (p%verbose>=2) then
        call msg(UNIT_LOG, __FILE__, __LINE__, 'dipoR', 'is updated.')
     end if

     if (p%mass_acou(1) > 0.0d0) then
!$omp parallel do
        do iz=0, p%Lz-1
           do iy=0, p%Ly-1
              do ix=0, p%Lx-1
                 do alpha = 1,3
                    c%acouR(alpha,ix,iy,iz) = c%acouR(alpha,ix,iy,iz) + p%dt * c%acouP(alpha,ix,iy,iz) * c%mass_acou_inv(ix,iy,iz)
                 end do
              end do
           end do
        end do
!$omp end parallel do
        if (p%verbose>=2) then
           call msg(UNIT_LOG, __FILE__, __LINE__, 'acouR', 'is updated.')
        end if
     end if

     call mirror_force_mirror(p,c,e)

!$omp parallel do
     do iz=0, p%Lz-1
        c%dipoP(:,:,:,iz) = c%dipoP(:,:,:,iz) - p%dt * c%dVddi(:,:,:,iz)
     end do
!$omp end parallel do
     if (p%verbose>=2) then
        call msg(UNIT_LOG, __FILE__, __LINE__, 'dipoP', 'is updated.')
     end if

     if (p%mass_acou(1) > 0.0d0) then
!$omp parallel do
        do iz=0, p%Lz-1
           c%acouP(:,:,:,iz) = c%acouP(:,:,:,iz) - p%dt * dVdacR(:,:,:,iz)
        end do
!$omp end parallel do
        if (p%verbose>=2) then
           call msg(UNIT_LOG, __FILE__, __LINE__, 'acouP', 'is updated.')
        end if
     end if
  end if

  e%dipo_kinetic    = kinetic_energy_dipo(p,c)
  if (p%mass_acou(1) > 0.0d0) then
     e%acou_kinetic = kinetic_energy_acou(p,c)
  end if

  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'END', ' leapfrog().')
  end if
end subroutine leapfrog
