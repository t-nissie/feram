! feram_fftw_1d_in.F -*-f90-*-
! Time-stamp: <2016-04-26 17:47:02 takeshi>
! Author: Takeshi NISHIMATSU
!!
subroutine feram_fftw_1d_in(howmany, N_TIMES, n_average, flags, plan_r2c, plan_c2r)
  use, intrinsic :: iso_c_binding
  implicit none
  include 'fftw3.f03'
  integer, intent(in) :: howmany, N_TIMES, n_average, flags
  type(C_PTR), intent(out) :: plan_r2c, plan_c2r

  integer :: stride
  integer, parameter :: rank=1
  integer, parameter :: dist=1

  real*8  :: N_inv
  integer ::  LzLyLx(1)
  integer :: d_embed(1)
  integer :: z_embed(1)

  integer i,ix

  type(C_PTR)        :: inho_ptr = c_null_ptr
  integer(C_SIZE_T)  :: n_alloc_inho
  complex*16,pointer :: inhoK(:,:)
  real*8,    pointer :: inhoR(:,:)

  integer :: count_begin, count_end, count_rate, count_max

  logical :: isnan   ! IBM XL Fortran (xlf) version 14.1 requires it.

  LzLyLx( 1)=   n_average
  d_embed(1)=2*(n_average/2+1)
  z_embed(1)=   n_average/2+1
  N_inv = 1.0d0/n_average

  n_alloc_inho = howmany * (n_average/2+1)
  inho_ptr = fftw_malloc(n_alloc_inho * 16)   ! 16 for complex*16
  call c_f_pointer(inho_ptr, inhoK, [howmany,   (n_average/2+1)])
  call c_f_pointer(inho_ptr, inhoR, [howmany, 2*(n_average/2+1)])
!!!first touch!!! Here, indexes of arrays do not have to start from 0.
!$omp parallel do
    do ix = 1, n_average/2+1
       inhoK(:,ix) = (0.0d0,0.0d0)
    end do
!$omp end parallel do
    stride = howmany
    plan_r2c = fftw_plan_many_dft_r2c(rank,LzLyLx,howmany,&
         &                                   inhoR,d_embed,stride,dist,&
         &                                   inhoK,z_embed,stride,dist,flags)
    plan_c2r = fftw_plan_many_dft_c2r(rank,LzLyLx,howmany,&
         &                                   inhoK,z_embed,stride,dist,&
         &                                   inhoR,d_embed,stride,dist,flags)

!$omp parallel do
  do ix = 1, n_average
     inhoR(:,ix) = 0.1d0
  end do
!$omp end parallel do

  call system_clock(count_begin)
  do i = 1, N_TIMES
     call fftw_execute_dft_r2c(plan_r2c, inhoR, inhoK)
!$omp parallel do
     do ix = 1,n_average/2+1
        inhoK(:,ix) = inhoK(:,ix) * N_inv
     end do
!$omp end parallel do
     call fftw_execute_dft_c2r(plan_c2r, inhoK, inhoR)
  end do
  call system_clock(count_end, count_rate, count_max)

!$omp parallel do private(ix, i)
  do ix = 1, n_average
     do i = 1, howmany
        if (isnan(inhoR(i,ix)) .or. abs(inhoR(i,ix)-0.1d0)>1.0d-15) then
           write(0,'(a,a,i3,a,2(i5,a),f21.16)')   __FILE__, ':', __LINE__ ,  &
                & ': Error in accuracy at d(',i,',',ix,') =',inhoR(i,ix)
           stop 2
        end if
     end do
  end do
!$omp end parallel do

!  call feram_fftw_1d_timing(howmany, N_TIMES, n_average, '  in', &
!     &                              count_begin, count_end, count_rate, count_max)

  call fftw_free(inho_ptr)
end subroutine feram_fftw_1d_in
