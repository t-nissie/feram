! leapfrog.F   -*-f90-*-
! Time-stamp: <2011-03-08 17:55:27 takeshi>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
subroutine leapfrog(p,c,e,i_step)
  use Param_module
  use Coord_module
  use Energy_module
  implicit none
  type(Param_type),  intent(in)    :: p
  type(Coord_type),  intent(inout) :: c
  type(Energy_type), intent(out)   :: e
  integer i_step
  real*8 Lx_Ly_delta_e
  integer Lz_1_4
  integer Lz_3_4
  integer i
#if defined(DETAILED_MESSAGES)
  call msg(6, __FILE__, __LINE__, 'BEGIN', '')
#endif

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

  c%dipoP(:,:,:,:) = c%dipoP(:,:,:,:) - p%dt_2 * c%dVddi(:,:,:,:)
  c%dipoR(:,:,:,:) = c%dipoR(:,:,:,:) + p%dt   * c%dipoP(:,:,:,:) * c%M_inv(:,:,:,:)
  call msg(6, __FILE__, __LINE__, 'dipoR', ' is updated.')

  call mirror_force_mirror(p,c,e)

  c%dipoP(:,:,:,:) = c%dipoP(:,:,:,:) - p%dt_2 * c%dVddi(:,:,:,:)
  e%dipo_kinetic = SUM( c%dipoP(:,:,:,:) * c%dipoP(:,:,:,:) * c%m_inv(:,:,:,:) ) / 2
#if defined(DETAILED_MESSAGES)
  call msg(6, __FILE__, __LINE__, 'END', ': dipoP is updated at this end.')
#endif
end subroutine leapfrog
