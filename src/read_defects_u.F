! read_defects_u.F -*-f90-*-
! Time-stamp: <2010-10-10 20:08:03 takeshi>
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
  c%sum_p(:,:,:) = .true.

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
           c%sum_p(ix, iy, iz) = .false.
        else
           call msg(6, 'defects.u', line_number, 'There is something wrong in this line: ', trim(str))
           call msg(6, __FILE__, __LINE__, 'STOP: ', 'there is something wrong in the defects.u file.')
           stop
        end if
     end do
     close(UNIT_DEFECTS_U)
  else
     call msg(6, __FILE__, __LINE__, 'FILE: ', 'defects.u was NOT found. No defects was created.')
  end if

  if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
     c%sum_p(:,:,(p%Lz+1)/2:p%Lz-1) = .false.     ! Examples:  Lz=7 -> 4:6,  Lz=8 -> 4:7
  end if

  c%n_sum_p = 0
  do iz = 0, p%Lz-1
     do iy = 0, p%Ly-1
        do ix = 0, p%Lx-1
           if (c%sum_p(ix,iy,iz)) c%n_sum_p = c%n_sum_p + 1
        end do
     end do
  end do

  call msg(6, __FILE__, __LINE__, 'END', '')
end subroutine read_defects_u
