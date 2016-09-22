! omp_workshare_check.f -*-f90-*-
! Description: It tests "!$omp parallel workshare" with gfortran.
! See: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=69128
! Tips: You can get better timing if you change d=2 to d=1.
! IBM XL Fortran: xlf90_r -q64 -O4 -qsmp=omp -qinfo=all -qreport -o omp_workshare_check omp_workshare_check.f
! Intel Fortran: ifort -free -O3 -warn all -openmp -parallel -qopt-report=2 -o omp_workshare_check omp_workshare_check.f
!!
program omp_workshare_check
  implicit none
  real*8 :: m23(2,3) = reshape( (/ 1.0d0, 2.0d0, 3.0d0, 4.0d0, 5.0d0, 6.0d0 /), (/2,3/) )
  real*8, allocatable :: a(:,:), b(:), c(:)
  integer, parameter :: dim1 = 10000
  integer, parameter :: dim2 = 40000
  integer, parameter :: d = 2
  write(6,'(5f5.1)') maxval(m23(:,:), dim=1)
  write(6,'(5f5.1)') maxval(m23(:,:), dim=2)
  allocate(a(dim1,dim2))
  if (d.eq.1) then
     allocate(b(dim2), c(dim2))
  else
     allocate(b(dim1), c(dim1))
  end if
  call random_number(a)
!$omp parallel workshare
  b(:) = maxval(a(:,:), dim=d)
  c(:) = sum(   a(:,:), dim=d)
!$omp end parallel workshare
end program omp_workshare_check
!Local variables:
!  compile-command: "gfortran -Wall -ffree-form -fopenmp -Ofast -g -o omp_workshare_check omp_workshare_check.f && /usr/bin/time ./omp_workshare_check"
!End:
