! quicksort.f -*-f90-*-
! Time-stamp: <2005-10-05 19:12:35 t-nissie>
! Author: Takeshi NISHIMATSU
!!
recursive subroutine quicksort(a, first, last)
  implicit none
  real*8  a(*)
  integer first, last
  integer i, j
  real*8  x, t;

    x = a((first + last) / 2)
    i = first
    j = last
    do while (.true.)
        do while (a(i) < x)
           i=i+1
        end do
        do while (x < a(j))
           j=j-1
        end do
        if (i >= j) exit
        t = a(i);  a(i) = a(j);  a(j) = t
        i=i+1
        j=j-1
     end do
     if (first  < i - 1) call quicksort(a, first , i - 1)
     if (j + 1 < last)   call quicksort(a, j + 1, last)
end subroutine quicksort
