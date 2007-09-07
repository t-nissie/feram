! initialize_E_field.F -*-f90-*-
! Time-stamp: <2007-08-08 07:59:59 t-nissie>
! Author: Takeshi NISHIMATSU
!!
#include "define.h"
subroutine initialize_E_field(p,c)
  use Param_module
  use Coord_module
  implicit none
  type(Param_type),  intent(in)    :: p
  type(Coord_type),  intent(inout) :: c
  integer ix, iy, iz, ios, dummy_x, dummy_y, dummy_z
  !integer sign
  real*8 normal_dist
  external normal_dist
  call msg(6, __FILE__, __LINE__, 'BEGIN', '')

  open(unit=UNIT_SYSTEM, file='local.field', status='old', action='read', iostat=ios)
  if (ios.eq.0) then
     call msg(6, __FILE__, __LINE__, 'FILE: ', 'local.field was found.')
     do iz = 0, p%Lz-1
        do iy = 0, p%Ly-1
           do ix = 0, p%Lx-1
              read(UNIT_SYSTEM,*) dummy_x, dummy_y, dummy_z, &
                   c%E_field(ix,iy,iz,1),c%E_field(ix,iy,iz,2),c%E_field(ix,iy,iz,3)
           end do
        end do
     end do
     close(UNIT_SYSTEM)
  else
     call msg(6, __FILE__, __LINE__, 'FILE: ', 'local.field was NOT found.')
     open(unit=UNIT_SYSTEM, file='ionic.configuration', status='old', action='read', iostat=ios)
     if (ios.eq.0) then
        stop ': Not implemented: Ewald sum for calculating the local field is not implemented yet.'
        ! 1. Read ionic.configuration. close(UNIT_SYSTEM).
        ! 2. Check charge neutrality.
        ! 3. Check symmetry, if it is 'film' or 'epit'.
        ! 4. Calculate the local field.
        ! 5. Write out the local field to the 'local.field' file.
     else
        call msg(6, __FILE__, __LINE__, 'FILE: ', &
             'ionic.configuration was NOT found. The local fied is set to ZERO')
        c%E_field(:,:,:,:) = 0.0d0
     end if
  end if
  call msg(6, __FILE__, __LINE__, 'END', '')
end subroutine initialize_E_field
