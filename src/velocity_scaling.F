! velocity_scaling.F   -*-f90-*-
! Time-stamp: <2016-04-07 19:21:00 takeshi>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
#include "define.h"
subroutine velocity_scaling(p,c,e)
  use Param_module
  use Coord_module
  use Energy_module
  use msg_module
  implicit none
  type(Param_type),  intent(inout) :: p
  type(Coord_type),  intent(inout) :: c
  type(Energy_type), intent(out)   :: e
  integer ix,iy,iz,alpha
  real*8 scale,kinetic_energy_dipo,kinetic_energy_acou,dt_over_m
  external kinetic_energy_dipo,kinetic_energy_acou
  integer(C_SIZE_T) :: n_alloc_dVdac
  real*8,    pointer :: dVdacR_linear(:)
  real*8,    pointer :: dVdacR(:,:,:,:)
  integer, parameter :: howmany = 3

  if (p%mass_acou>0.0d0) then
     n_alloc_dVdac = howmany * (p%Lx/2+1) * (p%Ly+p%padding_y) * p%Lz
     call c_f_pointer(c%dVdac_ptr, dVdacR_linear, [n_alloc_dVdac * 2])
     dVdacR(1:howmany, 0:2*(p%Lx/2+1)-1, 0:p%Ly+p%padding_y-1, 0:p%Lz-1) => dVdacR_linear
  end if

  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', '')
  end if

!$omp parallel do
  do iz=0, p%Lz-1
     do iy=0, p%Ly-1
        do ix=0, p%Lx-1
           do alpha = 1,3
              c%dipoR(alpha,ix,iy,iz) = c%dipoR(alpha,ix,iy,iz) + p%dt * c%dipoP(alpha,ix,iy,iz) * c%mass_dipo_inv(ix,iy,iz)
           end do
        end do
     end do
  end do
!$omp end parallel do

  if (p%mass_acou > 0.0d0) then
     dt_over_m = p%dt * p%mass_acou_inv
!$omp parallel do
     do iz=0, p%Lz-1
        do iy=0, p%Ly-1
           do ix=0, p%Lx-1
              do alpha = 1,3
                 c%acouR(alpha,ix,iy,iz) = c%acouR(alpha,ix,iy,iz) + dt_over_m*c%acouP(alpha,ix,iy,iz)
              end do
           end do
        end do
     end do
!$omp end parallel do
  end if

  call mirror_force_mirror(p,c,e)

!$omp parallel do private(iz, iy, ix, alpha)
  do iz=0, p%Lz-1
     do iy=0, p%Ly-1
        do ix=0, p%Lx-1
           do alpha = 1,3
              if (c%sum_p(ix, iy, iz)) then
                 c%dipoP(alpha,ix,iy,iz) = c%dipoP(alpha,ix,iy,iz) - p%dt * c%dVddi(alpha,ix,iy,iz)
              else
                 c%dipoP(alpha,ix,iy,iz) = 0.0d0
              end if
           end do
        end do
     end do
  end do
!$omp end parallel do
     e%dipo_kinetic = kinetic_energy_dipo(p,c)
     scale = sqrt(p%target_kinetic_energy/e%dipo_kinetic)
!$omp parallel do
     do iz=0, p%Lz-1
        c%dipoP(:,:,:,iz) = c%dipoP(:,:,:,iz) * scale
     end do
!$omp end parallel do


     if (p%mass_acou > 0.0d0) then
!$omp parallel do
        do iz=0, p%Lz-1
           c%acouP(:,:,:,iz) = c%acouP(:,:,:,iz) - p%dt * dVdacR(:,:,:,iz)
        end do
!$omp end parallel do
        !write(6,'(a, 3(f13.7,2f12.7))') 'acouR', c%acouR(:,0,0,0), c%acouP(:,0,0,0), c%dVdacR(:,0,0,0)
        e%acou_kinetic = kinetic_energy_acou(p,c)
        scale = sqrt(p%target_kinetic_energy/e%acou_kinetic)
!$omp parallel do
        do iz=0, p%Lz-1
           c%acouP(:,:,:,iz) = c%acouP(:,:,:,iz) * scale
        end do
!$omp end parallel do
     end if


  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'END', 'dipoP (and acouP) are updated at this end.')
  end if
end subroutine velocity_scaling
