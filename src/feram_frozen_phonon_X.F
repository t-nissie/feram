! feram_frozen_phonon_X.F -*-f90-*-
! Time-stamp: <2015-04-20 07:35:03 takeshi>
! Author: Takeshi NISHIMATSU
! reference: R. D. King-Smith and David Vanderbilt: "First-principles investigation of
!            ferroelectricity in perovskite compounds", Phys. Rev. B, vol.49, pp.5828-5844 (1994).
!!
#include "define.h"

program feram_frozen_phonon_X
  implicit none
  integer, parameter ::        LWORK = 300   ! for LAPACK
  real*8             ::   work(LWORK)        ! for LAPACK dsyevx

  character (len=30)  dummy
  integer i, j, i_atom, alpha, info, ifail
  real*8, parameter :: RATIO_DISPLACEMENT = 0.002d0
  real*8 acell(3), tmp, displacement
  real*8 force_constant_matrix(15,15)
  real*8 eigenvectors(15,15)
  real*8 eigenvalues(15)
  real*8    vl,vu
  integer   il,iu,m,iwork(LWORK)

  open(7, FILE='perovskite-frozen-phonon-X.dat', STATUS='OLD')
  read(7,*) dummy, acell(:)
  acell(:) = acell(:)*BOHR_RADIUS
  displacement = acell(2)*RATIO_DISPLACEMENT
  write(6,'(a,3f11.7,a)') 'acell = ', acell(:),             ' [Angstrom]'
  do i=1,15
     do j=1,36
        read(7,*) alpha, i_atom, tmp
        if (i_atom<=5) then
           force_constant_matrix(i,alpha+(i_atom-1)*3) = tmp*HARTREE_IN_EV/displacement/acell(alpha)
        end if
     end do
  end do
  close(7)
  
  do i=1,15
     write(6,'(15f11.7)') (force_constant_matrix(i,j),j=1,15)
  end do

  !LAPACK dsyevx(JOBZ, RANGE, UPLO, N, A,                     LDA, 
       !                                        VL, VU, IL, IU, ABSTOL,  M, W,           Z,            LDZ,
       ! WORK,   LWORK, IWORK, IFAIL, INFO)
  call    dsyevx('V',  'A',  'L',   15, force_constant_matrix, 15, &
       &                                        vl, vu, il, iu, 0.0d0,   M, eigenvalues, eigenvectors, 15, &
       & work,   LWORK, iwork, ifail, info)

  write(6,'(a)') 'eigenvalues [eV/Angstrom^2] and eigenvectors of force_constant_matrix'
  do j=1,15
     write(6,'(i2,f11.6,5(f10.3,2f7.3))') j, eigenvalues(j), (eigenvectors(i,j), i=1,15)
  end do

end program feram_frozen_phonon_X

!local variables:
!  compile-command: "make -k feram_frozen_phonon_X && ./feram_frozen_phonon_X'
!End:
