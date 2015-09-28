! dipole-dipole.F -*-f90-*-
! Time-stamp: <2015-09-05 22:50:32 takeshi>
! Author: Takeshi NISHIMATSU
!!
#include "define.h"
subroutine dipole_dipole(p,c)
  use Param_module
  use Coord_module
  implicit none
  type(Param_type), intent(in)    :: p
  type(Coord_type), intent(inout) :: c
  real*8, allocatable :: dipoI(:,:, :,:,:)
  character (len=100) :: fn
  integer             :: ix,iy,iz
  call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'construction of dipole-dipole interaction.')

  allocate( dipoI(3, 3,  0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1)) !"/2" for real<->complex FFT
!$omp parallel do
  do iz = 0, p%Lz-1
     dipoI(:,:, :,:,iz) = 0.0d0
  end do
!$omp end parallel do

  call  dipole_dipole_long_range(p, c%long_range)
  call dipole_dipole_short_range(p,c%short_range)

!$omp parallel do
  do iz= 0, p%Lz-1
     do iy= 0, p%Ly-1
        do ix= 0, p%Lx/2
           dipoI(:,:, ix,iy,iz) = p%Z_star**2 * c%long_range(:,:, ix,iy,iz) + c%short_range(:,:, ix,iy,iz)
        end do
     end do
  end do
!$omp end parallel do

  if (p%plot_dispersion) then
     write(fn,'(a,a)') trim(p%filename),'.dipole-dipole-long.dat'
     call print_eigenvalues(p%Lx, p%Ly, p%Lz,  c%long_range, fn)
     write(fn,'(a,a)') trim(p%filename),'.dipole-dipole-short.dat'
     call print_eigenvalues(p%Lx, p%Ly, p%Lz, c%short_range, fn)
     write(fn,'(a,a)') trim(p%filename),'.dipole-dipole-long+short.dat'
     call print_eigenvalues(p%Lx, p%Ly, p%Lz, dipoI, fn)
  end if

  deallocate(dipoI)
  call msg(UNIT_LOG, __FILE__, __LINE__, 'END', 'construction of dipole-dipole interaction.')
end subroutine dipole_dipole
