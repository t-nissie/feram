! dipoFFT.F -*-f90-*-
! Time-stamp: <2015-06-23 14:28:43 takeshi>
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
  integer ix,iy,iz
  include 'fftw3.f03'

  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'dipoR -> dipoK, didiR, didiK')
  end if
  call fftw_execute_dft_r2c(c%plan_r2c_3_out, c%dipoR, c%dipoK)

!$omp parallel do private(iz, iy, ix)
  do iz=0, p%Lz-1
     do iy = 0, p%Ly-1
        do ix = 0, p%Lx-1
           c%didiR(1,ix,iy,iz) = c%dipoR(1,ix,iy,iz) * c%dipoR(1,ix,iy,iz)
           c%didiR(2,ix,iy,iz) = c%dipoR(2,ix,iy,iz) * c%dipoR(2,ix,iy,iz)
           c%didiR(3,ix,iy,iz) = c%dipoR(3,ix,iy,iz) * c%dipoR(3,ix,iy,iz)
           c%didiR(4,ix,iy,iz) = c%dipoR(2,ix,iy,iz) * c%dipoR(3,ix,iy,iz)
           c%didiR(5,ix,iy,iz) = c%dipoR(3,ix,iy,iz) * c%dipoR(1,ix,iy,iz)
           c%didiR(6,ix,iy,iz) = c%dipoR(1,ix,iy,iz) * c%dipoR(2,ix,iy,iz)
        end do
     end do
  end do
!$omp end parallel do

  call fftw_execute_dft_r2c(c%plan_r2c_6_out, c%didiR, c%didiK)

  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'END', &
          & 'didiR will be used in optimize-*-strain.F and dVddi-unharmonic.F.')
  end if
end subroutine dipoFFT
