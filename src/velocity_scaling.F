! velocity_scaling.F   -*-f90-*-
! Time-stamp: <2012-03-26 16:37:29 takeshi>
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
  integer ix, iy, iz, alpha
  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', '')
  end if

!POPTION COALESCING(2)
     c%dipoR(:,:,:,:) = c%dipoR(:,:,:,:) + p%dt * c%dipoP(:,:,:,:) * c%m_inv(:,:,:,:)
     call mirror_force_mirror(p,c,e)
!POPTION COALESCING(2)
     c%dipoP(:,:,:,:) = c%dipoP(:,:,:,:) - p%dt * c%dVddi(:,:,:,:)

     !=== e%dipo_kinetic = SUM( c%dipoP(:,:,:,:) * c%dipoP(:,:,:,:) * c%m_inv(:,:,:,:) ) / 2 ===========
     e%dipo_kinetic = 0.0d0
!POPTION PSUM(e%dipo_kinetic)
     do iz=0, p%Lz-1
        do alpha = 1,3
           do iy=0, p%Ly-1
              do ix=0, p%Lx-1
                 e%dipo_kinetic = e%dipo_kinetic + c%dipoP(ix,iy,iz,alpha) * c%dipoP(ix,iy,iz,alpha) * c%m_inv(ix,iy,iz,alpha)
              end do
           end do
        end do
     end do
     e%dipo_kinetic = e%dipo_kinetic / 2
     !==================================================================================================

!POPTION COALESCING(2)
     c%dipoP(:,:,:,:) = c%dipoP(:,:,:,:) * sqrt(p%target_kinetic_energy/e%dipo_kinetic)
     !e%dipo_kinetic = SUM( c%dipoP(:,:,:,:) * c%dipoP(:,:,:,:) * c%m_inv(:,:,:,:) ) / 2

  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'END', 'dipoP is updated at this end.')
  end if
end subroutine velocity_scaling
