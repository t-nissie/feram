! dVddi_inho_coupling.F   -*-f90-*-
! Time-stamp: <2015-07-02 19:51:45 t-nissie>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
#include "define.h"
subroutine dVddi_inho_coupling(p,c)
  use Param_module
  use Coord_module
  implicit none
  type(Param_type),  intent(in)    :: p
  type(Coord_type),  intent(inout) :: c
  real*8                  :: k(3), eta_B_over_2m(6)
  integer                 :: i, ix,iy,iz
  include 'fftw3.f03'
  integer(C_SIZE_T) :: n_alloc_inho
  complex*16,pointer :: inhoK_linear(:)
  complex*16,pointer :: inhoK(:,:,:,:)
  real*8,    pointer :: inhoR_linear(:)
  real*8,    pointer :: inhoR(:,:,:,:)
  integer, parameter :: howmany = 6
  n_alloc_inho = howmany * (p%Lx/2+1) * (p%Ly+p%padding_y) * p%Lz
  call c_f_pointer(c%inho_ptr, inhoK_linear, [n_alloc_inho])
  call c_f_pointer(c%inho_ptr, inhoR_linear, [n_alloc_inho * 2])
  inhoK(1:howmany, 0:p%Lx/2,         0:p%Ly+p%padding_y-1, 0:p%Lz-1) => inhoK_linear
  inhoR(1:howmany, 0:2*(p%Lx/2+1)-1, 0:p%Ly+p%padding_y-1, 0:p%Lz-1) => inhoR_linear

  !--- acouK -> c%inhoK -FFT-> c%inhoR (inho. strain in real space) --------
!$omp parallel do private(iz,iy,ix,k)
  do iz = 0, p%Lz-1
     k(3) = dble(iz)/p%Lz; if (k(3).gt.0.5d0) k(3)=k(3)-1.0d0
     k(3) = k(3) * M_2PI / p%a0
     do iy = 0, p%Ly-1
        k(2) = dble(iy)/p%Ly; if (k(2).gt.0.5d0) k(2)=k(2)-1.0d0
        k(2) = k(2) * M_2PI / p%a0
        do ix = 0, p%Lx/2
           k(1) = dble(ix) / p%Lx * M_2PI / p%a0
           inhoK(1,ix,iy,iz) = k(1)*c%acouK(1,ix,iy,iz)
           inhoK(2,ix,iy,iz) = k(2)*c%acouK(2,ix,iy,iz)
           inhoK(3,ix,iy,iz) = k(3)*c%acouK(3,ix,iy,iz)
           inhoK(4,ix,iy,iz) = k(3)*c%acouK(2,ix,iy,iz) + k(2)*c%acouK(3,ix,iy,iz)
           inhoK(5,ix,iy,iz) = k(1)*c%acouK(3,ix,iy,iz) + k(3)*c%acouK(1,ix,iy,iz)
           inhoK(6,ix,iy,iz) = k(2)*c%acouK(1,ix,iy,iz) + k(1)*c%acouK(2,ix,iy,iz)
        end do
     end do
  end do
!$omp end parallel do

  call fftw_execute_dft_c2r(c%plan_c2r_6_in, inhoK, inhoR)

  !--- inhoR -> inhomogeneous coupling part of dVddi -------------------
!$omp parallel do private(iz,iy,ix,i,eta_B_over_2m)
  do iz = 0, p%Lz-1
     do iy = 0, p%Ly-1
        do ix = 0, p%Lx-1
           do i = 1, 6
              eta_B_over_2m(i) = &
                   &   inhoR(1,ix,iy,iz) * p%Ninv * c%homogeneous_coupling_2(1,i) &
                   & + inhoR(2,ix,iy,iz) * p%Ninv * c%homogeneous_coupling_2(2,i) &
                   & + inhoR(3,ix,iy,iz) * p%Ninv * c%homogeneous_coupling_2(3,i) &
                   & + inhoR(4,ix,iy,iz) * p%Ninv * c%homogeneous_coupling_2(4,i) &
                   & + inhoR(5,ix,iy,iz) * p%Ninv * c%homogeneous_coupling_2(5,i) &
                   & + inhoR(6,ix,iy,iz) * p%Ninv * c%homogeneous_coupling_2(6,i)
           end do
           c%dVddi(1,ix,iy,iz) = &
         & c%dVddi(1,ix,iy,iz) + 2 * eta_B_over_2m(1) * c%dipoR(1,ix,iy,iz) &
         &                     +     eta_B_over_2m(5) * c%dipoR(3,ix,iy,iz) &
         &                     +     eta_B_over_2m(6) * c%dipoR(2,ix,iy,iz)
           c%dVddi(2,ix,iy,iz) = &
         & c%dVddi(2,ix,iy,iz) + 2 * eta_B_over_2m(2) * c%dipoR(2,ix,iy,iz) &
         &                     +     eta_B_over_2m(4) * c%dipoR(3,ix,iy,iz) &
         &                     +     eta_B_over_2m(6) * c%dipoR(1,ix,iy,iz)
           c%dVddi(3,ix,iy,iz) = &
         & c%dVddi(3,ix,iy,iz) + 2 * eta_B_over_2m(3) * c%dipoR(3,ix,iy,iz) &
         &                     +     eta_B_over_2m(4) * c%dipoR(2,ix,iy,iz) &
         &                     +     eta_B_over_2m(5) * c%dipoR(1,ix,iy,iz)
        end do
     end do
  end do
!$omp end parallel do

end subroutine dVddi_inho_coupling
