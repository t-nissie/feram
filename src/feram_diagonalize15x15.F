! feram_diagonalize15x15.F -*-f90-*-
! Time-stamp: <2017-09-09 15:29:08 takeshi>
! Author: Takeshi NISHIMATSU
! Usage: ./feram_diagonalize15x15 < perovskite-Gamma_o_DS3_DDB
!        ./feram_diagonalize15x15 < perovskite-Sigma_o_DS1_DDB
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
#include "define.h"

#if defined(__PGI) || defined(__sparc)
#  define command_argument_count iargc
#  define get_command_argument getarg
#endif

program feram_diagonalize15x15
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
  real*8     dwork(LWORK)                       ! for LAPACK
  complex*16 zwork(LWORK)                       ! for LAPACK
  real*8     rwork(LWORK)                       ! for LAPACK zheevx
  real*8    eigenvalues(N_FREEDOM), d_eigenvectors(N_FREEDOM,N_FREEDOM)
  complex*16                        z_eigenvectors(N_FREEDOM,N_FREEDOM)
  real*8    tmp_r, tmp_i
  real*8    acell(3)
  real*8    vl,vu
  integer   il,iu,m,iwork(6*N_FREEDOM),ifail(N_FREEDOM)
  character(len=50)  :: fmt_eigen
  character(len=50) ::  c0, c1, c2, c3
  character(len=200) :: str
  logical   all_real
  integer   command_argument_count

  if (command_argument_count()>0) then
     call get_command_argument(1,str)
     if (str.eq.'--version') then
        write(6,'(a,a)') "feram_diagonalize15x15 in ", PACKAGE_STRING
        stop 0
     else
        write(6,'(a)') 'Usage: feram_diagonalize15x15 < perovskite-Gamma_o_DS3_DDB'
        write(6,'(a)') '       feram_diagonalize15x15 < perovskite-Sigma_o_DS1_DDB'
        write(6,'(a)') 'For more details, see http://loto.sourceforge.net/feram/ and'
        write(6,'(a)') '                      http://loto.sourceforge.net/feram/parameters/parameters.html .'
        stop 0
     end if
  end if

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
        Force_Matrix_real_symmetric(3*(I-1)+alpha, 3*(J-1)+beta) = tmp_r                          * HARTREE_IN_EV / acell(alpha) / acell(beta)
        Force_Matrix_Hermetian(     3*(I-1)+alpha, 3*(J-1)+beta) = cmplx(tmp_r,tmp_i,kind(0.0d0)) * HARTREE_IN_EV / acell(alpha) / acell(beta)
        if ( abs(tmp_i) > 1.0d-4 ) all_real = .false.
     end if
  end do

  if (all_real) then
     !LAPACK dsyevx(JOBZ, RANGE, UPLO, N,         A,                           LDA, 
          !                                        VL, VU, IL, IU, ABSTOL,  M, W,           Z,            LDZ,
          ! WORK,   LWORK, IWORK, IFAIL, INFO)
     call    dsyevx('V',  'A',  'L',   N_FREEDOM, Force_Matrix_real_symmetric, N_FREEDOM, &
          &                                        vl, vu, il, iu, 0.0d0, M, eigenvalues, d_eigenvectors, N_FREEDOM, &
          & dwork, LWORK, iwork, ifail, info)
     write(fmt_eigen,'(a,i3,a)') '(i2,f11.6,', N_ATOM, '(f11.4,f8.4,f8.4))'
     write(6,'(a)') 'eigenvalues [eV/Angstrom^2] and eigenvectors of the matrix of interatomic force constants (IFCs)'
     do j=1,N_FREEDOM
        write(6,fmt_eigen) j, eigenvalues(j), (d_eigenvectors(i,j), i=1,N_FREEDOM)
     end do
  else
     !LAPACK zheevx(JOBZ, RANGE, UPLO, N,         A,                      LDA, 
     !                                             VL, VU, IL, IU, ABSTOL, M,  W, Z, LDZ, 
     !       WORK, LWORK, RWORK, IWORK, IFAIL, INFO)
     call    zheevx('V',  'A',  'L',   N_FREEDOM, Force_Matrix_Hermetian, N_FREEDOM, &
          &                                        vl, vu, il, iu, 0.0d0, M, eigenvalues, z_eigenvectors, N_FREEDOM, &
          & zwork, LWORK, rwork, iwork, ifail, info)
     write(fmt_eigen,'(a,i3,a)') "(i2,f11.6,", N_ATOM, "(f8.2,f5.2, f6.2,f5.2, f6.2,f5.2))"
     do j=1,N_FREEDOM
        write(6,fmt_eigen) j, eigenvalues(j), (z_eigenvectors(i,j), i=1,N_FREEDOM)
     end do
  end if
end program feram_diagonalize15x15

!local variables:
!  compile-command: "make -k feram_diagonalize15x15 && ./feram_diagonalize15x15 < perovskite-Gamma_o_DS3_DDB"
!End:
