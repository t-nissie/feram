! feram_fftw_wisdom.F -*-f90-*-
! Time-stamp: <2015-04-04 16:59:31 takeshi>
! Author: Takeshi NISHIMATSU
!!
program feram_fftw_wisdom
  use, intrinsic :: iso_c_binding
  implicit none
  integer iz
  real*8,     allocatable :: dipoR(:,:,:,:)   ! Optical dipole displacements as a function of R
  complex*16, allocatable :: dipoK(:,:,:,:)   ! FT of dipoQ
  type(C_PTR) ::         plan_dipoR2C

  include 'fftw3.f03'
  integer howmany,stride
  integer, parameter :: Lx = 32
  integer, parameter :: Ly = 32
  integer, parameter :: Lz = 32
  integer, parameter :: rank=3
  integer, parameter :: dist=1
  integer  LzLyLx(3)
  integer d_embed(3)
  integer z_embed(3)
  LzLyLx( 1)=Lz; LzLyLx( 2)=Ly; LzLyLx( 3)=Lx    ! padding_y will be introduced.
  d_embed(1)=Lz; d_embed(2)=Ly; d_embed(3)=Lx    ! Not 2*(Lx/2+1), so far.
  z_embed(1)=Lz; z_embed(2)=Ly; z_embed(3)=Lx/2+1

  if (allocated(dipoR)) deallocate(dipoR)
  allocate(     dipoR(3, 0:Lx-1, 0:Ly-1, 0:Lz-1))
  if (allocated(dipoK)) deallocate(dipoK)
  allocate(     dipoK(3, 0:Lx/2, 0:Ly-1, 0:Lz-1)) !"/2" for real<->complex FFT

!!!first touch
!$omp parallel do
  do iz = 0,Lz-1
     dipoR(:,:,:,iz) = 0.0d0
  end do
!$omp end parallel do
!$omp parallel do
  do iz = 0,Lz-1
     dipoK(:,:,:,iz) = (0.0d0,0.0d0)
  end do
!$omp end parallel do

  howmany = 3
  stride = howmany
  plan_dipoR2C = fftw_plan_many_dft_r2c(rank,LzLyLx,howmany,&
       &                                  dipoR,d_embed,stride,dist,&
       &                                  dipoK,z_embed,stride,dist,FFTW_MEASURE)
end program feram_fftw_wisdom
