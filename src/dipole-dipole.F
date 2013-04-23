! dipole-dipole.F -*-f90-*-
! Time-stamp: <2013-04-23 20:21:23 takeshi>
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
  integer             :: ios,ix,iy,iz
  !--- END of variable definitions -------------------
  call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'construction of dipole-dipole interaction.')

  allocate( long_range(0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1, 3, 3)) !"/2" See fft.F!
            long_range(:,:,:,:,:) = 0.0d0
  allocate(short_range(0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1, 3, 3)) !"/2" See fft.F!
           short_range(:,:,:,:,:) = 0.0d0

  open(unit=UNIT_QUADRATIC, file=trim(p%filename)//'.quadratic', status='old', action='read', iostat=ios)
  call msg(UNIT_LOG, __FILE__, __LINE__, 'FILE', trim(p%filename)//'.quadratic'//' was found.')
  if (ios.eq.0) then
     do iz= 0, p%Lz-1
        do iy= 0, p%Ly-1
           do ix= 0, p%Lx/2
              read(UNIT_QUADRATIC,*)
              read(UNIT_QUADRATIC,*) long_range(ix,iy,iz,1,:)
              read(UNIT_QUADRATIC,*) long_range(ix,iy,iz,2,:)
              read(UNIT_QUADRATIC,*) long_range(ix,iy,iz,3,:)
           end do
        end do
     end do
     !write(6,'(3f10.5)') (long_range(0,8,8,alpha,:), alpha=1,3)
     close(UNIT_QUADRATIC)
  else
     call  dipole_dipole_long_range(p, long_range)
  end if

  call dipole_dipole_short_range(p,short_range)
  c%dipoI(:,:,:,:,:) = long_range(:,:,:,:,:) + short_range(:,:,:,:,:)

  ! open(unit=UNIT_QUADRATIC, file=trim(p%filename)//'.dipoI', status='replace')
  !    do iz= 0, p%Lz-1
  !       do iy= 0, p%Ly-1
  !          do ix= 0, p%Lx/2
  !             write(UNIT_QUADRATIC,'(3i3)'   ) ix,iy,iz
  !             write(UNIT_QUADRATIC,'(3f12.5)') c%dipoI(ix,iy,iz,1,:)
  !             write(UNIT_QUADRATIC,'(3f12.5)') c%dipoI(ix,iy,iz,2,:)
  !             write(UNIT_QUADRATIC,'(3f12.5)') c%dipoI(ix,iy,iz,3,:)
  !          end do
  !       end do
  !    end do
  ! close(UNIT_QUADRATIC)

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
