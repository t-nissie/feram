! dVddi-homo-coupling.F   -*-f90-*-
! Time-stamp: <2005-10-28 20:34:59 t-nissie>
! Author: Takeshi NISHIMATSU
!!
subroutine dVddi_homo_coupling(p,c) ! We use p implicitly. Don't worry about compile warning on it.
  use Param_module
  use Coord_module
  implicit none
  !--- arguments -------------------------------------
  type(Param_type), intent(in)     :: p
  type(Coord_type), intent(inout)  :: c
 !--- local -----------------------------------------
  integer i,j
  real*8  eta_B_over_2m(6)
  !--- END of variable definitions -------------------
  !call msg(6, __FILE__, __LINE__, 'BEGIN', ': Calculate force on dipoR from (in)harmonic strains.')

  eta_B_over_2m(:) = 0.0d0
  do j = 1, 6
     do i = 1, 6
        eta_B_over_2m(j) = &
      & eta_B_over_2m(j) + c%strain(i) * c%homogeneous_coupling_2(i,j)
     end do
  end do

  c%dVddi(:,:,:,1) = &
& c%dVddi(:,:,:,1) + 2 * eta_B_over_2m(1) * c%dipoR(:,:,:,1) &
&                  +     eta_B_over_2m(5) * c%dipoR(:,:,:,3) &
&                  +     eta_B_over_2m(6) * c%dipoR(:,:,:,2)

  c%dVddi(:,:,:,2) = &
& c%dVddi(:,:,:,2) + 2 * eta_B_over_2m(2) * c%dipoR(:,:,:,2) &
&                  +     eta_B_over_2m(4) * c%dipoR(:,:,:,3) &
&                  +     eta_B_over_2m(6) * c%dipoR(:,:,:,1)

  c%dVddi(:,:,:,3) = &
& c%dVddi(:,:,:,3) + 2 * eta_B_over_2m(3) * c%dipoR(:,:,:,3) &
&                  +     eta_B_over_2m(4) * c%dipoR(:,:,:,2) &
&                  +     eta_B_over_2m(5) * c%dipoR(:,:,:,1)

  !call msg(6, __FILE__, __LINE__, 'END', '')
end subroutine dVddi_homo_coupling
