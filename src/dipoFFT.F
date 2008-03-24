! dipoFFT.F -*-f90-*-
! Time-stamp: <2008-03-24 16:12:14 takeshi>
! Author: Takeshi NISHIMATSU
!!
subroutine dipoFFT(p,c)
  use Param_module
  use Coord_module
  implicit none
  type(Param_type),  intent(in)    :: p
  type(Coord_type),  intent(inout) :: c

  call msg(6, __FILE__, __LINE__, 'BEGIN', ': dipoR -> dipoK, didiR, didiK')

  call fft_r2c(p, c%dipoR, c%dipoK, 3)

  c%didiR(:,:,:,1) = c%dipoR(:,:,:,1) * c%dipoR(:,:,:,1)
  c%didiR(:,:,:,2) = c%dipoR(:,:,:,2) * c%dipoR(:,:,:,2)
  c%didiR(:,:,:,3) = c%dipoR(:,:,:,3) * c%dipoR(:,:,:,3)
  c%didiR(:,:,:,4) = c%dipoR(:,:,:,2) * c%dipoR(:,:,:,3)
  c%didiR(:,:,:,5) = c%dipoR(:,:,:,3) * c%dipoR(:,:,:,1)
  c%didiR(:,:,:,6) = c%dipoR(:,:,:,1) * c%dipoR(:,:,:,2)

  call fft_r2c(p, c%didiR, c%didiK, 6)

  call msg(6, __FILE__, __LINE__, 'END', &
       & ': didiR will be used in optimize-*-strain.F and dVddi-unharmonic.F.')
end subroutine dipoFFT
