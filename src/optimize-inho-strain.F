! optimize-homo-strain.F   -*-f90-*-
! Time-stamp: <2011-10-22 14:55:14 takeshi>
! Author: Takeshi NISHIMATSU
! Caution: Before calling this subroutine, didiR should be prepared by dipoFFT.F
!!
!UINLINE cholesky_z.f
#include "define.h"
subroutine optimize_inho_strain(p,c,e)
  !$use omp_lib
  use Param_module
  use Coord_module
  use Energy_module
  implicit none
  !--- arguments -------------------------------------
  type(Param_type),  intent(in)    :: p
  type(Coord_type),  intent(inout) :: c
  type(Energy_type), intent(out)   :: e
  !--- local -----------------------------------------
  real*8 k(3), eta_B_over_2m(6), inhomo_K_tmp(3,3), G(3,3)
  complex*16                         acouK_tmp(3)
  !complex*16 acouK(3, 0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1)  ! Causes SEGV if stack is shorted.
  !real*8     inhoR(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 6)
  !complex*16 inhoK(0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1, 6)  !"/2" See fft.F!
  complex*16, allocatable :: acouK(:,:,:,:)
  real*8,     allocatable :: inhoR(:,:,:,:)
  complex*16, allocatable :: inhoK(:,:,:,:)
  integer i, alpha, ix,iy,iz
  !--- END of variable definitions -------------------
  !call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', &
  !     & 'Optimize inhomogeneous strain. Calculate related energies and accelerations.')
  allocate(acouK(3, 0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1)) !"/2" See fft.F!
  allocate(inhoR(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 6))
  allocate(inhoK(0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1, 6)) !"/2" See fft.F!

  !--- optimize inhomogeneous strain -----------------------------------
!POPTION PARALLEL,TLOCAL(inhomo_K_tmp,acouK_tmp,G)
  !$omp parallel do private(iz,iy,ix,alpha,inhomo_K_tmp,acouK_tmp,G)
  do iz = 0, p%Lz-1
     do iy = 0, p%Ly-1
        do ix = 0, p%Lx/2
           if (ix.ne.0 .or. iy.ne.0 .or. iz.ne.0) then
              inhomo_K_tmp(:,:) = c%inhomo_K(:,:,ix,iy,iz)
              do alpha = 1, 3
                 acouK_tmp(alpha) = &
                      & - SUM(c%inhomo_coup2_K(ix,iy,iz,alpha,:) * c%didiK(ix,iy,iz,:))
              end do
              call cholesky_z(3, inhomo_K_tmp, G, acouK_tmp)
              acouK(:,ix,iy,iz) = acouK_tmp(:)
           end if
        end do
     end do
  end do
  !$omp end parallel do

  acouK(1:3,0,0,0) = 0.0d0

  ! Linear equations for acouK,
  !    inhomo_K(1:3,1:3) * acouK(1:3) = - inhomo_coup2_K(1:3,1:6) * c%didiK(1:6) ,
  ! are solved for all k-points.
  ! * inhomo_K is positive definite real symmetric matrix

  !--- calculate some emergies -----------------------------------------
  call inhomogeneous_strain_energy(p,c,e,acouK)
  call inhomogeneous_coupling_energy(p,c,e,acouK)

  !--- acouK -> inhoK -FFT-> inhoR (inho. strain in real space) --------
  !$omp parallel do private(iz,iy,ix,k)
  do iz = 0, p%Lz-1
     k(3) = dble(iz)/p%Lz; if (k(3).gt.0.5d0) k(3)=k(3)-1.0d0
     k(3) = k(3) * M_2PI / p%a0
     do iy = 0, p%Ly-1
        k(2) = dble(iy)/p%Ly; if (k(2).gt.0.5d0) k(2)=k(2)-1.0d0
        k(2) = k(2) * M_2PI / p%a0
        do ix = 0, p%Lx/2
           k(1) = dble(ix) / p%Lx * M_2PI / p%a0
           inhoK(ix,iy,iz,1) = k(1)*acouK(1,ix,iy,iz)
           inhoK(ix,iy,iz,2) = k(2)*acouK(2,ix,iy,iz)
           inhoK(ix,iy,iz,3) = k(3)*acouK(3,ix,iy,iz)
           inhoK(ix,iy,iz,4) = k(3)*acouK(2,ix,iy,iz) + k(2)*acouK(3,ix,iy,iz)
           inhoK(ix,iy,iz,5) = k(1)*acouK(3,ix,iy,iz) + k(3)*acouK(1,ix,iy,iz)
           inhoK(ix,iy,iz,6) = k(2)*acouK(1,ix,iy,iz) + k(1)*acouK(2,ix,iy,iz)
        end do
     end do
  end do
  !$omp end parallel do
  call fft_c2r(p, inhoK, inhoR, 6)

  !--- inhoR -> inhomogeneous coupling part of dVddi -------------------
  !$omp parallel do private(iz,iy,ix,i,eta_B_over_2m)
  do iz = 0, p%Lz-1
     do iy = 0, p%Ly-1
        do ix = 0, p%Lx-1
           do i = 1, 6
              eta_B_over_2m(i) = &
                   &   inhoR(ix,iy,iz,1) * p%Ninv * c%homogeneous_coupling_2(1,i) &
                   & + inhoR(ix,iy,iz,2) * p%Ninv * c%homogeneous_coupling_2(2,i) &
                   & + inhoR(ix,iy,iz,3) * p%Ninv * c%homogeneous_coupling_2(3,i) &
                   & + inhoR(ix,iy,iz,4) * p%Ninv * c%homogeneous_coupling_2(4,i) &
                   & + inhoR(ix,iy,iz,5) * p%Ninv * c%homogeneous_coupling_2(5,i) &
                   & + inhoR(ix,iy,iz,6) * p%Ninv * c%homogeneous_coupling_2(6,i)
           end do
           c%dVddi(ix,iy,iz,1) = &
         & c%dVddi(ix,iy,iz,1) + 2 * eta_B_over_2m(1) * c%dipoR(ix,iy,iz,1) &
         &                     +     eta_B_over_2m(5) * c%dipoR(ix,iy,iz,3) &
         &                     +     eta_B_over_2m(6) * c%dipoR(ix,iy,iz,2)
           c%dVddi(ix,iy,iz,2) = &
         & c%dVddi(ix,iy,iz,2) + 2 * eta_B_over_2m(2) * c%dipoR(ix,iy,iz,2) &
         &                     +     eta_B_over_2m(4) * c%dipoR(ix,iy,iz,3) &
         &                     +     eta_B_over_2m(6) * c%dipoR(ix,iy,iz,1)
           c%dVddi(ix,iy,iz,3) = &
         & c%dVddi(ix,iy,iz,3) + 2 * eta_B_over_2m(3) * c%dipoR(ix,iy,iz,3) &
         &                     +     eta_B_over_2m(4) * c%dipoR(ix,iy,iz,2) &
         &                     +     eta_B_over_2m(5) * c%dipoR(ix,iy,iz,1)
        end do
     end do
  end do
  !$omp end parallel do

  deallocate(acouK,inhoR,inhoK)
  !call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '')
end subroutine optimize_inho_strain
