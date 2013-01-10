! dVdac.F   -*-f90-*-
! Time-stamp: <2013-01-10 15:03:11 takeshi>
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
  !--- arguments -------------------------------------
  type(Param_type),  intent(in)    :: p
  type(Coord_type),  intent(inout) :: c
  !--- local -----------------------------------------
  integer                 :: ix,iy,iz,alpha
  !--- END of variable definitions -------------------
!$omp parallel do
  do iz = 0, p%Lz-1
     do iy = 0, p%Ly-1
        do ix = 0, p%Lx/2
           c%dVdacK(ix,iy,iz,:) =   matmul(      c%inhomo_K(ix,iy,iz,:,:),c%didiK(ix,iy,iz,:)) &
                &                 + matmul(c%inhomo_coup2_K(ix,iy,iz,:,:),c%didiK(ix,iy,iz,:))
        end do
     end do
  end do
!$omp end parallel do

!$omp parallel do
    do iz = 0,p%Lz-1
       c%dVdacK(:,:,iz,:) = (0.0d0, -1.0d0) * c%dVdacK(:,:,iz,:)
    end do
!$omp end parallel do

#  if defined(HAVE_LIBFFTW3)
    do alpha = 1, 3
       call dfftw_execute(c%plans_dVdacK2R(alpha))
    end do
#  else
    do alpha = 1, 3
       call fft_3d_r2c_or_c2r_out_of_place(.false., p%Lx, p%Ly, p%Lz, &
            & c%dVdacR(0,0,0,alpha), c%dVdacK(0,0,0,alpha))
    end do
#  endif

!$omp parallel do
    do iz = 0,p%Lz-1
       c%dVdacR(:,:,iz,:) = c%dVdacR(:,:,iz,:) * p%Ninv
    end do
!$omp end parallel do
end subroutine dVdac
