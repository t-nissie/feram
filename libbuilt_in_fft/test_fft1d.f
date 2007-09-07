! test_fft64.f -*-f90-*-
! Time-stamp: <2007-06-01 19:12:07 t-nissie>
! Author: Takeshi NISHIMATSU
!!
program test_fft
  implicit none
  integer n
  character (len=100) :: str
  complex*16 :: c(0:1024)
  integer i

  call get_command_argument(1,str)
  read(str,*) n

  c(:) = (1.2345d0,9.8765d0)
  do i = 1, 1000
     call fft1d(.true. ,n,c,1)
     call fft1d(.false.,n,c,1)
     c(:)=c(:)/N
  end do
  write(6,*) c(3)
end program test_fft
