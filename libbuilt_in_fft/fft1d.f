! fft1d.f -*-f90-*-
! Time-stamp: <2007-06-05 17:31:07 t-nissie>
! Author: Takeshi NISHIMATSU
!!
subroutine fft1d(mode, n, c, increment)
  implicit none
  logical,    intent(in)    :: mode
  integer,    intent(in)    :: n
  complex*16, intent(inout) :: c(0:1024)
  integer,    intent(in)    :: increment
  if (mode) then
     select case (n)
     case(  2); call fft1d_fwd_0002(c,increment)
     case(  4); call fft1d_fwd_0004(c,increment)
     case(  8); call fft1d_fwd_0008(c,increment)
     case( 16); call fft1d_fwd_0016(c,increment)
     case( 32); call fft1d_fwd_0032(c,increment)
     case( 64); call fft1d_fwd_0064(c,increment)
     case(128); call fft1d_fwd_0128(c,increment)
     case(256); call fft1d_fwd_0256(c,increment)
     case(512); call fft1d_fwd_0512(c,increment)
     case default; stop 'Illegal n.'
     end select
  else
     select case (n)
     case(  2); call fft1d_inv_0002(c,increment)
     case(  4); call fft1d_inv_0004(c,increment)
     case(  8); call fft1d_inv_0008(c,increment)
     case( 16); call fft1d_inv_0016(c,increment)
     case( 32); call fft1d_inv_0032(c,increment)
     case( 64); call fft1d_inv_0064(c,increment)
     case(128); call fft1d_inv_0128(c,increment)
     case(256); call fft1d_inv_0256(c,increment)
     case(512); call fft1d_inv_0512(c,increment)
     case default; stop 'Illegal n.'
     end select
  end if
end subroutine fft1d
