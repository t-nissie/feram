! dipoFFT.F -*-f90-*-
! Time-stamp: <2012-05-31 10:30:48 takeshi>
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

  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'dipoR -> dipoK, didiR, didiK')
  end if
#if defined(HAVE_LIBFFTW3)
  do alpha = 1, 3
     call dfftw_execute(c%plans_dipoR2C(alpha))
  end do
#else
  do alpha = 1, 3
     call fft_3d_r2c_or_c2r(.true., p%Lx, p%Ly, p%Lz, &
            & c%dipoR(0,0,0,alpha), c%dipoK(0,0,0,alpha))
  end do
#endif

!POPTION PARALLEL,TLOCAL(iz)
!$omp parallel do
  do iz=0, p%Lz-1
     c%didiR(:,:,iz,1) = c%dipoR(:,:,iz,1) * c%dipoR(:,:,iz,1)
     c%didiR(:,:,iz,2) = c%dipoR(:,:,iz,2) * c%dipoR(:,:,iz,2)
     c%didiR(:,:,iz,3) = c%dipoR(:,:,iz,3) * c%dipoR(:,:,iz,3)
     c%didiR(:,:,iz,4) = c%dipoR(:,:,iz,2) * c%dipoR(:,:,iz,3)
     c%didiR(:,:,iz,5) = c%dipoR(:,:,iz,3) * c%dipoR(:,:,iz,1)
     c%didiR(:,:,iz,6) = c%dipoR(:,:,iz,1) * c%dipoR(:,:,iz,2)
  end do
!$omp end parallel do

#if defined(HAVE_LIBFFTW3)
  do alpha = 1, 6
     call dfftw_execute(c%plans_didiR2C(alpha))
  end do
#else
  do alpha = 1, 6
     call fft_3d_r2c_or_c2r(.true., p%Lx, p%Ly, p%Lz, &
            & c%didiR(0,0,0,alpha), c%didiK(0,0,0,alpha))
  end do
#endif

  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'END', &
          & 'didiR will be used in optimize-*-strain.F and dVddi-unharmonic.F.')
  end if
end subroutine dipoFFT
