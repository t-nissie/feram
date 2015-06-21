! dVdac.F   -*-f90-*-
! Time-stamp: <2015-06-21 22:04:53 takeshi>
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
  integer :: ix,iy,iz,alpha
  include 'fftw3.f03'

!=== begin: dVdacK = inhomo_K acouK + inhomo_coup2_K didiK ====================================
!$omp parallel do
  do iz = 0, p%Lz-1
     c%dVdacK(:,:,:,iz) = (0.0d0, 0.0d0)
  end do
!$omp end parallel do

!$omp parallel do
  do iz = 0, p%Lz-1
     do iy = 0, p%Ly-1
        do ix = 0, p%Lx/2
           do alpha = 1, 3
              c%dVdacK(alpha, ix,iy,iz) = c%dVdacK(alpha, ix,iy,iz) &
                & + dot_product(c%inhomo_coup2_K(alpha,1:6, ix,iy,iz), c%didiK(1:6, ix,iy,iz)) &
                & + dot_product(c%inhomo_K(      alpha,1:3, ix,iy,iz), c%acouK(1:3, ix,iy,iz))
           end do
        end do
     end do
  end do
!$omp end parallel do
!=== end:   dVdacK = inhomo_K acouK + inhomo_coup2_K didiK ====================================

!$omp parallel do
    do iz = 0,p%Lz-1
       c%dVdacK(:,:,:,iz) = (0.0d0, -1.0d0) * c%dVdacK(:,:,:,iz)
    end do
!$omp end parallel do

    !write(6,'(a,2(f14.7,f12.7))') 'dVdacK', c%dVdacK(1,0,1,1), c%dVdacK(1,0,15,15)

#  if defined(HAVE_LIBFFTW3)
    call fftw_execute_dft_c2r(c%plan_c2r_3_out, c%dVdacK, c%dVdacR)
#  else
# error "Not implemented yet."
    ! do alpha = 1, 3
    !    call fft_3d_r2c_or_c2r_out_of_place(.false., p%Lx, p%Ly, p%Lz, &
    !         & c%dVdacR(0,0,0,alpha), c%dVdacK(0,0,0,alpha))
    ! end do
#  endif

!$omp parallel do
    do iz = 0,p%Lz-1
       c%dVdacR(:,:,:,iz) = c%dVdacR(:,:,:,iz) * p%Ninv
    end do
!$omp end parallel do
end subroutine dVdac
