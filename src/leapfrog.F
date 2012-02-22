! leapfrog.F   -*-f90-*-
! Time-stamp: <2012-02-22 15:18:30 takeshin>
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
  integer i
  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', '')
  end if

  Lx_Ly_delta_e = p%Lx * p%Ly * p%delta_e
  Lz_1_4 = p%Lz/4
  Lz_3_4 = Lz_1_4*3

  if (p%delta_e.ne.0.0d0 .and. i_step>p%n_thermalize) then
     do i=0,p%Lz-1
        c%e_layer(i) = SUM( c%dipoP(:,:,i,:) * c%dipoP(:,:,i,:) * c%m_inv(:,:,i,:) ) / 2
     end do
     c%dipoP(:,:,Lz_1_4,:) = c%dipoP(:,:,Lz_1_4,:) * sqrt((c%e_layer(Lz_1_4)+Lx_Ly_delta_e)/c%e_layer(Lz_1_4))
     c%dipoP(:,:,Lz_3_4,:) = c%dipoP(:,:,Lz_3_4,:) * sqrt((c%e_layer(Lz_3_4)-Lx_Ly_delta_e)/c%e_layer(Lz_3_4))
  end if

!POPTION COALESCING(2)
  c%dipoP(:,:,:,:) = c%dipoP(:,:,:,:) - p%dt_2 * c%dVddi(:,:,:,:)
!POPTION COALESCING(2)
  c%dipoR(:,:,:,:) = c%dipoR(:,:,:,:) + p%dt   * c%dipoP(:,:,:,:) * c%M_inv(:,:,:,:)
  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'dipoR', 'updated.')
  end if

  call mirror_force_mirror(p,c,e)

!POPTION COALESCING(2)
  c%dipoP(:,:,:,:) = c%dipoP(:,:,:,:) - p%dt_2 * c%dVddi(:,:,:,:)
!POPTION COALESCING(2)
  e%dipo_kinetic = SUM( c%dipoP(:,:,:,:) * c%dipoP(:,:,:,:) * c%m_inv(:,:,:,:) ) / 2
  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'END', 'dipoP is updated at this end.')
  end if
end subroutine leapfrog
