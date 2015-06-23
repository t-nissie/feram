! dVdac.F   -*-f90-*-
! Time-stamp: <2015-06-23 14:10:20 takeshi>
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

!$omp parallel do
  do iz = 0, p%Lz-1
     c%dVdacK(:,:,:,iz) = (0.0d0, 0.0d0)
  end do
!$omp end parallel do

!$omp parallel do
  do iz = 0, p%Lz-1
     do iy = 0, p%Ly-1
        do ix = 0, p%Lx/2
           c%dVdacK(1:3, ix,iy,iz) = c%dVdacK(1:3, ix,iy,iz) &
                &   + matmul(c%inhomo_coup2_K(1:3,1:6, ix,iy,iz), c%didiK(1:6, ix,iy,iz)) &
                &   + matmul(c%inhomo_K(      1:3,1:3, ix,iy,iz), c%acouK(1:3, ix,iy,iz))
        end do
     end do
  end do
!$omp end parallel do

!$omp parallel do
    do iz = 0,p%Lz-1
       c%dVdacK(:,:,:,iz) = (0.0d0, -1.0d0) * c%dVdacK(:,:,:,iz)
    end do
!$omp end parallel do

    call fftw_execute_dft_c2r(c%plan_c2r_3_out, c%dVdacK, c%dVdacR)

!$omp parallel do
    do iz = 0,p%Lz-1
       c%dVdacR(:,:,:,iz) = c%dVdacR(:,:,:,iz) * p%Ninv
    end do
!$omp end parallel do
end subroutine dVdac
