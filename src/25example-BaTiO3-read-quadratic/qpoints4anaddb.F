! qpoints4anaddb.F -*-f90-*-
! Time-stamp: <2013-04-23 15:20:29 takeshi>
! Author: Takeshi NISHIMATSU
!!
program qpoints4anaddb
  implicit none
  integer,parameter :: L=16
  integer           :: ix,iy,iz
  real*8            ::  x, y, z
  do iz= 0, L-1
     z=dble(iz)/L; if (z>0.5d0) z=z-1.0d0
     do iy= 0, L-1
        y=dble(iy)/L; if (y>0.5d0) y=y-1.0d0
        do ix= 0, L/2
           x=dble(ix)/L
           write(6,'(f19.5,2f9.5,f6.1)') x,y,z,1.0d0
        end do
     end do
  end do
end program qpoints4anaddb
!Local variables:
!  compile-command: "gfortran -ffree-form -o qpoints4anaddb qpoints4anaddb.F && ./qpoints4anaddb"
!End:
