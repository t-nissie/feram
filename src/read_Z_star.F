! read_Z_star.F -*-f90-*-
! Time-stamp: <2015-09-30 19:49:23 takeshi>
! Author: Takeshi NISHIMATSU
! Description: read foo.Z_star and prepare ZstarR(:,:,:).
! Parents: initialize-dipoR.F
!!
#include "define.h"
subroutine read_Z_star(p,c)
  use Param_module
  use Coord_module
  implicit none
  type(Param_type), intent(in)    :: p
  type(Coord_type), intent(inout) :: c
  character (len=300) str
  character (len=1)   tmp
  integer ix, iy, iz, ios, line_number
  real*8  Z_tmp
  call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', '')

  open(unit=UNIT_Z_STAR, file=trim(p%filename)//'.Z_star', status='old', action='read', iostat=ios)
  if (ios.eq.0) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'FILE', trim(p%filename)//'.Z_star was found.')
     line_number = 0
     do
        read(UNIT_Z_STAR, '(a)', IOSTAT=ios) str
        if (ios.ne.0) exit
        line_number = line_number + 1
        read(str,*,IOSTAT=ios) tmp
        if (ios.ne.0 .or. tmp.eq.'#') cycle
        read(str,*,IOSTAT=ios) ix, iy, iz, Z_tmp
        if (ios.eq.0) then
           c%ZstarR(ix, iy, iz) = Z_tmp
        else
           call msg(UNIT_LOG, trim(p%filename)//'.Z_star', line_number, 'There is something wrong in this line: ', trim(str))
           call msg(UNIT_LOG, __FILE__, __LINE__, 'STOP', 'there is something wrong in the .Z_star file.')
           stop 1
        end if
     end do
     call       msg(UNIT_LOG, trim(p%filename)//'.Z_star', line_number, 'EOF', 'reached.')
     call       msg(UNIT_LOG, __FILE__, __LINE__, 'FILE', trim(p%filename)//'.Z_star was found and read successfully.')
     close(UNIT_Z_STAR)
  else
     call msg(UNIT_LOG, __FILE__, __LINE__, 'FILE_NOT_FOUND', '.Z_star file was NOT found.')
  end if

  !Something for 'film' or 'epit'
  !  if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
  !  end if

  call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '')
  flush(UNIT_LOG)
end subroutine read_Z_star
