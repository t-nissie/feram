! dVddi-homo-coupling.F   -*-f90-*-
! Time-stamp: <2012-04-19 17:58:09 t-nissie>
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
  integer i,j,iz
  real*8  eta_B_over_2m(6)
  !--- END of variable definitions -------------------
  !call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'Calculate force on dipoR from (in)harmonic strains.')

  eta_B_over_2m(:) = 0.0d0
  do j = 1, 6
     do i = 1, 6
        eta_B_over_2m(j) = &
      & eta_B_over_2m(j) + c%strain(i) * c%homogeneous_coupling_2(i,j)
     end do
  end do

!POPTION PARALLEL,TLOCAL(iz)
!$omp parallel do
  do iz=0, p%Lz-1
  c%dVddi(:,:,iz,1) = &
& c%dVddi(:,:,iz,1) + 2 * eta_B_over_2m(1) * c%dipoR(:,:,iz,1) &
&                   +     eta_B_over_2m(5) * c%dipoR(:,:,iz,3) &
&                   +     eta_B_over_2m(6) * c%dipoR(:,:,iz,2)

  c%dVddi(:,:,iz,2) = &
& c%dVddi(:,:,iz,2) + 2 * eta_B_over_2m(2) * c%dipoR(:,:,iz,2) &
&                   +     eta_B_over_2m(4) * c%dipoR(:,:,iz,3) &
&                   +     eta_B_over_2m(6) * c%dipoR(:,:,iz,1)

  c%dVddi(:,:,iz,3) = &
& c%dVddi(:,:,iz,3) + 2 * eta_B_over_2m(3) * c%dipoR(:,:,iz,3) &
&                   +     eta_B_over_2m(4) * c%dipoR(:,:,iz,2) &
&                   +     eta_B_over_2m(5) * c%dipoR(:,:,iz,1)
  end do
!$omp end parallel do

  !call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '')
end subroutine dVddi_homo_coupling
