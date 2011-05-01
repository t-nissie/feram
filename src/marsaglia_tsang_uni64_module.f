! marsaglia_tsang_uni64_module.f -*-f90-*-
! Marsaglia-Tsang 64-bit universal RNG
! It does not use global variable.
! Time-stamp: <2011-05-01 20:46:36 takeshi>
! Author:     Takeshi NISHIMATSU
! Usage:      See marsaglia_tsang_uni64_check.f for example.
!             (1) Set two integers for seeds. It will return 1.0d0.
!                 dmy = uni64(123456789,987654321)   ! dmy will be 1.0d0.
!             (2) Use unit64() function without any arguments.
!                 It will return [0.0,1.0) double precision random number again and again.
!                 r1 = uni64()
!                 r2 = uni64()
!                       :
!             (3) To reset seeds and internal variables, call uni64() with new seeds.
!                 It will return 2.0d0,  3.0d0,  4.0d0, ...
!                 dmy = uni64(375149579,887142154)   ! dmy will be 2.0d0.
!                 r1 = uni64()
!                 r2 = uni64()
!                       :
!                 dmy = uni64(459842894,586734952)   ! dmy will be 3.0d0.
!             (x) Note that uni64() is THREAD-UNSAFE.
! Reference1: George Marsaglia and Wai Wan Tsang: "The 64-bit universal RNG",
!             Statistics & Probability Letters, Vol. 66, pp. 183-187 (2004),
!             doi:10.1016/j.spl.2003.11.001. Note that a part of code in the
!             bottom of p.186, "y=(8888*x)%65579;" should be replaced by
!             "y=(8888*y)%65579;". Consequently, 5 values of "The correct output"
!             in p.187 are incorrect. See http://sci4um.com/about16220-asc.html
!             and marsaglia_tsang_uni64_check.f.
! Reference2: Haruhiko Okumura: C-gengo niyoru saishin algorithm jiten
!             (New Algorithm handbook in C language) (Gijyutsu hyouron
!             sha, Tokyo, 1991) [in Japanese]
!!
module marsaglia_tsang_uni64_module
  implicit none
  private
  public :: uni64, normal_dist
contains
  subroutine fillu(u,seed1,seed2)
    implicit none
    real*8, intent(out) :: u(97)
    integer,intent(in)  :: seed1,seed2
    integer             :: i,j,x,y
    real*8              :: s,t
    x=seed1
    y=seed2
    do i=1,97
       s=0.d0
       t=0.5d0
       do j=1,53
          x=mod(6969*x,65543)
          y=mod(8888*y,65579)
          if (iand(ieor(x,y),32).gt.0) s=s+t
          t=0.5d0*t
       end do
       u(i)=s
    end do
  end subroutine fillu

  real*8 function uni64(seed1,seed2)
    implicit none
    integer,optional  :: seed1, seed2
    integer,save      :: i, j
    real*8, save      :: c
    real*8, save      :: times_initialized=0.0d0
    real*8, save      :: u(97)
    real*8            :: x
    real*8, parameter :: r=9007199254740881.d0/9007199254740992.d0
    real*8, parameter :: d=362436069876.d0/9007199254740992.d0
    if (present(seed1)) then
       call fillu(u,seed1,seed2)
       i=97
       j=33
       c=0.0d0
       times_initialized=times_initialized+1.0d0
       uni64=times_initialized
    else
       if (times_initialized<1.0d0) stop 'uni64.f is not initialized yet.'
       x=u(i)-u(j)
       if (x.lt.0.0d0) x=x+1.0d0
       u(i)=x
       i=i-1
       if (i.eq.0) i=97
       j=j-1
       if (j.eq.0) j=97
       c=c-d
       if (c.lt.0.0d0) c=c+r
       x=x-c
       uni64=x
       if (x.lt.0.0d0) uni64=x+1.d0
    end if
  end function uni64

  ! N(mu,sigma^2) normal-distributed random number generator
  ! N(mu,sigma^2) = N(0,1)*sigma + mu
  ! See Reference2
  real*8 function normal_dist(mu,sigma)
    implicit none
    real*8 mu, sigma
    real*8, parameter :: M_2PI = 6.28318530717958647693d0
    real*8 N01   ! standard normal distribution
    real*8 t, u
    t = sqrt( -2 * log(1.0d0-uni64()) )
    u = M_2PI * uni64()
    N01 = t * cos(u)
    normal_dist = N01*sigma + mu
  end function normal_dist
end module marsaglia_tsang_uni64_module
