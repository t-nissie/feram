subroutine fft1d_fwd_0002(c,increment)
  implicit none
  complex*16, intent(inout) :: c(0:*)
  integer,    intent(in)    :: increment
  complex*16  tmp
  tmp = (1.0d0,0.0d0) * c(1*increment)
  c(1*increment) = c(0*increment) - tmp
  c(0*increment) = c(0*increment) + tmp
end subroutine fft1d_fwd_0002
