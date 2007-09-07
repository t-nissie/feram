! cholesky_z.f -*-f90-*-
! Using Cholesky decomposition, cholesky_z.f solve a linear equation Ax=b,
! where A is a n by n positive definite real symmetric matrix, x and b are
! complex*16 vectors length n.
!
! Time-stamp: <2007-07-25 10:41:42 t-nissie>
! Author: Takeshi NISHIMATSU
!
! [1] A = G tG, where G is a lower triangular matrix and tG is transpose of G.
! [2] Solve  Gy=b with  forward elimination
! [3] Solve tGx=y with backward elimination
!
! Reference: Taketomo MITSUI: Solvers for linear equations [in Japanese]
! http://www2.math.human.nagoya-u.ac.jp/~mitsui/syllabi/sis/info_math4_chap2.pdf
!
!OPTION FORM(FREE)
!!
subroutine cholesky_z(n, A, G, b)
  implicit none
  integer,    intent(in)    :: n
  real*8,     intent(in)    :: A(n,n)
  real*8,     intent(out)   :: G(n,n)
  complex*16, intent(inout) :: b(n)
  complex*16 :: tmp
  integer    :: i,j

  ! Light check of positive definite
  do i = 1, n
     if (A(i,i).le.0.0d0) then
        b(:) = 0.0d0
        return
     end if
  end do

  ! [1]
  G(:,:)=0.0d0
  do j = 1, n
     G(j,j) = sqrt( A(j,j) - SUM(G(j,1:j-1)*G(j,1:j-1)) )
     do i = j+1, n
        G(i,j) = ( A(i,j) - SUM(G(i,1:j-1)*G(j,1:j-1)) ) / G(j,j)
     end do
  end do
  ! write(6,'(3f10.5)') (G(i,:), i=1,n)

  ! [2]
  do i = 1, n
     tmp = 0.0d0
     do j = 1, i-1
        tmp = tmp + G(i,j)*b(j)
     end do
     b(i) = (b(i)-tmp)/G(i,i)
  end do

  ! [3]
  do i = n, 1, -1
     tmp = 0.0d0
     do j = i+1, n
        tmp = tmp + b(j)*G(j,i)
     end do
     b(i) = (b(i)-tmp)/G(i,i)
  end do
end subroutine cholesky_z
