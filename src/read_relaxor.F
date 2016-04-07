! read_relaxor.F -*-f90-*-
! Time-stamp: <2016-04-07 12:23:49 takeshi>
! Author: Takeshi NISHIMATSU
! Description: read foo.relaxor and prepare Z_starR(:,:,:).
! Parents: initialize-dipoR.F
!!
#include "define.h"
subroutine read_relaxor(p,c)
  use Param_module
  use Coord_module
  use msg_module
  implicit none
  type(Param_type), intent(inout) :: p
  type(Coord_type), intent(inout) :: c
  character (len=300) str
  character (len=1)   tmp
  integer ix, iy, iz, ios, line_number
  integer i_relaxor
  call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', '')

  open(unit=UNIT_RELAXOR, file=trim(p%filename)//'.relaxor', status='old', action='read', iostat=ios)
  if (ios.eq.0) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'FILE', trim(p%filename)//'.relaxor was found.')
     p%relaxor_flag = .true.
     line_number = 0
     do
        read(UNIT_RELAXOR, '(a)', IOSTAT=ios) str
        if (ios.ne.0) exit
        line_number = line_number + 1
        read(str,*,IOSTAT=ios) tmp
        if (ios.ne.0 .or. tmp.eq.'#') cycle
        read(str,*,IOSTAT=ios) ix, iy, iz, i_relaxor
        if (ios.eq.0) then
           c%relaxor(ix, iy, iz) = i_relaxor
           c%Z_starR(ix, iy, iz) = p%Z_star(i_relaxor)
        else
           call msg(UNIT_LOG, trim(p%filename)//'.relaxor', line_number, 'There is something wrong in this line: ', trim(str))
           call msg(UNIT_LOG, __FILE__, __LINE__, 'STOP', 'there is something wrong in the .relaxor file.')
           stop 1
        end if
     end do
     call       msg(UNIT_LOG, trim(p%filename)//'.relaxor', line_number, 'EOF', 'reached.')
     call       msg(UNIT_LOG, __FILE__, __LINE__, 'FILE', trim(p%filename)//'.relaxor was found and read successfully.')
     close(UNIT_RELAXOR)
     !write(6,'(4f7.3)') c%Z_starR(:,0,0)
  else
     call msg(UNIT_LOG, __FILE__, __LINE__, 'FILE_NOT_FOUND', '.relaxor file was NOT found.')
  end if

  !Something for 'film' or 'epit'
  !  if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
  !  end if

  call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '')
  flush(UNIT_LOG)
end subroutine read_relaxor
