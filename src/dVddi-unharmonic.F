! dVddi-unharmonic.F   -*-f90-*-
! Time-stamp: <2015-06-15 20:56:43 t-nissie>
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
  real*8 unharm0
  !--- END of variable definitions -------------------
  !call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'Calculate unharmonic part of force and energy.')

  four_alpha_two_gamma = 4*p%P_alpha + 2*p%P_gamma
             two_gamma =               2*p%P_gamma
  six_k1_two_k2 =  6*p%P_k1 + 2*p%P_k2
         two_k2 =             2*p%P_k2
        four_k2_two_k3 =      4*p%P_k2 - 2*p%P_k3

!$omp parallel do private(ix, iy, iz, alpha, alpha1, alpha2)
  do iz = 0, p%Lz-1
     do iy = 0, p%Ly-1
        do ix = 0, p%Lx-1
           do alpha = 1,3
              ! 4th order
              c%dVddi(alpha,ix,iy,iz) = c%dVddi(alpha,ix,iy,iz) + c%dipoR(alpha,ix,iy,iz) * &
                   & ( four_alpha_two_gamma * (c%didiR(1,ix,iy,iz)+c%didiR(2,ix,iy,iz)+c%didiR(3,ix,iy,iz)) &
                   &            - two_gamma *  c%didiR(alpha,ix,iy,iz)                                  )
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
              c%dVddi(alpha,ix,iy,iz) = c%dVddi(alpha,ix,iy,iz) + c%dipoR(alpha,ix,iy,iz) * &
                   &     ( six_k1_two_k2 * (c%didiR(1,ix,iy,iz)+c%didiR(2,ix,iy,iz)+c%didiR(3,ix,iy,iz))**2 &
                   &          + 8*p%P_k4 * (c%didiR(1,ix,iy,iz)+c%didiR(2,ix,iy,iz)+c%didiR(3,ix,iy,iz))**3 &
                   &        - two_k2 *  c%didiR(alpha,ix,iy,iz)**2 &
                   & - four_k2_two_k3 * c%didiR(alpha1,ix,iy,iz) * c%didiR(alpha2,ix,iy,iz) )
           end do
        end do
     end do
  end do
!$omp end parallel do

  unharm0 = 0.0d0
!$omp parallel do private(iz, iy, ix) reduction(+:unharm0)
  do iz = 0, p%Lz-1
     do iy = 0, p%Ly-1
        do ix = 0, p%Lx-1
           unharm0 = unharm0 & 
                + p%P_alpha * ( c%didiR(1,ix,iy,iz) + &
                                c%didiR(2,ix,iy,iz) + &
                                c%didiR(3,ix,iy,iz) )**2 &
                + p%P_gamma * ( c%didiR(1,ix,iy,iz)*c%didiR(2,ix,iy,iz) + &
                                c%didiR(2,ix,iy,iz)*c%didiR(3,ix,iy,iz) + &
                                c%didiR(3,ix,iy,iz)*c%didiR(1,ix,iy,iz) ) &
                + p%P_k1 * ( c%didiR(1,ix,iy,iz) + c%didiR(2,ix,iy,iz) + c%didiR(3,ix,iy,iz) )**3 &
                + p%P_k2 * ( c%didiR(1,ix,iy,iz)**2 * (c%didiR(2,ix,iy,iz) + c%didiR(3,ix,iy,iz)) + &
                             c%didiR(2,ix,iy,iz)**2 * (c%didiR(3,ix,iy,iz) + c%didiR(1,ix,iy,iz)) + &
                             c%didiR(3,ix,iy,iz)**2 * (c%didiR(1,ix,iy,iz) + c%didiR(2,ix,iy,iz)) ) &
                + p%P_k3 *   c%didiR(1,ix,iy,iz) * c%didiR(2,ix,iy,iz) * c%didiR(3,ix,iy,iz) &
                + p%P_k4 * ( c%didiR(1,ix,iy,iz) + c%didiR(2,ix,iy,iz) + c%didiR(3,ix,iy,iz) )**4
        end do
     end do
  end do
!$omp end parallel do
  e%unharmonic = unharm0
  !call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '')
end subroutine dVddi_unharmonic
