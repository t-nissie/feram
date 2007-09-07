! dVddi-unharmonic.F   -*-f90-*-
! Time-stamp: <2005-10-28 20:35:06 t-nissie>
! Author: Takeshi NISHIMATSU
!!
subroutine dVddi_unharmonic(p,c,e)
  use Param_module
  use Coord_module
  use Energy_module
  implicit none
  !--- arguments -------------------------------------
  type(Param_type), intent(in)     :: p
  type(Coord_type), intent(inout)  :: c
   type(Energy_type), intent(out)  :: e
 !--- local -----------------------------------------
  integer ix, iy, iz, alpha
  real*8 four_alpha_two_gamma
  real*8            two_gamma
  !--- END of variable definitions -------------------
  !call msg(6, __FILE__, __LINE__, 'BEGIN', ': Calculate unharmonic part of force and energy.')

  four_alpha_two_gamma = 4*p%P_alpha + 2*p%P_gamma
             two_gamma =               2*p%P_gamma
  do alpha = 1,3
     c%dVddi(:,:,:,alpha) = c%dVddi(:,:,:,alpha) + c%dipoR(:,:,:,alpha) * &
   & ( four_alpha_two_gamma * (c%didiR(:,:,:,1)+c%didiR(:,:,:,2)+c%didiR(:,:,:,3)) &
   &            - two_gamma *  c%didiR(:,:,:,alpha)                                )
  end do

  e%unharmonic = 0.0d0
  do iz = 0, p%Lz-1
     do iy = 0, p%Ly-1
        do ix = 0, p%Lx-1
           e%unharmonic = e%unharmonic &
                & + p%P_alpha * ( c%didiR(ix,iy,iz,1) + &
                &                 c%didiR(ix,iy,iz,2) + &
                &                 c%didiR(ix,iy,iz,3) )**2 &
                & + p%P_gamma * ( c%didiR(ix,iy,iz,1)*c%didiR(ix,iy,iz,2) + &
                &                 c%didiR(ix,iy,iz,2)*c%didiR(ix,iy,iz,3) + &
                &                 c%didiR(ix,iy,iz,3)*c%didiR(ix,iy,iz,1) )
        end do
     end do
  end do
  e%unharmonic = e%unharmonic

  !call msg(6, __FILE__, __LINE__, 'END', '')
end subroutine dVddi_unharmonic
