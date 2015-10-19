! initialize_E_field.F -*-f90-*-
! Time-stamp: <2015-10-19 19:31:48 takeshi>
! Author: Takeshi NISHIMATSU
!!
#include "define.h"
subroutine initialize_E_field(p,c)
  use Param_module
  use Coord_module
  use wave_module
  use msg_module
  implicit none
  type(Param_type),  intent(inout) :: p
  type(Coord_type),  intent(inout) :: c
  integer ix, iy, iz, ios, line_number
  character (len=300):: str
  character (len=1)  :: tmp
  real*8             :: tmp_E(3)
  call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', '')

  c%E_field_local(:,:,:,:) = 0.0d0

  open(unit=UNIT_SYSTEM, file=(trim(p%filename)//'.localfield'), status='old', action='read', iostat=ios)
  if (ios.eq.0) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'FILE', trim(p%filename)//'.localfield was found.')
     p%E_field_always_zero = .false.
     line_number = 0
     do
        read(UNIT_SYSTEM, '(a)', IOSTAT=ios) str
        if (ios.ne.0) exit
        line_number = line_number + 1
        read(str,*,IOSTAT=ios) tmp
        if (ios.ne.0 .or. tmp.eq.'#') cycle
        read(str,*,IOSTAT=ios) ix, iy, iz, tmp_E(:)
        if (ios.eq.0) then
           c%E_field_local(:,ix,iy,iz) = tmp_E(:)
        else
           call msg(UNIT_LOG, trim(p%filename)//'.localfield', line_number, 'There is something wrong in this line: ', trim(str))
           call msg(UNIT_LOG, __FILE__, __LINE__, 'STOP', 'there is something wrong in '//trim(p%filename)//'.localfield')
           stop 1
        end if
     end do
     call       msg(UNIT_LOG, trim(p%filename)//'.localfield', line_number, 'EOF', 'reached.')
     call       msg(UNIT_LOG, __FILE__, __LINE__, 'FILE', trim(p%filename)//'.localfield was found and read successfully.')
     close(UNIT_SYSTEM)
  else
     call msg(UNIT_LOG, __FILE__, __LINE__, 'FILE_NOT_FOUND', 'local.field was NOT found.')
     open(unit=UNIT_SYSTEM, file='ionic.configuration', status='old', action='read', iostat=ios)
     if (ios.eq.0) then
        stop ': Not implemented: Ewald sum for calculating the local field is not implemented yet.'
        ! 1. Read ionic.configuration. close(UNIT_SYSTEM).
        ! 2. Check charge neutrality.
        ! 3. Check symmetry, if it is 'film' or 'epit'.
        ! 4. Calculate the local field.
        ! 5. Write out the local field to the 'local.field' file.
     end if
  end if

  !=== Add external_E_field ========================
  tmp_E(:) = wave(p%E_wave_type,0,p%n_thermalize,p%n_E_wave_period,p%external_E_field(:))
  do iz = 0, p%Lz-1
     do iy = 0, p%Ly-1
        do ix = 0, p%Lx-1
           c%E_field(:,ix,iy,iz) = c%E_field_local(:,ix,iy,iz) + tmp_E(:)
        end do
     end do
  end do

  !=== Mirror ===================================================================
  if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
     call mirror(p, c%E_field)
  end if

  call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '')
end subroutine initialize_E_field
