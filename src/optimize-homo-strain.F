! optimize-homo-strain.F   -*-f90-*-
! Time-stamp: <2024-03-27 15:04:16 takeshi>
! Author: Takeshi NISHIMATSU
! Caution: Before calling this subroutine, didiR should be prepared by dipoFFT.F
! ref_1: R. D. King-Smith and David Vanderbilt: PRB Vol.49 p.5828 (1994)
!!
#include "define.h"
subroutine optimize_homo_strain(p,c,e)
  use Param_module
  use Coord_module
  use Energy_module
  use msg_module
  implicit none
  !--- arguments -------------------------------------
  type(Param_type),  intent(in)    :: p
  type(Coord_type),  intent(inout) :: c
  type(Energy_type), intent(out)   :: e
  !--- local -----------------------------------------
  real*8 homogeneous_coupling_2_uu(6)
  real*8 denominator, numerator, delta
  real*8 tmp
  integer i,j
  !--- END of variable definitions -------------------
  if (p%verbose>=4) call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'optimize_homo_strain().')

  !--- prepare homogeneous_coupling_2_uu ------------------------
  do i = 1, 6
     homogeneous_coupling_2_uu(i) = &
          & dot_product( c%homogeneous_coupling_2(i,:), dble(c%didiK(:,0,0,0)) )
  end do
  homogeneous_coupling_2_uu(1:3) = homogeneous_coupling_2_uu(1:3) + p%pNa03(1:3)

  !--- optimize homogeneous strain ------------------------------
  if (p%bulk_or_film.eq.'epit') then
     c%strain(1) = p%epi_strain
     c%strain(2) = p%epi_strain
     c%strain(3) = ( -(c%homogeneous(3,1)+c%homogeneous(3,2))*p%epi_strain &
          &          - homogeneous_coupling_2_uu(3) ) / c%homogeneous(3,3)
     c%strain(4) =   - homogeneous_coupling_2_uu(4)   / c%homogeneous(4,4)
     c%strain(5) =   - homogeneous_coupling_2_uu(5)   / c%homogeneous(5,5)
     c%strain(6) = 0.0d0
  else if (p%bulk_or_film.eq.'e110') then
     c%strain(3) = p%epi_strain   ! We assume that f=eta_3.
     c%strain(4) = 0.0d0
     c%strain(5) = 0.0d0
     numerator = &
          -(c%homogeneous(1,1)+c%homogeneous(2,2)+2*c%homogeneous(2,2))*p%epi_strain &
          -(c%homogeneous(3,1)+c%homogeneous(3,2)                     )*c%strain(3) &
          -   homogeneous_coupling_2_uu(1) &
          -   homogeneous_coupling_2_uu(2) &
          + 2*homogeneous_coupling_2_uu(6)
     denominator = c%homogeneous(1,1)+c%homogeneous(2,2)+2*c%homogeneous(2,1)+4*c%homogeneous(6,6)
     delta = numerator/denominator
     c%strain(1) = p%epi_strain + delta
     c%strain(2) = p%epi_strain + delta
     c%strain(6) =             -2*delta
  else
     c%strain(:) = -homogeneous_coupling_2_uu(:) !!!minus!!!
     do i = 1, 6
        tmp = 0.0d0
        do j = 1, i-1
           tmp = tmp + c%homogeneous_G(i,j)*c%strain(j)
        end do
        c%strain(i) = (c%strain(i)-tmp) * c%homogeneous_G_inv(i)
     end do
     ! [3]
     do i = 6, 1, -1
        tmp = 0.0d0
        do j = i+1, 6
           tmp = tmp + c%strain(j)*c%homogeneous_G(j,i)
        end do
        c%strain(i) = (c%strain(i)-tmp) * c%homogeneous_G_inv(i)
     end do
  end if

  !--- compute homogeneous strain energy ------------------------
  e%homo_strain = 0.0d0
  do i = 1, 6
     e%homo_strain = e%homo_strain + &
          & c%strain(i) * dot_product( c%homogeneous(i,:), c%strain(:) )
  end do
  e%homo_strain = e%homo_strain / 2

  !--- compute homogeneous coupling energy ----------------------
  e%homo_coupling = dot_product( c%strain(:), homogeneous_coupling_2_uu(:) )

  if (p%verbose>=4) call msg(UNIT_LOG, __FILE__, __LINE__, 'END', &
       & '  optimize_homo_strain(): e%homo_strain and e%homo_coupling are also calculated.')
end subroutine optimize_homo_strain
