! read_defects_u.F -*-f90-*-
! Time-stamp: <2016-06-24 17:15:33 takeshi>
! Author: Takeshi NISHIMATSU
! Description: Prepares fixed u for defects and c%mass_dipo_inv(:,:,:).
! Parents: initialize-dipoR.F
!!
#include "define.h"
subroutine read_defects_u(p,c)
  use Param_module
  use Coord_module
  use msg_module
  implicit none
  type(Param_type), intent(in)    :: p
  type(Coord_type), intent(inout) :: c
  character (len=300) str
  character (len=1)   tmp
  integer ix, iy, iz, ios, line_number
  real*8  u(3)
  call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'read_defects_u()')

  c%sum_p(        0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1) = .true.
  !!! They are first-touched in alloc_coord.F.

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
           c%dipoR(     :, ix, iy, iz) = u(:)
           c%mass_dipo_inv(ix, iy, iz) = 0.0d0   ! 1/infinity
           c%sum_p(        ix, iy, iz) = .false.
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
     c%dipoR(1, 0:p%Lx-1, 0:p%Ly-1, 0) = p%gap_dipole_u(1)
     c%dipoR(2, 0:p%Lx-1, 0:p%Ly-1, 0) = p%gap_dipole_u(2)
     c%dipoR(3, 0:p%Lx-1, 0:p%Ly-1, 0) = p%gap_dipole_u(3)
     c%mass_dipo_inv(0:p%Lx-1, 0:p%Ly-1, 0) = 0.0d0   ! 1/infinity
     c%sum_p(   0:p%Lx-1, 0:p%Ly-1, 0) = .false.
     if (p%gap_id.eq.2) then
        c%dipoR(1, 0:p%Lx-1, 0:p%Ly-1, p%Lz/2) = p%gap_dipole_u(1)
        c%dipoR(2, 0:p%Lx-1, 0:p%Ly-1, p%Lz/2) = p%gap_dipole_u(2)
        c%dipoR(3, 0:p%Lx-1, 0:p%Ly-1, p%Lz/2) = p%gap_dipole_u(3)
        c%mass_dipo_inv(0:p%Lx-1, 0:p%Ly-1, p%Lz/2) = 0.0d0   ! 1/infinity
        c%sum_p(   0:p%Lx-1, 0:p%Ly-1, p%Lz/2) = .false.
     end if
  end if

  c%n_sum_p = count(c%sum_p);  write(str,'(a,i10)') 'c%n_sum_p =', c%n_sum_p; call msg_ez(UNIT_LOG,str)
!$omp parallel do
  do iz = 0, p%Lz-1
     c%n_sum_layer(iz) = count(c%sum_p(:,:,iz))
  end do
!$omp end parallel do

  call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '  read_defects_u()')
  flush(UNIT_LOG)
end subroutine read_defects_u
