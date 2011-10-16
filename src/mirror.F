! mirror.F -*-f90-*-
! Time-stamp: <2011-10-17 04:25:10 takeshi>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
#include "define.h"
subroutine mirror(p, dipo)
  use Param_module
  implicit none
  !--- arguments -------------------------------------
  type(Param_type),   intent(in)    :: p
  real*8 :: dipo(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 3)
  integer iz
  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', '')
  end if
  if (p%gap_id==0) then ! There is no dead layers.
     do iz = 0, p%Lz/2-1
        dipo(:,:,p%Lz-1-iz,1) = -dipo(:,:,iz,1)
        dipo(:,:,p%Lz-1-iz,2) = -dipo(:,:,iz,2)
        dipo(:,:,p%Lz-1-iz,3) =  dipo(:,:,iz,3)
     end do
  else                                        ! There are single or double dead layer(s).
     do iz = 1, (p%Lz+1)/2-1
        dipo(:,:,p%Lz-iz,1) = -dipo(:,:,iz,1)
        dipo(:,:,p%Lz-iz,2) = -dipo(:,:,iz,2)
        dipo(:,:,p%Lz-iz,3) =  dipo(:,:,iz,3)
     end do
  end if
  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '')
  end if
end subroutine mirror
