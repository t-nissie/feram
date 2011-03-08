! mirror.F -*-f90-*-
! Time-stamp: <2011-03-08 16:24:47 takeshi>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
subroutine mirror(p, dipo)
  use Param_module
  implicit none
  !--- arguments -------------------------------------
  type(Param_type),   intent(in)    :: p
  real*8 :: dipo(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 3)
  integer iz
#if defined(DETAILED_MESSAGES)
  call msg(6, __FILE__, __LINE__, 'BEGIN', '')
#endif
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
#if defined(DETAILED_MESSAGES)
  call msg(6, __FILE__, __LINE__, 'END', '')
#endif
end subroutine mirror
