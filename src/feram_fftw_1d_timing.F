! feram_fftw_1d_timing.F -*-f90-*-
! Time-stamp: <2016-04-28 14:09:52 takeshi>
! Author: Takeshi NISHIMATSU
!!
subroutine feram_fftw_1d_timing(howmany, N_TIMES, n_average, in_or_out, &
     &                              count_begin, count_end, count_rate, count_max)
  implicit none
  integer, intent(in) :: howmany, N_TIMES, n_average
  character(len=*), intent(in) :: in_or_out
  integer, intent(in) :: count_begin, count_end, count_rate, count_max

  real*8  :: t_ri        ! time
  real*8  :: g_ri        ! GFLOPS
  real*8  :: f_r         ! The numbers of floating point operations in [G]
  integer :: OMP_GET_MAX_THREADS

  t_ri = dble(count_end-count_begin)/count_rate
  if (t_ri<0.0d0) t_ri=t_ri+dble(count_max)/count_rate
  f_r = log(dble(n_average)) / log(2.0d0) / 1.0d9 * N_TIMES * 5 * n_average * howmany
  g_ri = f_r / t_ri

  write(6,'(i8,i3,i11,a,i4,f8.3,f6.1)') N_TIMES, howmany, n_average,&
       &                                    in_or_out, OMP_GET_MAX_THREADS(), t_ri, g_ri

end subroutine feram_fftw_1d_timing
