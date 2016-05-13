! dVdac.F   -*-f90-*-
! Time-stamp: <2016-05-13 14:26:31 takeshi>
! Author: Takeshi NISHIMATSU
! Purpose: calculate  d V / d (acoustic displacement)
! Caution: Before calling this subroutine, didiR should be prepared by dipoFFT.F
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
#include "define.h"
subroutine dVdac(p,c)
  use Param_module
  use Coord_module
  implicit none
  type(Param_type),  intent(in)    :: p
  type(Coord_type),  intent(inout) :: c
  integer :: ix,iy,iz
  include 'fftw3.f03'
  integer(C_SIZE_T) :: n_alloc_dVdac
  complex*16,pointer :: dVdacK_linear(:)
  complex*16,pointer :: dVdacK(:,:,:,:)
  real*8,    pointer :: dVdacR_linear(:)
  real*8,    pointer :: dVdacR(:,:,:,:)
  integer, parameter :: howmany = 3
  n_alloc_dVdac = howmany * (p%Lx/2+1) * (p%Ly+p%padding_y) * p%Lz
  call c_f_pointer(c%dVdac_ptr, dVdacK_linear, [n_alloc_dVdac])
  call c_f_pointer(c%dVdac_ptr, dVdacR_linear, [n_alloc_dVdac * 2])
  dVdacK(1:howmany, 0:p%Lx/2,         0:p%Ly+p%padding_y-1, 0:p%Lz-1) => dVdacK_linear
  dVdacR(1:howmany, 0:2*(p%Lx/2+1)-1, 0:p%Ly+p%padding_y-1, 0:p%Lz-1) => dVdacR_linear

!$omp parallel do
  do iz = 0, p%Lz-1
     dVdacK(:,:,:,iz) = (0.0d0, 0.0d0)
  end do
!$omp end parallel do

!$omp parallel do
  do iz = 0, p%Lz-1
     do iy = 0, p%Ly-1
        do ix = 0, p%Lx/2
           dVdacK(1:3, ix,iy,iz) = dVdacK(1:3, ix,iy,iz) &
                &   + c%c_k_modulation_k(1:3,ix,iy,iz) &
                &   + matmul(c%inhomo_coup2_K(1:3,1:6, ix,iy,iz), c%didiK(1:6, ix,iy,iz)) &
                &   + matmul(c%inhomo_K(      1:3,1:3, ix,iy,iz), c%acouK(1:3, ix,iy,iz))
        end do
     end do
  end do
!$omp end parallel do

!$omp parallel do
    do iz = 0,p%Lz-1
       dVdacK(:,:,:,iz) = (0.0d0, -1.0d0) * dVdacK(:,:,:,iz)
    end do
!$omp end parallel do

    call fftw_execute_dft_c2r(c%plan_c2r_3_in, dVdacK, dVdacR)

!$omp parallel do
    do iz = 0,p%Lz-1
       dVdacR(:,:,:,iz) = dVdacR(:,:,:,iz) * p%Ninv
    end do
!$omp end parallel do
end subroutine dVdac
