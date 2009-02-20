! frozen_phonon_Gamma.F -*-f90-*-
! Time-stamp: <2009-02-20 15:47:12 t-nissie>
! Author: Takeshi NISHIMATSU
! reference: R. D. King-Smith and David Vanderbilt: "First-principles investigation of
!            ferroelectricity in perovskite compounds", Phys. Rev. B, vol.49, pp.5828-5844 (1994).
!!
#include "define.h"

program frozen_phonon_Gamma
  implicit none
  integer, parameter :: LWORK = 100   ! for LAPACK
  real*8    rwork(LWORK)                       ! for LAPACK zheev

  character (len=30)  dummy
  integer i, j, i_atom, alpha, info
  real*8, parameter :: RATIO_DISPLACEMENT = 0.002d0
  real*8 a0, tmp
  real*8 force_constant_matrix(5,5)
  real*8 eigenvalues(5)

  open(7, FILE='perovskite-frozen-phonon-Gamma.dat', STATUS='OLD')
  read(7,*) dummy, a0
  a0 = a0*BOHR_RADIUS
  write(6,'(a,f11.7,a)') 'a0 = ', a0,             ' [Angstrom]'
  do i=1,5
     do j=1,21
        read(7,*) alpha, i_atom, tmp
        if (alpha==3 .and. i_atom<=5) then
           force_constant_matrix(i,i_atom) = tmp*HARTREE_IN_EV/RATIO_DISPLACEMENT/a0**2
        end if
     end do
  end do
  close(7)
  
  !do i=1,5
  !   write(6,'(5f11.7)') (force_constant_matrix(i,j),j=1,5)
  !end do

  !LAPACK dsyev(JOBZ, UPLO, N, A,                   LDA, W,           WORK,  LWORK, INFO)
  call    dsyev('V',  'L',  5, force_constant_matrix, 5, eigenvalues, rwork, LWORK, info)

  write(6,'(a)') 'eigenvalues [eV/Angstrom^2] and eigenvectors of force_constant_matrix'
  do j=1,5
     write(6,'(i1,f11.6,5f9.4)') j, eigenvalues(j), (force_constant_matrix(i,j), i=1,5)
  end do


end program frozen_phonon_Gamma

!local variables:
!  compile-command: "make -k frozen_phonon_Gamma && ./frozen_phonon_Gamma'
!End:
