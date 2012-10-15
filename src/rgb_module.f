! rgb_module.f -*-f90-*-
! Time-stamp: <2012-10-15 18:16:20 takeshi>
! Author: Takeshi NISHIMATSU
! Usage: call double2rgb(x,a,black=.false.)
! Description:
!    Subroutine double2rgb() traces edges
!    of the color triangle shown in Fig. 1.
!
!
!                green(0,255,0)
!
!      yellow(255,255,0) cyan(0,255,255)
!
! red(255,0,0) purple(255,0,255) blue(0,0,255)
!
!              Figure 1: Triangle.
!
!
!      Table 1: "-" denote changing value.
!   -----------------------------------------
!    x*1275  0   255   510   765  1020  1275
!   -----------------------------------------
!       purple  blue  cyan green yellow  red
!   -----------------------------------------
!      r   255 -   0     0     0 - 255   255
!      g     0     0 - 255   255   255 -   0
!      b   255   255   255 -   0     0     0
!   -----------------------------------------
!!
module rgb_module
  implicit none
  type rgb_type
     integer :: r, g, b
  end type rgb_type

contains
  subroutine double2rgb(x,a,black)
    implicit none
    real*8,            intent(in)  :: x
    type(rgb_type),    intent(out) :: a
    logical, optional, intent(in)  :: black
    integer                        :: ix

    if (x<0.0d0 .or. 1.0d0<x) then   !!! out of range !!!
       if (.not.present(black) .or. black) then
          a%r = 0
          a%g = 0   ! black
          a%b = 0
       else
          a%r = 255
          a%g = 255 ! white
          a%b = 255
       end if
       return
    end if

    ix = nint(x*1275.0d0)

    if (ix<256) then
       a%r = 255-ix
       a%g = 0      ! purple--blue
       a%b = 255
    else if (ix<511) then
       a%r = 0
       a%g = ix-255 ! blue--cyan
       a%b = 255
    else if (ix<766) then
       a%r=0
       a%g=255      ! cyan--green
       a%b=765-ix
    else if (ix<1021) then
       a%r=ix-765
       a%g=255      ! green--yellow
       a%b=0
    else
       a%r=255
       a%g=1275-ix  ! yellow--red
       a%b=0
    end if
  end subroutine double2rgb
end module rgb_module
