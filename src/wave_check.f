! wave_check.f -*-f90-*-
! Time-stamp: <2013-10-06 14:04:37 takeshi>
! Author: Takeshi NISHIMATSU
!!
program wave_check
  use wave_module
  implicit none
  integer, parameter :: period    = 24
  real*8,  parameter :: amplitude = 10.0d0
  integer            :: i
  if (wave('triangular_sin',          0, period, amplitude).ne. 0.0d0)       stop  1
  if (wave('triangular_cos',          0, period, amplitude).ne. amplitude)   stop  2
  if (wave('triangular_sin',   period/2, period, amplitude).ne. 0.0d0)       stop  3
  if (wave('triangular_cos',   period/2, period, amplitude).ne.-amplitude)   stop  4
  if (wave('triangular_sin',   period/4, period, amplitude).ne. amplitude)   stop  5
  if (wave('triangular_cos',   period/4, period, amplitude).ne. 0.0d0)       stop  6

  if (mod(period,8).ne.0)                                                    stop  7
  if (wave('triangular_sin',   period/8, period, amplitude).ne. amplitude/2) stop  8
  if (wave('triangular_cos',   period/8, period, amplitude).ne. amplitude/2) stop  9
  if (wave('triangular_sin', 7*period/8, period, amplitude).ne.-amplitude/2) stop 10
  if (wave('triangular_cos', 7*period/8, period, amplitude).ne. amplitude/2) stop 11

  open(unit=8, file='wave_check.dat', status='REPLACE')
  do i = 0, period
     write(8,'(i3,2f10.5)') i, &
          & wave('triangular_sin',i, period, amplitude), &
          & wave('triangular_cos',i, period, amplitude)
  end do
  close(8)
end program wave_check
