! dipoFFT.F -*-f90-*-
! Time-stamp: <2015-03-22 14:59:05 takeshi>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
#include "define.h"
subroutine dipoFFT(p,c)
  use Param_module
  use Coord_module
  implicit none
  type(Param_type),  intent(in)    :: p
  type(Coord_type),  intent(inout) :: c
  integer alpha,iz
#if defined(HAVE_LIBFFTW3)
  include 'fftw3.f03'
#endif

  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'dipoR -> dipoK, didiR, didiK')
  end if
#if defined(HAVE_LIBFFTW3)
  call fftw_execute_dft_r2c(c%plan_dipoR2C, c%dipoR, c%dipoK)
#else
# error "Not implemented yet."
!  do alpha = 1, 3
!     call fft_3d_r2c_or_c2r_out_of_place(.true., p%Lx, p%Ly, p%Lz, &
!            & c%dipoR(0,0,0,alpha), c%dipoK(0,0,0,alpha))
!  end do
#endif

!$omp parallel do
  do iz=0, p%Lz-1
     c%didiR(:,:,iz,1) = c%dipoR(1,:,:,iz) * c%dipoR(1,:,:,iz)
     c%didiR(:,:,iz,2) = c%dipoR(2,:,:,iz) * c%dipoR(2,:,:,iz)
     c%didiR(:,:,iz,3) = c%dipoR(3,:,:,iz) * c%dipoR(3,:,:,iz)
     c%didiR(:,:,iz,4) = c%dipoR(2,:,:,iz) * c%dipoR(3,:,:,iz)
     c%didiR(:,:,iz,5) = c%dipoR(3,:,:,iz) * c%dipoR(1,:,:,iz)
     c%didiR(:,:,iz,6) = c%dipoR(1,:,:,iz) * c%dipoR(2,:,:,iz)
  end do
!$omp end parallel do

#if defined(HAVE_LIBFFTW3)
  do alpha = 1, 6
     call dfftw_execute(c%plans_didiR2C(alpha))
  end do
#else
  do alpha = 1, 6
     call fft_3d_r2c_or_c2r_out_of_place(.true., p%Lx, p%Ly, p%Lz, &
            & c%didiR(0,0,0,alpha), c%didiK(0,0,0,alpha))
  end do
#endif

  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'END', &
          & 'didiR will be used in optimize-*-strain.F and dVddi-unharmonic.F.')
  end if
end subroutine dipoFFT
