! frozen_phonon_Gamma.F -*-f90-*-
! Time-stamp: <2014-10-15 17:20:08 t-nissie>
! Author: Takeshi NISHIMATSU
! reference: R. D. King-Smith and David Vanderbilt: "First-principles investigation of
!            ferroelectricity in perovskite compounds", Phys. Rev. B, vol.49, pp.5828-5844 (1994).
!!
#include "define.h"

program frozen_phonon_Gamma
  implicit none
  integer, parameter ::       LWORK = 100   ! for LAPACK
  real*8             ::  work(LWORK)        ! for LAPACK dsyevx

  character (len=30)  dummy
  integer i, j, i_atom, alpha, info, ifail
  real*8, parameter :: RATIO_DISPLACEMENT = 0.002d0
  real*8 a1,a2,a3, tmp
  real*8 force_constant_matrix(5,5)
  real*8 eigenvectors(5,5)
  real*8 eigenvalues(5)
  real*8    vl,vu
  integer   il,iu,m,iwork(LWORK)

  open(7, FILE='perovskite-frozen-phonon-Gamma.dat', STATUS='OLD')
  read(7,*) dummy, a1,a2,a3
  a3 = a3*BOHR_RADIUS
  write(6,'(a,f11.7,a)') 'a3 = ', a3,             ' [Angstrom]'
  do i=1,5
     do j=1,21
        read(7,*) alpha, i_atom, tmp
        if (alpha==3 .and. i_atom<=5) then
           force_constant_matrix(i,i_atom) = tmp*HARTREE_IN_EV/RATIO_DISPLACEMENT/a3**2
        end if
     end do
  end do
  close(7)
  
  !do i=1,5
  !   write(6,'(5f11.7)') (force_constant_matrix(i,j),j=1,5)
  !end do

  !LAPACK dsyevx(JOBZ, RANGE, UPLO, N, A,                     LDA, 
       !                                        VL, VU, IL, IU, ABSTOL,  M, W,           Z,            LDZ,
       ! WORK,   LWORK, IWORK, IFAIL, INFO)
  call    dsyevx('V',  'A',  'L',   5, force_constant_matrix, 5, &
       &                                        vl, vu, il, iu, 0.0d0,   M, eigenvalues, eigenvectors, 5, &
       & work,   LWORK, iwork, ifail, info)

  write(6,'(a)') 'eigenvalues [eV/Angstrom^2] and eigenvectors of force_constant_matrix'
  do j=1,5
     write(6,'(i1,f11.6,5f9.4)') j, eigenvalues(j), (eigenvectors(i,j), i=1,5)
  end do


end program frozen_phonon_Gamma

!local variables:
!  compile-command: "make -k frozen_phonon_Gamma && ./frozen_phonon_Gamma'
!End:
