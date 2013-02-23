! qpoints4anaddb.F -*-f90-*-
! Time-stamp: <2013-02-23 18:23:25 takeshi>
! Author: Takeshi NISHIMATSU
!!
program qpoints4anaddb
  implicit none
  integer, parameter :: L=16
  integer ix, iy, iz
  real*8 dL
  dL = dble(L)
  do iz=0,L-1
     do iy=0,L-1
        do ix=0,L/2
           write(6,'(f19.5,2f9.5,f6.1)') ix/dL, iy/dL, iz/dL, 1.0d0
        end do
     end do
  end do
end program qpoints4anaddb
!Local variables:
!  compile-command: "gfortran -ffree-form -o qpoints4anaddb qpoints4anaddb.F && ./qpoints4anaddb"
!End:
