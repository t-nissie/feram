! test_fft3d.f -*-f90-*-
! Time-stamp: <2007-06-01 19:35:37 t-nissie>
! Author: Takeshi NISHIMATSU
!!
program test_fft3d
  implicit none
  integer, parameter :: Nx=32, Ny=32, Nz=64

  real*8     :: r(0:Nx-1, 0:Ny-1, 0:Nz-1)
  complex*16 :: c(0:Nx/2, 0:Ny-1, 0:Nz-1) !CAUTION "/2"!

  integer i

  r(:,:,:) = 1.2345d0
  r(2,2,2) = 100.2345d0
  do i = 1, 1000
     call fft3d(.true.,  Nx,Ny,Nz, r, c)
     call fft3d(.false., Nx,Ny,Nz, r, c)
     r(:,:,:)=r(:,:,:)/(Nx*Ny*Nz)
  end do
  write(6,*) r(1,2,3)

end program test_fft3d
