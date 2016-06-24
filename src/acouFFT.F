! acouFFT.F -*-f90-*-
! Time-stamp: <2016-06-24 22:40:30 takeshi>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
#include "define.h"
subroutine acouFFT(p,c)
  use Param_module
  use Coord_module
  use msg_module
  implicit none
  type(Param_type),  intent(in)    :: p
  type(Coord_type),  intent(inout) :: c
  integer iz
  include 'fftw3.f03'
  if (p%verbose>=3) call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'acouFFT(): acouR -> acouK.')
  call fftw_execute_dft_r2c(c%plan_r2c_3_out, c%acouR, c%acouK)
!$omp parallel do
    do iz = 0,p%Lz-1
       c%acouK(:,:,:,iz) = (0.0d0, 1.0d0) * c%acouK(:,:,:,iz)
    end do
!$omp end parallel do
  if (p%verbose>=3) call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '  acouFFT(): acouR -> acouK, done.')
end subroutine acouFFT
