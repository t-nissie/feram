! dipoFFT.F -*-f90-*-
! Time-stamp: <2012-01-12 11:47:42 t-nissie>
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
  integer alpha

  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'dipoR -> dipoK, didiR, didiK')
  end if
#if defined(HAVE_LIBFFTW3)
  do alpha = 1, 3
     call dfftw_execute(c%plans_dipoR2C(alpha))
  end do
#else
  do alpha = 1, 3
     call matrix_mpp_fft(1, p%Lx, p%Ly, p%Lz, &
            & c%dipoR(0,0,0,alpha), c%dipoK(0,0,0,alpha))
  end do
#endif

  c%didiR(:,:,:,1) = c%dipoR(:,:,:,1) * c%dipoR(:,:,:,1)
  c%didiR(:,:,:,2) = c%dipoR(:,:,:,2) * c%dipoR(:,:,:,2)
  c%didiR(:,:,:,3) = c%dipoR(:,:,:,3) * c%dipoR(:,:,:,3)
  c%didiR(:,:,:,4) = c%dipoR(:,:,:,2) * c%dipoR(:,:,:,3)
  c%didiR(:,:,:,5) = c%dipoR(:,:,:,3) * c%dipoR(:,:,:,1)
  c%didiR(:,:,:,6) = c%dipoR(:,:,:,1) * c%dipoR(:,:,:,2)

#if defined(HAVE_LIBFFTW3)
  do alpha = 1, 6
     call dfftw_execute(c%plans_didiR2C(alpha))
  end do
#else
  do alpha = 1, 6
     call matrix_mpp_fft(1, p%Lx, p%Ly, p%Lz, &
            & c%didiR(0,0,0,alpha), c%didiK(0,0,0,alpha))
  end do
#endif

  if (p%verbose>=2) then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'END', &
          & 'didiR will be used in optimize-*-strain.F and dVddi-unharmonic.F.')
  end if
end subroutine dipoFFT
