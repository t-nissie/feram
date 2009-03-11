! diagonalize15x15.F -*-f90-*-
! Time-stamp: <2009-03-10 18:00:30 t-nissie>
! Author: Takeshi NISHIMATSU
! Usage: ./diagonalize15x15 < perovskite-Gamma_o_DS3_DDB
!!
#include "define.h"

program diagonalize15x15
  implicit none
  integer, parameter :: N_ATOM = 5
  integer, parameter :: N_FREEDOM = N_ATOM*3
  integer, parameter :: LWORK = N_FREEDOM*20   ! for LAPACK zheev
  integer I, J, alpha, beta, io, info
  complex*16 Force_Matrix_Hermetian(N_FREEDOM,N_FREEDOM)
  real*8     Force_Matrix_real_symmetric(N_FREEDOM,N_FREEDOM)
  ! The force matrix (or the second derivative of total energy) becomes
  ! real symmetric, if its k-point has a (very) good symmetry.
  ! The force matrix recorded in the end of each DDB file of ABINIT has a
  ! unit of Hartree/(lattice constant)^2. NOT Hartree/Bohr^2.
  complex*16 work(LWORK)                       ! for LAPACK zheev
  real*8    rwork(LWORK)                       ! for LAPACK zheev
  real*8    eigenvalues(N_FREEDOM)
  real*8    tmp_r, tmp_i
  real*8    acell(3)
  character(len=50)  :: fmt_eigen
  character(len=50) ::  c0, c1, c2, c3
  character(len=200) :: str
  logical   all_real

  do
     read(5, '(a)', IOSTAT=io) str
     read(str, *, IOSTAT=io) c0, c1, c2, c3
     if (index(c0,'acell').ne.0) then
        read(c1,*) acell(1)
        read(c2,*) acell(2)
        read(c3,*) acell(3)
        acell = acell * BOHR_RADIUS
        write(6,'(a,3f10.5,a)') 'acell = ', acell, ' [Angstrom]'
     end if
     if (index(c0,'****')    .ne.0 .and. &
         index(c1,'Database').ne.0       ) exit
  end do

  read(5, '(a)', IOSTAT=io) str
  read(5, '(a)', IOSTAT=io) str
  read(5, '(a)', IOSTAT=io) str
  read(5, '(a)', IOSTAT=io) str

  all_real = .true.
  do
     read(5, *, IOSTAT=io)    alpha, I, beta, J, tmp_r, tmp_i
     !write(6,'(4i4,2f10.4)') alpha, I, beta, J, tmp_r, tmp_i
     if (io.ne.0) exit
     if (I<=N_ATOM .and. J<=N_ATOM) then
        !write(6,'(4i4,2i5,2f15.9)') alpha, I, beta, J, 3*(I-1)+alpha, 3*(J-1)+beta , tmp_r, tmp_i
        Force_Matrix_real_symmetric(3*(I-1)+alpha, 3*(J-1)+beta) = tmp_r              * HARTREE_IN_EV / acell(alpha) / acell(beta)
        Force_Matrix_Hermetian(     3*(I-1)+alpha, 3*(J-1)+beta) = cmplx(tmp_r,tmp_i) * HARTREE_IN_EV / acell(alpha) / acell(beta)
        if ( abs(tmp_i) > 1.0d-4 ) all_real = .false.
     end if
  end do

  if (all_real) then
     !LAPACK dsyev(JOBZ, UPLO, N,         A,                           LDA,       W,           WORK,  LWORK, INFO)
     call    dsyev('V',  'L',  N_FREEDOM, Force_Matrix_real_symmetric, N_FREEDOM, eigenvalues, rwork, LWORK, info)
     write(fmt_eigen,'(a,i3,a)') '(i2,f11.6,', N_ATOM, '(f10.3,f7.3,f7.3))'
     write(6,'(a)') 'eigenvalues [eV/Angstrom^2] and eigenvectors of the matrix of interatomic force constants (IFCs)'
     do j=1,N_FREEDOM
        write(6,fmt_eigen) j, eigenvalues(j), (Force_Matrix_real_symmetric(i,j), i=1,N_FREEDOM)
     end do
  else
     !LAPACK zheev(JOBZ,UPLO,N,        A,                     LDA,      W,          WORK,LWORK,RWORK,INFO)
     call    zheev('V', 'L', N_FREEDOM,Force_Matrix_Hermetian,N_FREEDOM,eigenvalues,work,LWORK,rwork,info)
     write(fmt_eigen,'(a,i3,a)') "(i2,f11.6,", N_ATOM, "((f8.2,f5.2)(f6.2,f5.2)(f6.2,f5.2)))"
     do j=1,N_FREEDOM
        write(6,fmt_eigen) j, eigenvalues(j), (Force_Matrix_Hermetian(i,j), i=1,N_FREEDOM)
     end do
  end if
end program diagonalize15x15

!local variables:
!  compile-command: "make -k diagonalize15x15 && ./diagonalize15x15 < perovskite-Gamma_o_DS3_DDB"
!End:
