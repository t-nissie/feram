! dipole-dipole.F -*-f90-*-
! Time-stamp: <2011-06-16 14:59:24 takeshi>
! Author: Takeshi NISHIMATSU
!!
#include "define.h"
subroutine dipole_dipole(p,c)
  use Param_module
  use Coord_module
  implicit none
  !--- arguments -------------------------------------
  type(Param_type), intent(in)    :: p
  type(Coord_type), intent(inout) :: c
  !--- allocatable arrays ----------------------------
  real*8,     allocatable ::  long_range(:,:,:,:,:)
  real*8,     allocatable :: short_range(:,:,:,:,:)
  !--- local -----------------------------------------
  character (len=100) :: fn
  !--- END of variable definitions -------------------
  call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'construction of dipole-dipole interaction.')

  allocate( long_range(0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1, 3, 3)) !"/2" See fft.F!
  allocate(short_range(0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1, 3, 3)) !"/2" See fft.F!

  call  dipole_dipole_long_range(p, long_range)
  call dipole_dipole_short_range(p,short_range)
  c%dipoI(:,:,:,:,:) = long_range(:,:,:,:,:) + short_range(:,:,:,:,:)

  if (p%plot_dispersion) then
     write(fn,'(a,a)') trim(p%filename),'.dipole-dipole-long.dat'
     call print_eigenvalues(p%Lx, p%Ly, p%Lz,  long_range, fn)
     write(fn,'(a,a)') trim(p%filename),'.dipole-dipole-short.dat'
     call print_eigenvalues(p%Lx, p%Ly, p%Lz, short_range, fn)
     write(fn,'(a,a)') trim(p%filename),'.dipole-dipole-long+short.dat'
     call print_eigenvalues(p%Lx, p%Ly, p%Lz, c%dipoI, fn)
  end if

  deallocate( long_range)
  deallocate(short_range)
  call msg(UNIT_LOG, __FILE__, __LINE__, 'END', 'construction of dipole-dipole interaction.')
end subroutine dipole_dipole
