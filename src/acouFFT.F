! acouFFT.F -*-f90-*-
! Time-stamp: <2015-03-27 16:20:38 takeshi>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
#include "define.h"
subroutine acouFFT(p,c)
  use Param_module
  use Coord_module
  implicit none
  type(Param_type),  intent(in)    :: p
  type(Coord_type),  intent(inout) :: c
#if defined(HAVE_LIBFFTW3)
  include 'fftw3.f03'
#endif

  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'acouR -> acouK')
  end if

#if defined(HAVE_LIBFFTW3)
  call fftw_execute_dft_r2c(c%plan_dipoR2C, c%acouR, c%acouK)
#else
# error "Not implemented yet."
  ! do alpha = 1, 3
  !    call fft_3d_r2c_or_c2r_out_of_place(.true., p%Lx, p%Ly, p%Lz, &
  !           & c%acouR(0,0,0,alpha), c%acouK(0,0,0,alpha))
  ! end do
#endif

!$omp parallel
  c%acouK(:,:,:,:) = (0.0d0, 1.0d0) * c%acouK(:,:,:,:)
!$omp end parallel

  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'END', 'acouR -> acouK, done')
  end if
end subroutine acouFFT
