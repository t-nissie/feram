subroutine fft1d_inv_0004(c,increment)
  implicit none
  complex*16, intent(inout) :: c(0:*)
  integer,    intent(in)    :: increment
  complex*16  tmp
  tmp = c(1*increment)
  c(1*increment) = c(2*increment)
  c(2*increment) = tmp
  tmp = (1.0d0,0.0d0) * c(1*increment)
  c(1*increment) = c(0*increment) - tmp
  c(0*increment) = c(0*increment) + tmp
  tmp = (1.0d0,0.0d0) * c(3*increment)
  c(3*increment) = c(2*increment) - tmp
  c(2*increment) = c(2*increment) + tmp
  tmp = (1.0d0,0.0d0) * c(2*increment)
  c(2*increment) = c(0*increment) - tmp
  c(0*increment) = c(0*increment) + tmp
  tmp = (0.0d0,1.0d0) * c(3*increment)
  c(3*increment) = c(1*increment) - tmp
  c(1*increment) = c(1*increment) + tmp
end subroutine fft1d_inv_0004
