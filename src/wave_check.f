! wave_check.f -*-f90-*-
! Time-stamp: <2014-07-01 20:38:49 takeshi>
! Author: Takeshi NISHIMATSU
!!
program wave_check
  use wave_module
  implicit none
  integer, parameter :: period       = 24
  integer, parameter :: n_thermalize = 16
  real*8,  parameter :: amplitude(3) = (/10.0d0,-10.0d0,8.0d0/)
  real*8             :: x(3)
  integer            :: i
  x = wave('triangular_sin',          0+n_thermalize, n_thermalize, period, amplitude); if (x(1).ne. 0.0d0)          stop  1
  x = wave('triangular_cos',          0+n_thermalize, n_thermalize, period, amplitude); if (x(1).ne. amplitude(1))   stop  2
  x = wave('triangular_sin',   period/2+n_thermalize, n_thermalize, period, amplitude); if (x(1).ne. 0.0d0)          stop  3
  x = wave('triangular_cos',   period/2+n_thermalize, n_thermalize, period, amplitude); if (x(1).ne.-amplitude(1))   stop  4
  x = wave('triangular_sin',   period/4+n_thermalize, n_thermalize, period, amplitude); if (x(1).ne. amplitude(1))   stop  5
  x = wave('triangular_cos',   period/4+n_thermalize, n_thermalize, period, amplitude); if (x(1).ne. 0.0d0)          stop  6

  if (mod(period,8).ne.0)                                                                                            stop  7
  x = wave('triangular_sin',   period/8+n_thermalize, n_thermalize, period, amplitude); if (x(1).ne. amplitude(1)/2) stop  8
  x = wave('triangular_cos',   period/8+n_thermalize, n_thermalize, period, amplitude); if (x(1).ne. amplitude(1)/2) stop  9
  x = wave('triangular_sin', 7*period/8+n_thermalize, n_thermalize, period, amplitude); if (x(1).ne.-amplitude(1)/2) stop 10
  x = wave('triangular_cos', 7*period/8+n_thermalize, n_thermalize, period, amplitude); if (x(1).ne. amplitude(1)/2) stop 11

  x = wave('ramping_on',                           0, n_thermalize, period, amplitude); if (x(1).ne. 0.0d0)          stop 12
  x = wave('ramping_off',                          0, n_thermalize, period, amplitude); if (x(1).ne. amplitude(1))   stop 13
  x = wave('ramping_on',              n_thermalize/2, n_thermalize, period, amplitude); if (x(2).ne. amplitude(2)/2) stop 14
  x = wave('ramping_off',             n_thermalize/2, n_thermalize, period, amplitude); if (x(2).ne. amplitude(2)/2) stop 15
  x = wave('ramping_on',                n_thermalize, n_thermalize, period, amplitude); if (x(3).ne. amplitude(3))   stop 16
  x = wave('ramping_off',               n_thermalize, n_thermalize, period, amplitude); if (x(3).ne. 0.0d0)          stop 17
  x = wave('ramping_on',              n_thermalize+1, n_thermalize, period, amplitude); if (x(1).ne. amplitude(1))   stop 18
  x = wave('ramping_off',             n_thermalize+1, n_thermalize, period, amplitude); if (x(1).ne. 0.0d0)          stop 19

  open(unit=8, file='wave_check.dat', status='REPLACE')
  do i = 0, n_thermalize+period
     write(8,'(i3,12f10.5)') i, &
          & wave('triangular_sin', i, n_thermalize, period, amplitude), &
          & wave('triangular_cos', i, n_thermalize, period, amplitude), &
          & wave('ramping_on',     i, n_thermalize, period, amplitude), &
          & wave('ramping_off',    i, n_thermalize, period, amplitude)
  end do
  close(8)
end program wave_check
