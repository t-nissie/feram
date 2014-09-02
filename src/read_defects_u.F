! read_defects_u.F -*-f90-*-
! Time-stamp: <2014-09-02 23:10:03 takeshi>
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
  call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', '')

  c%m_inv(:,:,:,:) = 1.0d0 / p%mass_dipo
  c%sum_p(:,:,:) = .true.

  open(unit=UNIT_DEFECTS_U, file=trim(p%filename)//'.defects', status='old', action='read', iostat=ios)
  if (ios.eq.0) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'FILE', trim(p%filename)//'.defects was found.')
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
           c%m_inv(ix, iy, iz, :) = 0.0d0   ! 1/infinity
           c%sum_p(ix, iy, iz) = .false.
        else
           call msg(UNIT_LOG, trim(p%filename)//'.defects', line_number, 'There is something wrong in this line: ', trim(str))
           call msg(UNIT_LOG, __FILE__, __LINE__, 'STOP', 'there is something wrong in the .defects file.')
           stop 1
        end if
     end do
     call       msg(UNIT_LOG, trim(p%filename)//'.defects', line_number, 'EOF', 'reached.')
     call       msg(UNIT_LOG, __FILE__, __LINE__, 'FILE', trim(p%filename)//'.defects was found and read successfully.')
     close(UNIT_DEFECTS_U)
  else
     call msg(UNIT_LOG, __FILE__, __LINE__, 'FILE_NOT_FOUND', '.defects file was NOT found. No defects was created.')
  end if

  if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
     c%sum_p(:,:,(p%Lz+1)/2:p%Lz-1) = .false.     ! Examples:  Lz=7 -> 4:6,  Lz=8 -> 4:7
  end if

  if (p%gap_id>0) then
     c%dipoR(:, :, 0, 1) = p%gap_dipole_u(1)
     c%dipoR(:, :, 0, 2) = p%gap_dipole_u(2)
     c%dipoR(:, :, 0, 3) = p%gap_dipole_u(3)
     c%m_inv(:, :, 0, :) = 0.0d0   ! 1/infinity
     c%sum_p(:, :, 0)    = .false.
     if (p%gap_id.eq.2) then
        c%dipoR(:, :, p%Lz/2, 1) = p%gap_dipole_u(1)
        c%dipoR(:, :, p%Lz/2, 2) = p%gap_dipole_u(2)
        c%dipoR(:, :, p%Lz/2, 3) = p%gap_dipole_u(3)
        c%m_inv(:, :, p%Lz/2, :) = 0.0d0   ! 1/infinity
        c%sum_p(:, :, p%Lz/2)    = .false.
     end if
  end if

  c%n_sum_p = count(c%sum_p);  write(str,'(a,i10)') 'c%n_sum_p =', c%n_sum_p; call msg_ez(UNIT_LOG,str); call flush(UNIT_LOG)

  call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '')
end subroutine read_defects_u
