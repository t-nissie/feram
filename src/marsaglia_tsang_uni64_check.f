! marsaglia_tsang_uni64_check.f -*-f90-*-
! Time-stamp: <2011-04-28 11:03:30 t-nissie>
! Author: Takeshi NISHIMATSU
!!
program marsaglia_tsang_uni64_check
  use marsaglia_tsang_uni64_module
  implicit none
  integer i
  double precision x
  double precision, parameter :: r(5) = (/&
       5534819329886631.0d0, &
       7222984478804879.0d0, &
       3591084909746267.0d0, &
       6938004922860200.0d0, &
       3518398318353033.0d0/)

  x=uni64(123456789,987654321)

  if (x.ne.1.0d0) then
     write(6,'("check_uni64.f:19: expected: 1.0, but was: x=",f20.10)') x
     stop 1
  end if

  do i=1,10000000
     x=uni64()
  end do

  do i=1,5
     x=uni64()*9007199254740992.0d0   ! multiply 2^53
     if (x.ne.r(i)) then
        write(6,'("check_uni64.f:29: expected:",f20.1,", but was: x=",f20.1)') r(i), x
        stop 1
     end if
     write (6,*) x
  end do
end program marsaglia_tsang_uni64_check
