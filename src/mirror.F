! mirror.F -*-f90-*-
! Time-stamp: <2015-10-19 19:32:11 takeshi>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
#include "define.h"
subroutine mirror(p, dipo)
  use Param_module
  use msg_module
  implicit none
  !--- arguments -------------------------------------
  type(Param_type),   intent(in)    :: p
  real*8 :: dipo(3, 0:2*(p%Lx/2+1)-1, 0:p%Ly+p%padding_y-1, 0:p%Lz-1)
  integer iz
  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', '')
  end if
  if (p%gap_id==0) then ! There is no dead layers.
!$omp parallel do
     do iz = 0, p%Lz/2-1
        dipo(1,:,:,p%Lz-1-iz) = -dipo(1,:,:,iz)
        dipo(2,:,:,p%Lz-1-iz) = -dipo(2,:,:,iz)
        dipo(3,:,:,p%Lz-1-iz) =  dipo(3,:,:,iz)
     end do
!$omp end parallel do
  else                                        ! There are single or double dead layer(s).
!$omp parallel do
     do iz = 1, (p%Lz+1)/2-1
        dipo(1,:,:,p%Lz-iz) = -dipo(1,:,:,iz)
        dipo(2,:,:,p%Lz-iz) = -dipo(2,:,:,iz)
        dipo(3,:,:,p%Lz-iz) =  dipo(3,:,:,iz)
     end do
!$omp end parallel do
  end if
  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '')
  end if
end subroutine mirror
