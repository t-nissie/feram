! read_defects_u.F -*-f90-*-
! Time-stamp: <2010-10-09 22:40:42 takeshi>
! Author: Takeshi NISHIMATSU
! Description: Prepares fixed u for defects and c%m_inv(:,:,:,:).
! Parents: initialize-dipoR.F
!!
#include "define.h"
subroutine make_mass_matrix(p,c)
  use Param_module
  use Coord_module
  implicit none
  type(Param_type), intent(in)    :: p
  type(Coord_type), intent(inout) :: c

  c%m_inv(:,:,:,:) = 1.0d0 / p%mass_dipo

  open(unit=UNIT_SYSTEM, file='defects.u', status='old', action='read', iostat=ios)
  if (ios.eq.0) then
     close(UNIT_SYSTEM)
  else
     call msg(6, __FILE__, __LINE__, 'FILE: ', 'defects.u was NOT found.')
  end if



  if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
     do iz = 0, p%gap_thickness/2
        c%m_inv(:,:,iz                       ,:) = LARGE_MASS_INV
        c%m_inv(:,:,iz+p%film_thickness+p%gap_thickness,:) = LARGE_MASS_INV
     end do
     do iz = p%film_thickness+(p%gap_thickness+1)/2, p%film_thickness+p%gap_thickness-1
        c%m_inv(:,:,iz                       ,:) = LARGE_MASS_INV
        c%m_inv(:,:,iz+p%film_thickness+p%gap_thickness,:) = LARGE_MASS_INV
     end do
  end if

  !write(6,'(e15.7)') (c%m_inv(0,0,iz,1), iz=15,0,-1)
end subroutine make_mass_matrix
