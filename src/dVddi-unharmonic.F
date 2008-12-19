! dVddi-unharmonic.F   -*-f90-*-
! Time-stamp: <2008-12-19 14:30:23 takeshi>
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
  integer ix, iy, iz, alpha, alpha1, alpha2
  real*8 four_alpha_two_gamma
  real*8            two_gamma
  real*8   six_k1_two_k2
  real*8          two_k2
  real*8         four_k2_two_k3
  !--- END of variable definitions -------------------
  !call msg(6, __FILE__, __LINE__, 'BEGIN', ': Calculate unharmonic part of force and energy.')

  four_alpha_two_gamma = 4*p%P_alpha + 2*p%P_gamma
             two_gamma =               2*p%P_gamma
  six_k1_two_k2 =  6*p%P_k1 + 2*p%P_k2
         two_k2 =             2*p%P_k2
        four_k2_two_k3 =      4*p%P_k2 - 2*p%P_k3

  do alpha = 1,3
     ! 4th order
     c%dVddi(:,:,:,alpha) = c%dVddi(:,:,:,alpha) + c%dipoR(:,:,:,alpha) * &
          ( four_alpha_two_gamma * (c%didiR(:,:,:,1)+c%didiR(:,:,:,2)+c%didiR(:,:,:,3)) &
                     - two_gamma *  c%didiR(:,:,:,alpha)                                )
     ! 6th an 8th order
     if (alpha==1) then
        alpha1 = 2
        alpha2 = 3
     else if (alpha==2) then
        alpha1 = 3
        alpha2 = 1
     else ! alpha==3
        alpha1 = 1
        alpha2 = 2
     end if
     c%dVddi(:,:,:,alpha) = c%dVddi(:,:,:,alpha) + c%dipoR(:,:,:,alpha) * &
          ( six_k1_two_k2 * (c%didiR(:,:,:,1)+c%didiR(:,:,:,2)+c%didiR(:,:,:,3))**2 &
               + 8*p%P_k4 * (c%didiR(:,:,:,1)+c%didiR(:,:,:,2)+c%didiR(:,:,:,3))**3 &
                 - two_k2 *  c%didiR(:,:,:,alpha)**2 &
                - four_k2_two_k3 * c%didiR(:,:,:,alpha1) * c%didiR(:,:,:,alpha2) )
  end do

  e%unharmonic = 0.0d0
  do iz = 0, p%Lz-1
     do iy = 0, p%Ly-1
        do ix = 0, p%Lx-1
           e%unharmonic = e%unharmonic &
                + p%P_alpha * ( c%didiR(ix,iy,iz,1) + &
                                c%didiR(ix,iy,iz,2) + &
                                c%didiR(ix,iy,iz,3) )**2 &
                + p%P_gamma * ( c%didiR(ix,iy,iz,1)*c%didiR(ix,iy,iz,2) + &
                                c%didiR(ix,iy,iz,2)*c%didiR(ix,iy,iz,3) + &
                                c%didiR(ix,iy,iz,3)*c%didiR(ix,iy,iz,1) ) &
                + p%P_k1 * ( c%didiR(ix,iy,iz,1) + c%didiR(ix,iy,iz,2) + c%didiR(ix,iy,iz,3) )**3 &
                + p%P_k2 * ( c%didiR(ix,iy,iz,1)**2 * (c%didiR(ix,iy,iz,2) + c%didiR(ix,iy,iz,3)) + &
                             c%didiR(ix,iy,iz,2)**2 * (c%didiR(ix,iy,iz,3) + c%didiR(ix,iy,iz,1)) + &
                             c%didiR(ix,iy,iz,3)**2 * (c%didiR(ix,iy,iz,1) + c%didiR(ix,iy,iz,2)) ) &
                + p%P_k3 *   c%didiR(ix,iy,iz,1) * c%didiR(ix,iy,iz,2) * c%didiR(ix,iy,iz,3) &
                + p%P_k4 * ( c%didiR(ix,iy,iz,1) + c%didiR(ix,iy,iz,2) + c%didiR(ix,iy,iz,3) )**4
        end do
     end do
  end do

  !call msg(6, __FILE__, __LINE__, 'END', '')
end subroutine dVddi_unharmonic
