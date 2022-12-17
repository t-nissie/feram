! shuffle_integer_array_check.f -*-f90-*-
! Author: Takeshi NISHIMATSU
!!
program shuffle_integer_array_check
  use marsaglia_tsang_uni64_module
  implicit none
  integer,parameter   :: test1=20, test2=10, max=100000
  integer,allocatable :: ary(:), hst(:)
  integer             :: i, j, loc
  real*8              :: dmy
  dmy = uni64(123456789,987654321)

  allocate(ary(test1))
  do i = 1,    test1
     ary(i) = i
  end do
  do j = 1,100
     call shuffle_integer_array(ary)
     do i = 1, test1
        write(6,'(i3)', advance='no') ary(i)
     end do
     write(6,'()')
  end do
  deallocate(ary)

  allocate(ary(test2),hst(test2))
  do i = 1,    test2
     ary(i) = i*100
     hst(i) = 0
  end do
  do j = 1,max
     call shuffle_integer_array(ary)
     loc =findloc(ary,100,1)
     hst(loc) = hst(loc) + 1
  end do
  do i = 1,    test2
     write(6,'(2i10)') i, hst(i)
     if (abs(hst(i)-max/test2)>max/test2*0.03d0) stop 1
  end do
  deallocate(ary,hst)
end program shuffle_integer_array_check
