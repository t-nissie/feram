! print-eigenvalues.F -*-f90-*-
! Time-stamp: <2012-07-05 14:57:08 t-nissie>
! Author: Takeshi NISHIMATSU
!!
#include "define.h"
subroutine print_eigenvalues(Lx, Ly, Lz, phi, filename)
  implicit none
  !--- arguments -------------------------------------
  integer,      intent(in) :: Lx, Ly, Lz
  real*8,       intent(in) :: phi(0:Lx/2, 0:Ly-1, 0:Lz-1, 3, 3) !"/2" See fft.F!
  character(*), intent(in) :: filename
  !--- etc -------------------------------------------
  integer ix, iy, iz
  real*8  len
  !--- END of variable definitions -------------------
  call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', '')
  open(unit=UNIT_SYSTEM, file=filename)
  if (Lx.eq.Ly .and. Ly.eq.Lz) then
     ! Gamma  -Delta-  X  -Z-  M  -Sigma-  Gamma  -Lambda-  R  -S-  X  -S-  R  -T-  M
     len = 0.0d0
     iy=0; iz=0
     do ix = 0, Lx/2
        call print_eigenvalues_sub(Lx, Ly, Lz, phi, ix, iy, iz, UNIT_SYSTEM, len)
     end do
     ix=Lx/2; iz=0
     do iy = 1, Ly/2
        call print_eigenvalues_sub(Lx, Ly, Lz, phi, ix, iy, iz, UNIT_SYSTEM, len)
     end do
     iz=0
     do ix = Lx/2-1,0,-1
        call print_eigenvalues_sub(Lx, Ly, Lz, phi, ix, ix, iz, UNIT_SYSTEM, len)
     end do
     do ix = 1,Lx/2
        call print_eigenvalues_sub(Lx, Ly, Lz, phi, ix, ix, ix, UNIT_SYSTEM, len)
     end do
     ix=Lx/2
     do iy = Ly/2-1,0,-1
        call print_eigenvalues_sub(Lx, Ly, Lz, phi, ix, iy, iy, UNIT_SYSTEM, len)
     end do
     ix=Lx/2
     do iy = 1,Ly/2
        call print_eigenvalues_sub(Lx, Ly, Lz, phi, ix, iy, iy, UNIT_SYSTEM, len)
     end do
     ix=Lx/2
     do iz = Lz/2-1,0,-1
        call print_eigenvalues_sub(Lx, Ly, Lz, phi, ix, ix, iz, UNIT_SYSTEM, len)
     end do
  else
     len = 0.0d0
     iy=0; iz=0
     do ix = 0, Lx/2
        call print_eigenvalues_sub(Lx, Ly, Lz, phi, ix, iy, iz, UNIT_SYSTEM, len)
     end do
     len = 0.0d0
     ix=0; iz=0
     do iy = 0, Ly/2
        call print_eigenvalues_sub(Lx, Ly, Lz, phi, ix, iy, iz, UNIT_SYSTEM, len)
     end do
     len = 0.0d0
     ix=0; iy=0
     do iz = 0, Lz/2
        call print_eigenvalues_sub(Lx, Ly, Lz, phi, ix, iy, iz, UNIT_SYSTEM, len)
     end do
     len = 0.0d0
     ix=0; iy=0; iz=0
     call print_eigenvalues_sub(Lx, Ly, Lz, phi, ix, iy, iz, UNIT_SYSTEM, len)
     ix=Lx/4; iy=Ly/4; iz=Lz/4
     call print_eigenvalues_sub(Lx, Ly, Lz, phi, ix, iy, iz, UNIT_SYSTEM, len)
     ix=Lx/2; iy=Ly/2; iz=Lz/2
     call print_eigenvalues_sub(Lx, Ly, Lz, phi, ix, iy, iz, UNIT_SYSTEM, len)
  end if
  close(UNIT_SYSTEM)
  call msg(UNIT_LOG, __FILE__, __LINE__, 'FILENAME', filename)
  call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '')
end subroutine print_eigenvalues

subroutine print_eigenvalues_sub(Lx, Ly, Lz, phi, ix, iy, iz, unit, len)
  implicit none
  !--- arguments -------------------------------------
  integer, intent(in)    :: Lx, Ly, Lz
  real*8,  intent(in)    :: phi(0:Lx/2, 0:Ly-1, 0:Lz-1, 3, 3) !"/2" See fft.F!
  integer, intent(in)    :: ix, iy, iz, unit
  real*8,  intent(inout) :: len
  !--- etc -------------------------------------------
  integer  alpha, beta
  integer, save :: last_ix
  integer, save :: last_iy
  integer, save :: last_iz
  !--- LAPACK ----------------------------------------
  integer, parameter :: lwork=200
  real*8   tmp(3,3),eigenvalues(3)
  integer  work(lwork)
  integer  info
  !--- END of variable definitions -------------------
  if (len.eq.0.0d0) then
     last_ix=0; last_iy=0; last_iz=0
  end if
  len = len + sqrt(dble((ix-last_ix)**2+(iy-last_iy)**2+(iz-last_iz)**2))/Lx
  last_ix = ix
  last_iy = iy
  last_iz = iz
  tmp(:,:) = phi(ix,iy,iz,:,:)
#if defined(__xlc__)
  stop 'ESSL does not have dsyev().'
#else
  call DSYEV('N', 'U', 3, tmp, 3, eigenvalues, work, lwork, info)   ! tmp is destroyed.
#endif
  write(unit,'(f10.5,3i4,3e25.16E3)') len,ix,iy,iz,(eigenvalues(beta), beta=1,3)
  tmp(:,:) = dble(phi(ix,iy,iz,:,:))
  write(unit,'(2("#",e15.6E3,e16.6E3,e16.6E3,/),"#",e15.6E3,e16.6E3,e16.6E3)') &
 & ((tmp(alpha,beta),              beta=1,3), alpha=1,3)
end subroutine print_eigenvalues_sub
