! marsaglia_tsang_uni64_check.F -*-f90-*-
! Time-stamp: <2013-10-10 16:41:40 takeshi>
! Author: Takeshi NISHIMATSU
!!
program marsaglia_tsang_uni64_check
  use marsaglia_tsang_uni64_module
  implicit none
  integer           :: i, j
  integer           :: near, hist(100)
  real*8            :: x
  real*8, parameter :: r(5) = (/&
       5534819329886631.0d0, &
       7222984478804879.0d0, &
       3591084909746267.0d0, &
       6938004922860200.0d0, &
       3518398318353033.0d0/)
  character(len=100), parameter :: f = '(a, ":", i2, ": expected: x = ", e24.17, ",   but was: x = ", e24.17)'

  hist(1:100) = 0

  do j=1,2
     write (6,'("j =", i2)') j
     x=uni64(123456789,987654321)
     if (x .ne. dble(j*2-1)) then
        write(0,f) __FILE__, __LINE__, dble(j*2-1), x
        stop 1
     end if
     do i=1,10000000
        x=uni64()
     end do

     do i=1,5
        x=uni64()*9007199254740992.0d0   ! multiply 2^53
        if (x.ne.r(i)) then
           write(0,f) __FILE__, __LINE__, r(i), x
           stop 2
        end if
        write (6,*) x
     end do

     x = normal_dist(50.0d0, 10.0d0, 375149579-j, 887142104+j)
     if (x .ne. dble(j*2)) then
        write(0,f) __FILE__, __LINE__, dble(j*2), x
        stop 3
     end if
     do i=1,5000000
        x = normal_dist(50.0d0, 10.0d0)
        near = nint(x)
        if (1<=near .and. near<=100) hist(near) = hist(near) + 1
     end do
  end do

  open(8,file='marsaglia_tsang_uni64_check.dat',status='replace')
  do j=1,100
     write(8,'(i3,i10)') j,hist(j)
  end do
  close(8)
end program marsaglia_tsang_uni64_check
