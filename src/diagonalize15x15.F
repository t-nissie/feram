! diagonalize15x15.F -*-f90-*-
! Time-stamp: <2009-02-27 17:11:16 t-nissie>
! Author: Takeshi NISHIMATSU
! Usage: tail -225 SOMEWHERE1/perovskite_o_DS5_DDB | SOMEWHERE2/diagonalize15x15
!!
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
  character(len=50) :: fmt_eigen
  logical   all_real

  all_real = .true.
  do
     read(5, *, IOSTAT=io)    alpha, I, beta, J, tmp_r, tmp_i
     !write(6,'(4i4,2f10.4)') alpha, I, beta, J, tmp_r, tmp_i
     if (io.ne.0) exit
     if (I<=N_ATOM .and. J<=N_ATOM) then
        !write(6,'(4i4,2i5,2f15.9)') alpha, I, beta, J, 3*(I-1)+alpha, 3*(J-1)+beta , tmp_r, tmp_i
        Force_Matrix_real_symmetric(3*(I-1)+alpha, 3*(J-1)+beta) = tmp_r
        Force_Matrix_Hermetian(     3*(I-1)+alpha, 3*(J-1)+beta) = cmplx(tmp_r,tmp_i)
        if ( abs(tmp_i) > 1.0d-4 ) all_real = .false.
     end if
  end do

  if (all_real) then
     !LAPACK dsyev(JOBZ, UPLO, N,         A,                        LDA,       W,           WORK,  LWORK, INFO)
     call    dsyev('V',  'L',  N_FREEDOM, Force_Matrix_real_symmetric, N_FREEDOM, eigenvalues, rwork, LWORK, info)
     write(fmt_eigen,'(a,i3,a)') '(i2,f11.6,', N_ATOM, '(f10.3,f7.3,f7.3))'
     do j=1,N_FREEDOM
        write(6,fmt_eigen) j, eigenvalues(j), (Force_Matrix_real_symmetric(i,j), i=1,N_FREEDOM)
     end do
     !write(6,'(a)') 'eigenvalues [eV/Angstrom^2] and eigenvectors of the force constant matrix at the Gamma point for BaTiO3 (a0=3.93889 [Angstrom])'
     !do j=1,N_FREEDOM
     !   write(6,fmt_eigen) j, eigenvalues(j)*27.21138386/3.93889**2, (Force_Matrix_real_symmetric(i,j), i=1,N_FREEDOM)
     !end do
  else
     !LAPACK zheev(JOBZ,UPLO,N,        A,                  LXL,      W,          WORK,LWORK,RWORK,INFO)
     call    zheev('V', 'L', N_FREEDOM,Force_Matrix_Hermetian,N_FREEDOM,eigenvalues,work,LWORK,rwork,info)
     write(fmt_eigen,'(a,i3,a)') "(i2,f11.6,", N_ATOM, "((f8.2,f5.2)(f6.2,f5.2)(f6.2,f5.2)))"
     do j=1,N_FREEDOM
        write(6,fmt_eigen) j, eigenvalues(j), (Force_Matrix_Hermetian(i,j), i=1,N_FREEDOM)
     end do
  end if
end program diagonalize15x15

!local variables:
!  compile-command: "make -k diagonalize15x15 && tail -324 10example-PbTiO3-DDB2short/perovskite-Gamma_o_DS3_DDB | ./diagonalize15x15"
!End:
