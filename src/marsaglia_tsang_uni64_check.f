! marsaglia_tsang_uni64_check.f -*-f90-*-
! Time-stamp: <2011-05-02 07:13:19 takeshi>
! Author: Takeshi NISHIMATSU
!!
program marsaglia_tsang_uni64_check
  use marsaglia_tsang_uni64_module
  implicit none
  integer           :: i, j
  real*8            :: x
  real*8, parameter :: r(5) = (/&
       5534819329886631.0d0, &
       7222984478804879.0d0, &
       3591084909746267.0d0, &
       6938004922860200.0d0, &
       3518398318353033.0d0/)

  do j=1,2
     write (6,'("j =", i2)') j
     x=uni64(123456789,987654321)
     if (x .ne. dble(j*2-1)) then
        write(6,   '("marsaglia_tsang_uni64_check.f:21: expected: ", f3.1,  ", but was: x = ",e17.10)') dble(j*2-1), x
        stop 1
     end if
     do i=1,10000000
        x=uni64()
     end do
     do i=1,5
        x=uni64()*9007199254740992.0d0   ! multiply 2^53
        if (x.ne.r(i)) then
           write(6,'("marsaglia_tsang_uni64_check.f:30: expected: ", f20.1, ", but was: x = ",e17.10)') r(i), x
           stop 1
        end if
        write (6,*) x
     end do
     x = uni64(375149579,887142154)
     if (x .ne. dble(j*2)) then
        write(6,   '("marsaglia_tsang_uni64_check.f:37: expected: ", f3.1,  ", but was: x = ",e17.10)') dble(j*2), x
        stop 1
     end if
     do i=1,10000000
        x=uni64()
     end do
  end do
end program marsaglia_tsang_uni64_check
