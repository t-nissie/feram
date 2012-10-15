! rgb_check.f -*-f90-*-
! Time-stamp: <2012-10-15 19:07:37 takeshi>
! Author: Takeshi NISHIMATSU
!!
program rgb_check
  use rgb_module
  implicit none
  integer        :: i, j
  real*8         :: x
  type(rgb_type) :: a
  open(8,file='rgb_check.ppm',status='replace')
  write(8,'(a)') 'P6'
  write(8,'(a)') '# rgb_check.ppm'
  write(8,'(a)') '1476 200'
  write(8,'(a)') '255'
  do j=1,200
     do i=-100,1375
        x = dble(i)/1275.0d0
        if (j<=100) then
           call double2rgb(x,a)
        else
           call double2rgb(x,a,.false.)
        end if
        write(8,'(a,a,a,$)') char(a%r), char(a%g), char(a%b)
     end do
  end do
  close(8)
end program rgb_check
!Local variables:
!  compile-command: "make -k rgb_check && ./rgb_check"
!End:
