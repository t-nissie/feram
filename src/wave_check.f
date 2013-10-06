! wave_check.f -*-f90-*-
! Time-stamp: <2013-10-06 16:58:29 takeshi>
! Author: Takeshi NISHIMATSU
!!
program wave_check
  use wave_module
  implicit none
  integer, parameter :: period    = 24
  real*8,  parameter :: amplitude(3) = (/10.0d0,-10.0d0,8.0d0/)
  real*8             :: x(3)
  integer            :: i
  x = wave('triangular_sin',          0, period, amplitude); if (x(1).ne. 0.0d0)          stop  1
  x = wave('triangular_cos',          0, period, amplitude); if (x(1).ne. amplitude(1))   stop  2
  x = wave('triangular_sin',   period/2, period, amplitude); if (x(1).ne. 0.0d0)          stop  3
  x = wave('triangular_cos',   period/2, period, amplitude); if (x(1).ne.-amplitude(1))   stop  4
  x = wave('triangular_sin',   period/4, period, amplitude); if (x(1).ne. amplitude(1))   stop  5
  x = wave('triangular_cos',   period/4, period, amplitude); if (x(1).ne. 0.0d0)          stop  6

  if (mod(period,8).ne.0)                                                                 stop  7
  x = wave('triangular_sin',   period/8, period, amplitude); if (x(1).ne. amplitude(1)/2) stop  8
  x = wave('triangular_cos',   period/8, period, amplitude); if (x(1).ne. amplitude(1)/2) stop  9
  x = wave('triangular_sin', 7*period/8, period, amplitude); if (x(1).ne.-amplitude(1)/2) stop 10
  x = wave('triangular_cos', 7*period/8, period, amplitude); if (x(1).ne. amplitude(1)/2) stop 11

  open(unit=8, file='wave_check.dat', status='REPLACE')
  do i = 0, period
     write(8,'(i3,6f10.5)') i, &
          & wave('triangular_sin',i, period, amplitude), &
          & wave('triangular_cos',i, period, amplitude)
  end do
  close(8)
end program wave_check
