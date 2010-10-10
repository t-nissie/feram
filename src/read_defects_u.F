! read_defects_u.F -*-f90-*-
! Time-stamp: <2010-10-10 17:27:36 takeshi>
! Author: Takeshi NISHIMATSU
! Description: Prepares fixed u for defects and c%m_inv(:,:,:,:).
! Parents: initialize-dipoR.F
!!
#include "define.h"
subroutine read_defects_u(p,c)
  use Param_module
  use Coord_module
  implicit none
  type(Param_type), intent(in)    :: p
  type(Coord_type), intent(inout) :: c
  character (len=300) str
  character (len=1)   tmp
  integer ix, iy, iz, ios, line_number
  real*8  u(3)
  call msg(6, __FILE__, __LINE__, 'BEGIN', '')

  c%m_inv(:,:,:,:) = 1.0d0 / p%mass_dipo
  c%defects_p(:,:,:) = .true.

  open(unit=UNIT_DEFECTS_U, file='defects.u', status='old', action='read', iostat=ios)
  if (ios.eq.0) then
     line_number = 0
     do
        read(UNIT_DEFECTS_U, '(a)', IOSTAT=ios) str
        if (ios.ne.0) exit
        line_number = line_number + 1
        read(str,*,IOSTAT=ios) tmp
        if (ios.ne.0 .or. tmp.eq.'#') cycle
        read(str,*,IOSTAT=ios) ix, iy, iz, u(:)
        if (ios.eq.0) then
           c%dipoR(ix, iy, iz, :) = u(:)
           c%m_inv(ix, iy, iz, :) = LARGE_MASS_INV
           c%defects_p(ix, iy, iz) = .false.
        else
           write(6,'("defects.u:",i5,":there is something wrong:",a)') line_number, trim(str)
           call msg(6, __FILE__, __LINE__, 'STOP', 'there is something wrong in the defects.u file.')
           stop
        end if
     end do
     close(UNIT_DEFECTS_U)
  else
     call msg(6, __FILE__, __LINE__, 'FILE: ', 'defects.u was NOT found. No defects was created.')
  end if

  if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
     c%defects_p(:,:,(p%Lz+1)/2:p%Lz-1) = .false.     ! Examples:  Lz=7 -> 4:6,  Lz=8 -> 4:7
  end if
  ! Here, we may have to count the number of free dipoles.

  call msg(6, __FILE__, __LINE__, 'END', '')
end subroutine read_defects_u
