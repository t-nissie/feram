! dipoFFT.F -*-f90-*-
! Time-stamp: <2011-06-15 19:02:16 takeshi>
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

#if defined(DETAILED_MESSAGES)
  call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', ': dipoR -> dipoK, didiR, didiK')
#endif
  call fft_r2c(p, c%dipoR, c%dipoK, 3)

  c%didiR(:,:,:,1) = c%dipoR(:,:,:,1) * c%dipoR(:,:,:,1)
  c%didiR(:,:,:,2) = c%dipoR(:,:,:,2) * c%dipoR(:,:,:,2)
  c%didiR(:,:,:,3) = c%dipoR(:,:,:,3) * c%dipoR(:,:,:,3)
  c%didiR(:,:,:,4) = c%dipoR(:,:,:,2) * c%dipoR(:,:,:,3)
  c%didiR(:,:,:,5) = c%dipoR(:,:,:,3) * c%dipoR(:,:,:,1)
  c%didiR(:,:,:,6) = c%dipoR(:,:,:,1) * c%dipoR(:,:,:,2)

  call fft_r2c(p, c%didiR, c%didiK, 6)

#if defined(DETAILED_MESSAGES)
  call msg(UNIT_LOG, __FILE__, __LINE__, 'END', &
       & ': didiR will be used in optimize-*-strain.F and dVddi-unharmonic.F.')
#endif
end subroutine dipoFFT
