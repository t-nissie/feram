! hensachi.F   -*-f90-*-
! Time-stamp: <2005-11-11 17:11:10 t-nissie>
! Author: Takeshi NISHIMATSU
!!
program hensachi
  implicit none
  integer i,j
  real*8 mu, sigma, normal_dist, x
  integer hist(100)

  mu    = 50.0d0
  sigma = 10.0d0

  hist(:)=0
  do i=1,1000000
     x=normal_dist(mu,sigma)
     !write(6,'(f10.3)') x
     do j=1,100
        if (dble(j-1)<=x .and. x<dble(j)) hist(j)=hist(j)+1
     end do
  end do

  do j=1,100
     write(6,'(i3,i10)') j,hist(j)
  end do
end program hensachi
