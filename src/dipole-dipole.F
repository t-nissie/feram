! dipole-dipole.F -*-f90-*-
! Time-stamp: <2016-04-11 14:23:46 takeshi>
! Author: Takeshi NISHIMATSU
!!
#include "define.h"
subroutine dipole_dipole(p,c)
  use Param_module
  use Coord_module
  use msg_module
  implicit none
  type(Param_type), intent(in)    :: p
  type(Coord_type), intent(inout) :: c
  real*8, allocatable :: dipoI(:,:, :,:,:)
  integer             :: iz
  call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'construction of short- and long-range interaction.')
  call  dipole_dipole_long_range(p, c%long_range)
  call dipole_dipole_short_range(p,c%short_range)

  if (p%plot_dispersion) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'DISPERSION', 'writing dispersion data.')
     allocate( dipoI(3, 3,  0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1))
     call print_eigenvalues(p%Lx, p%Ly, p%Lz, c%short_range, trim(p%filename)//'.dipole-dipole-short.dat')

!$omp parallel do
     do iz= 0, p%Lz-1
        dipoI(:,:, :,:,iz) = p%Z_star(1)**2 * c%long_range(:,:, :,:,iz)
     end do         ! We use p%Z_star(1), because dipoI is only for the dispersion plot.
!$omp end parallel do
     call print_eigenvalues(p%Lx, p%Ly, p%Lz, dipoI, trim(p%filename)//'.dipole-dipole-long.dat')

!$omp parallel do
     do iz= 0, p%Lz-1
        dipoI(:,:, :,:,iz) = dipoI(:,:, :,:,iz) + c%short_range(:,:, :,:,iz)
     end do
!$omp end parallel do
     call print_eigenvalues(p%Lx, p%Ly, p%Lz, dipoI, trim(p%filename)//'.dipole-dipole-long+short.dat')
     deallocate(dipoI)
  end if
  call msg(UNIT_LOG, __FILE__, __LINE__, 'END', 'construction of short- and long-range interaction.')
end subroutine dipole_dipole
