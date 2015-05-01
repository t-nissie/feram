! feram_fftw_wisdom_timing.F -*-f90-*-
! Time-stamp: <2015-05-01 12:16:12 takeshi>
! Author: Takeshi NISHIMATSU
!!
subroutine feram_fftw_wisdom_timing(howmany, N_TIMES, Lx, Ly, Lz, padding_y, in_or_out, &
     &                              count_begin, count_end, count_rate, count_max)
  implicit none
  integer, intent(in) :: howmany, N_TIMES, Lx, Ly, Lz, padding_y
  logical, intent(in) :: in_or_out
  integer, intent(in) :: count_begin, count_end, count_rate, count_max

  integer :: N
  real*8  :: t_ri        ! time
  real*8  :: g_ri        ! GFLOPS
  real*8  :: f_r         ! The numbers of floating point operations in [G]

  N = Lx * Ly * Lz
  t_ri = dble(count_end-count_begin)/count_rate
  if (t_ri<0.0d0) t_ri=t_ri+dble(count_max)/count_rate
  f_r = log(dble(N)) / log(2.0d0) / 1.0d9 * N_TIMES * 5 * N * howmany
  g_ri = f_r / t_ri

  write(6,'(i8,i3,4i5,i11,L3,  f8.3,f8.3)') N_TIMES, howmany, Lx, Ly, Lz, padding_y, N, in_or_out,  t_ri, g_ri


end subroutine feram_fftw_wisdom_timing
