! diagonalize15x15.F -*-f90-*-
! Time-stamp: <2008-08-22 20:21:59 takeshi>
! Author: Takeshi NISHIMATSU
! Usage: tail -225 SOMEWHERE1/perovskite_o_DS5_DDB | SOMEWHERE2/diagonalize15x15
!!
program diagonalize15x15
  implicit none
  integer, parameter :: N_ATOM = 5
  integer, parameter :: N_FREEDOM = N_ATOM*3
  integer, parameter :: LWORK = N_FREEDOM*10   ! for LAPACK zheev
  integer            :: I, J, alpha, beta, io, info
  complex*16         :: SecondDTE(N_FREEDOM,N_FREEDOM) !!!REAL*8!!!, because the perovskite crystal has inversion symmetry
  real*8             :: eigenvalues(N_FREEDOM)
  real*8             :: tmp_r, tmp_i
  complex*16         :: work(LWORK)            ! for LAPACK zheev
  real*8             :: rwork(LWORK)           ! for LAPACK zheev


  do
     read(5, *, IOSTAT=io)    alpha, I, beta, J, tmp_r, tmp_i
     !write(6,'(4i4,2f10.4)') alpha, I, beta, J, tmp_r, tmp_i
     if (io.ne.0) exit
     if (I<=N_ATOM .and. J<=N_ATOM) then
        write(6,'(4i4,2i5,2f10.4)') alpha, I, beta, J, 3*(I-1)+alpha, 3*(J-1)+beta, tmp_r, tmp_i
        SecondDTE( 3*(I-1)+alpha, &
                   3*(J-1)+beta ) = cmplx(tmp_r, tmp_i)
     end if
  end do

!LAPACK zheev(JOBZ,UPLO,N,        A,        LXL,      W,          WORK,LWORK,RWORK,INFO)
  call  zheev('V', 'L', N_FREEDOM,SecondDTE,N_FREEDOM,eigenvalues,work,LWORK,rwork,info)

end program diagonalize15x15
