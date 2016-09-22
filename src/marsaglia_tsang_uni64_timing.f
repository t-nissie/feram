! marsaglia_tsang_uni64_timing.f -*-f90-*-
! Time-stamp: <2016-06-02 11:42:04 takeshi>
! Author: Takeshi NISHIMATSU
! Results:
!  Machine                    RNG[M/s]  N()[M/s] date       compiler
!  SR16000 (POWER7, 3.83GHz)  263.158    18.727  2014-03-03 IBM XL Fortran for AIX, V14.1
!  Xeon E5-2637 v2  3.50GHz    88.169    37.164  2014-03-03 ifort 13.1.3
!  Xeon E5-2637 v2  3.50GHz    91.853    16.617  2014-03-03 gfortran 4.4.7
!  Xeon E5-2680     2.70GHz    84.239    14.651  2014-03-03 gfortran 4.4.7
!  Xeon X5650       2.67GHz    64.470    25.254  2014-03-03 ifort 12.1.5
!  Xeon X5650       2.67GHz    71.659    12.102  2014-03-03 gfortran 4.8.2
!  Celeron 1037U    1.80GHz    45.510     7.407  2014-03-03 gfortran 4.8.1
!  Celeron ULV743   1.30GHz    32.977     4.751  2014-03-08 gfortran 4.7.2
!  Core i5 3210M    2.50GHz    71.311    25.517  2016-06-02 gfortran 6.1.0
!!
program marsaglia_tsang_uni64_timing
  use marsaglia_tsang_uni64_module
  implicit none
  integer, parameter :: N9=1000*1000*1000
  integer, parameter :: N8= 100*1000*1000
  integer :: i
  real*8  :: x
  integer :: count_start, count_goal, count_rate, count_max
  real*8  :: t
  if (uni64(123456789,987654321) .ne. 1.0d0) stop 1

  write(6,'(a)') 'marsaglia_tsang_uni64_timing.f:27: Initialization has been done. Timing starts.'

  call system_clock(count_start)
  do i=1,N9
     x=uni64()
  end do
  call system_clock(count_goal, count_rate, count_max)

  if (uni64()*9007199254740992.0d0 .ne. 6612779596961172.0d0) stop 2

  t = dble(count_goal-count_start)/count_rate
  if (t<0.0d0) t=t+dble(count_max)/count_rate
  write(6,'(a,f10.3,a)') '10^9 double-precision random numbers were generated in    ', t, ' [s].'
  write(6,'(a,f10.3,a)') 'Therefore, speed of this marsaglia_tsang_uni64 RNG is     ', dble(N9)*1.0d-6/t, ' [M/s].'

  if (normal_dist(50.0d0,10.0d0,123456798,987654312) .ne. 2.0d0) stop 3

  write(6,'(a)') 'marsaglia_tsang_uni64_timing.f:44: Second initialization has been done. Timing starts.'

  call system_clock(count_start)
  do i=1,N8
     x=normal_dist(50.0d0,10.0d0)
  end do
  call system_clock(count_goal)

  t = dble(count_goal-count_start)/count_rate
  if (t<0.0d0) t=t+dble(count_max)/count_rate
  write(6,'(a,f10.3,a)') '10^8 normally distributed random numbers were generated in', t, ' [s].'
  write(6,'(a,f10.3,a)') 'Therefore, speed of this normal_dist RNG is               ', dble(N8)*1.0d-6/t, ' [M/s].'
end program marsaglia_tsang_uni64_timing
!local variables:
!  compile-command: "make check TESTS='marsaglia_tsang_uni64_timing' && cat marsaglia_tsang_uni64_timing.log"
!End:
