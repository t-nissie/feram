! make-mass-matrix.F -*-f90-*-
! Time-stamp: <2007-06-20 16:43:43 t-nissie>
! Author: Takeshi NISHIMATSU
!!
#include "define.h"
subroutine make_mass_matrix(p,c)
  use Param_module
  use Coord_module
  implicit none
  !--- arguments -------------------------------------
  type(Param_type), intent(in)    :: p
  type(Coord_type), intent(inout) :: c
  !--- allocatable arrays ----------------------------
  integer iz
  !--- END of variable definitions -------------------

  ! In the case of FILM of film_thickness = 7, gap = 1
  !  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
  !  g  f  f  f  f  f  f  f  g  f  f  f  f  f  f  f
  ! In the case of FILM of film_thickness = 5, gap = 3
  !  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
  !  g  g  f  f  f  f  f  g  g  g  f  f  f  f  f  g
  ! In the case of FILM of film_thickness = 3, gap = 5
  !  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
  !  g  g  g  f  f  f  g  g  g  g  g  f  f  f  g  g

  c%m_inv(:,:,:,:) = 1.0d0 / p%mass_dipo
  if (p%gap.eq.0) return

  if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
     do iz = 0, p%gap/2
        c%m_inv(:,:,iz                       ,:) = LARGE_MASS_INV
        c%m_inv(:,:,iz+p%film_thickness+p%gap,:) = LARGE_MASS_INV
     end do
     do iz = p%film_thickness+(p%gap+1)/2, p%film_thickness+p%gap-1
        c%m_inv(:,:,iz                       ,:) = LARGE_MASS_INV
        c%m_inv(:,:,iz+p%film_thickness+p%gap,:) = LARGE_MASS_INV
     end do
  end if

  !write(6,'(e15.7)') (c%m_inv(0,0,iz,1), iz=15,0,-1)
end subroutine make_mass_matrix
