! leapfrog.F   -*-f90-*-
! Time-stamp: <2013-02-03 20:29:36 takeshi>
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
  integer Lz_1_4
  integer Lz_3_4
  integer iz,alpha
  real*8 kinetic_energy_dipo
  external kinetic_energy_dipo
  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', '')
  end if

  Lx_Ly_delta_e = p%Lx * p%Ly * p%delta_e
  Lz_1_4 = p%Lz/4
  Lz_3_4 = Lz_1_4*3

  if (p%delta_e.ne.0.0d0 .and. i_step>p%n_thermalize) then
!$omp parallel do
     do iz=0,p%Lz-1
        c%e_layer_dipo(iz) = SUM( c%dipoP(:,:,iz,:) * c%dipoP(:,:,iz,:) * c%m_inv(:,:,iz,:) ) / 2
     end do
!$omp end parallel do
     c%dipoP(:,:,Lz_1_4,:) = c%dipoP(:,:,Lz_1_4,:) * sqrt((c%e_layer_dipo(Lz_1_4)+Lx_Ly_delta_e)/c%e_layer_dipo(Lz_1_4))
     c%dipoP(:,:,Lz_3_4,:) = c%dipoP(:,:,Lz_3_4,:) * sqrt((c%e_layer_dipo(Lz_3_4)-Lx_Ly_delta_e)/c%e_layer_dipo(Lz_3_4))
  end if

!$omp parallel do
  do iz=0, p%Lz-1
     do alpha = 1,3
        c%dipoP(:,:,iz,alpha) = c%dipoP(:,:,iz,alpha) - p%dt_2 * c%dVddi(:,:,iz,alpha)
     end do
  end do
!$omp end parallel do
!$omp parallel do
  do iz=0, p%Lz-1
     do alpha = 1,3
        c%dipoR(:,:,iz,alpha) = c%dipoR(:,:,iz,alpha) + p%dt   * c%dipoP(:,:,iz,alpha) * c%M_inv(:,:,iz,alpha)
     end do
  end do
!$omp end parallel do
  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'dipoR', 'updated.')
  end if

  call mirror_force_mirror(p,c,e)

!$omp parallel do
  do iz=0, p%Lz-1
     do alpha = 1,3
        c%dipoP(:,:,iz,alpha) = c%dipoP(:,:,iz,alpha) - p%dt_2 * c%dVddi(:,:,iz,alpha)
     end do
  end do
!$omp end parallel do
! e%acou_kinetic = kinetic_energy_acou(p,c)
  e%dipo_kinetic = kinetic_energy_dipo(p,c)
  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'END', 'dipoP is updated at this end.')
  end if
end subroutine leapfrog
