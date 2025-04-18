! dVddi-homo-coupling.F   -*-f90-*-
! Time-stamp: <2016-06-25 18:17:16 takeshi>
! Author: Takeshi NISHIMATSU
!!
# include "define.h"
subroutine dVddi_homo_coupling(p,c) ! We use p implicitly. Don't worry about compile warning on it.
  use Param_module
  use Coord_module
  use msg_module
  implicit none
  !--- arguments -------------------------------------
  type(Param_type), intent(in)     :: p
  type(Coord_type), intent(inout)  :: c
 !--- local -----------------------------------------
  integer i,j,ix,iy,iz
  real*8  eta_B_over_2m(6)
  !--- END of variable definitions -------------------
  if (p%verbose>=4) call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'dVddi_homo_coupling().')
  eta_B_over_2m(:) = 0.0d0
  do j = 1, 6
     do i = 1, 6
        eta_B_over_2m(j) = &
      & eta_B_over_2m(j) + c%strain(i) * c%homogeneous_coupling_2(i,j)
     end do
  end do
!$omp parallel do private(iz, iy, ix)
  do iz=0, p%Lz-1
     do iy = 0, p%Ly-1
        do ix = 0, p%Lx-1
           c%dVddi(1,ix,iy,iz) = &
         & c%dVddi(1,ix,iy,iz) + 2 * eta_B_over_2m(1) * c%dipoR(1,ix,iy,iz) &
         &                     +     eta_B_over_2m(5) * c%dipoR(3,ix,iy,iz) &
         &                     +     eta_B_over_2m(6) * c%dipoR(2,ix,iy,iz)

           c%dVddi(2,ix,iy,iz) = &
         & c%dVddi(2,ix,iy,iz) + 2 * eta_B_over_2m(2) * c%dipoR(2,ix,iy,iz) &
         &                     +     eta_B_over_2m(4) * c%dipoR(3,ix,iy,iz) &
         &                     +     eta_B_over_2m(6) * c%dipoR(1,ix,iy,iz)

           c%dVddi(3,ix,iy,iz) = &
         & c%dVddi(3,ix,iy,iz) + 2 * eta_B_over_2m(3) * c%dipoR(3,ix,iy,iz) &
         &                     +     eta_B_over_2m(4) * c%dipoR(2,ix,iy,iz) &
         &                     +     eta_B_over_2m(5) * c%dipoR(1,ix,iy,iz)
        end do
     end do
  end do
!$omp end parallel do
  if (p%verbose>=4) call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '  dVddi_homo_coupling().')
end subroutine dVddi_homo_coupling
