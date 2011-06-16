! optimize-homo-strain.F   -*-f90-*-
! Time-stamp: <2011-06-16 15:29:25 takeshi>
! Author: Takeshi NISHIMATSU
! Caution: Before calling this subroutine, didiR should be prepared by dipoFFT.F
! ref_1: R. D. King-Smith and David Vanderbilt: PRB Vol.49 p.5828 (1994)
!!
subroutine optimize_homo_strain(p,c,e)
  use Param_module
  use Coord_module
  use Energy_module
  implicit none
  !--- arguments -------------------------------------
  type(Param_type),  intent(in)    :: p
  type(Coord_type),  intent(inout) :: c
  type(Energy_type), intent(out)   :: e
  !--- local -----------------------------------------
  real*8 homogeneous_coupling_2_uu(6)
  real*8 lower_triangular(6,6)
  integer i
  !--- END of variable definitions -------------------
  !call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', &
  !     & 'Optimize homogeneous strain. Calculate related energies and accelerations.')

  !--- prepare homogeneous_coupling_2_uu ------------------------
  do i = 1, 6
     homogeneous_coupling_2_uu(i) = &
          & SUM( c%homogeneous_coupling_2(i,:) * dble(c%didiK(0,0,0,:)) )
  end do
  do i = 1, 3
     homogeneous_coupling_2_uu(i) = &
   & homogeneous_coupling_2_uu(i) + p%pNa03
  end do

  !--- optimize homogeneous strain ------------------------------
  if (p%bulk_or_film.eq.'epit') then
     c%strain(1) = p%epi_strain
     c%strain(2) = p%epi_strain
     c%strain(3) = ( -(c%homogeneous(3,1)+c%homogeneous(3,2))*p%epi_strain &
          &          - homogeneous_coupling_2_uu(3) ) / c%homogeneous(3,3)
     c%strain(4) =   - homogeneous_coupling_2_uu(4)   / c%homogeneous(4,4)
     c%strain(5) =   - homogeneous_coupling_2_uu(5)   / c%homogeneous(5,5)
     c%strain(6) = 0.0d0
  else
     c%strain(:) = -homogeneous_coupling_2_uu(:) !!!minus!!!
     !call DPOSV('U', 6, 1, homogeneous_tmp, 6, c%strain, 6, info)
     call cholesky_d(6, c%homogeneous(:,:), lower_triangular, c%strain)
     ! Solving a real system of linear equation
     !      B * strain = - homogeneous_coupling_2 * uu .
     ! See equation (A1) and (A2) of ref_1.
  end if

  !--- compute homogeneous strain energy ------------------------
  e%homo_strain = 0.0d0
  do i = 1, 6
     e%homo_strain = e%homo_strain + &
          & c%strain(i) * SUM( c%homogeneous(i,:) * c%strain(:) )
  end do
  e%homo_strain = e%homo_strain / 2

  !--- compute homogeneous coupling energy ----------------------
  e%homo_coupling = sum( c%strain(:) * homogeneous_coupling_2_uu(:) )


  !--- compute homogeneous strain coupling part of dVddi --------
  call dVddi_homo_coupling(p,c)

  !call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '')
end subroutine optimize_homo_strain
