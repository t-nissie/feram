! leapfrog.F   -*-f90-*-
! Time-stamp: <2011-02-21 15:50:00 takeshi>
! Author: Takeshi NISHIMATSU
!!
#include "define.h"
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
  call msg(6, __FILE__, __LINE__, 'BEGIN', '')

  Lx_Ly_delta_e = p%Lx * p%Ly * p%delta_e
  Lz_1_4 = p%Lz/4
  Lz_3_4 = Lz_1_4*3

  if (p%delta_e.ne.0.0d0 .and. i_step>p%n_thermalize) then
     do i=0,p%Lz-1
        c%e_layer(i) = SUM( c%dipoP(:,:,i,:) * c%dipoP(:,:,i,:) * c%m_inv(:,:,i,:) ) / 2
     end do
     c%dipoP(:,:,Lz_1_4,:) = c%dipoP(:,:,Lz_1_4,:) * sqrt((c%e_layer(Lz_1_4)+Lx_Ly_delta_e)/c%e_layer(Lz_1_4))
     c%dipoP(:,:,Lz_3_4,:) = c%dipoP(:,:,Lz_3_4,:) * sqrt((c%e_layer(Lz_3_4)-Lx_Ly_delta_e)/c%e_layer(Lz_3_4))
!      if (mod(i_step, p%n_coord_freq) == 0) then
!         write(fn_e_layer,'(a,a,i10.10,a)') trim(p%filename), '.', i_step, '.T_layer'
!         open(UNIT=UNIT_T_LAYER,FILE=fn_e_layer)
!         do i=0,p%Lz-1
!            write(UNIT_T_LAYER,'(i9,f13.8)') i, c%e_layer(i) / p%Lx / p%Ly * 0.666666666666666666666666666667d0 * KELVIN_EV
!         end do
!      end if
  end if

  c%dipoP(:,:,:,:) = c%dipoP(:,:,:,:) - p%dt_2 * c%dVddi(:,:,:,:)
  c%dipoR(:,:,:,:) = c%dipoR(:,:,:,:) + p%dt   * c%dipoP(:,:,:,:) * c%M_inv(:,:,:,:)
  call msg(6, __FILE__, __LINE__, 'dipoR', ' is updated.')

  call mirror_force_mirror(p,c,e)

  c%dipoP(:,:,:,:) = c%dipoP(:,:,:,:) - p%dt_2 * c%dVddi(:,:,:,:)
  e%dipo_kinetic = SUM( c%dipoP(:,:,:,:) * c%dipoP(:,:,:,:) * c%m_inv(:,:,:,:) ) / 2
  call msg(6, __FILE__, __LINE__, 'END', ': dipoP is updated at this end.')
end subroutine leapfrog
