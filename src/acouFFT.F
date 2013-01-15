! acouFFT.F -*-f90-*-
! Time-stamp: <2013-01-15 09:32:55 takeshi>
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
  integer alpha,iz

  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'acouR -> acouK')
  end if

#if defined(HAVE_LIBFFTW3)
  do alpha = 1, 3
     call dfftw_execute(c%plans_acouR2C(alpha))
  end do
#else
  do alpha = 1, 3
     call fft_3d_r2c_or_c2r_out_of_place(.true., p%Lx, p%Ly, p%Lz, &
            & c%acouR(0,0,0,alpha), c%acouK(0,0,0,alpha))
  end do
#endif

    !write(6,'(a,2(f14.7,f12.7))') '1acouK', c%acouK(0,1,1,1), c%acouK(0,15,15,1)

!$omp parallel do
    do iz = 0,p%Lz-1
       c%acouK(:,:,iz,:) = (0.0d0, 1.0d0) * c%acouK(:,:,iz,:)
    end do
!$omp end parallel do

    !write(6,'(a,2(f14.7,f12.7))') '2acouK', c%acouK(0,1,1,1), c%acouK(0,15,15,1)

  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'END', 'acouR -> acouK, done')
  end if
end subroutine acouFFT
