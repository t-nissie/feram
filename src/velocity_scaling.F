! velocity_scaling.F   -*-f90-*-
! Time-stamp: <2013-01-10 15:13:06 takeshi>
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
  implicit none
  type(Param_type),  intent(inout) :: p
  type(Coord_type),  intent(inout) :: c
  type(Energy_type), intent(out)   :: e
  integer iz
  real*8 scale,kinetic_energy
  external kinetic_energy
  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', '')
  end if

!$omp parallel do
     do iz=0, p%Lz-1
           c%dipoR(:,:,iz,:) = c%dipoR(:,:,iz,:) + p%dt * c%dipoP(:,:,iz,:) * c%m_inv(:,:,iz,:)
     end do
!$omp end parallel do

     if (p%mass_acou > 0.0d0) then
!$omp parallel do
        do iz=0, p%Lz-1
           c%acouR(:,:,iz,:) = c%acouR(:,:,iz,:) + p%dt * c%acouP(:,:,iz,:) * c%m_inv(:,:,iz,:)
        end do
!$omp end parallel do
     end if

     call mirror_force_mirror(p,c,e)
!$omp parallel do
     do iz=0, p%Lz-1
        c%dipoP(:,:,iz,:) = c%dipoP(:,:,iz,:) - p%dt * c%dVddi(:,:,iz,:)
     end do
!$omp end parallel do

     e%dipo_kinetic = kinetic_energy(p,c)
     scale = sqrt(p%target_kinetic_energy/e%dipo_kinetic)
!$omp parallel do
     do iz=0, p%Lz-1
        c%dipoP(:,:,iz,:) = c%dipoP(:,:,iz,:) * scale
     end do
!$omp end parallel do

  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'END', 'dipoP is updated at this end.')
  end if
end subroutine velocity_scaling
