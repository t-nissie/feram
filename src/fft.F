! fft.F -*-f90-*-
! Time-stamp: <2007-08-09 10:54:09 t-nissie>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif

subroutine fft_r2c_3x3upper(p,r,c)
  use Param_module
  implicit none
  type(Param_type) :: p
  real*8     :: r(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 3, 3)
  complex*16 :: c(0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1, 3, 3) !CAUTION "/2"!
  integer alpha, beta, ip
  integer*8 plan(6)
#if defined(HAVE_LIBFFTW3)
# include "fftw3.f"
#else
# define FFTW_ESTIMATE 0
#endif

  ip = 0
  do beta = 1, 3
     do alpha = 1, beta
        ip = ip + 1
        call dfftw_plan_dft_r2c_3d(plan(ip), p%Lx, p%Ly, p%Lz, &
             & r(0,0,0,alpha,beta), c(0,0,0,alpha,beta), FFTW_ESTIMATE)
     end do
  end do

#if defined(HAVE_LIBFFTW3)
  !$omp parallel do
  do ip = 1, 6
     call dfftw_execute(plan(ip))
  end do
  !$omp end parallel do
  do ip = 1, 6
     call dfftw_destroy_plan(plan(ip))
  end do
#endif

  c(:,:,:,2,1) = conjg(c(:,:,:,1,2))
  c(:,:,:,3,1) = conjg(c(:,:,:,1,3))
  c(:,:,:,3,2) = conjg(c(:,:,:,2,3))
end subroutine fft_r2c_3x3upper
!

subroutine fft_r2c(p,r,c,max_alpha)
  use Param_module
  implicit none
  type(Param_type) :: p
  real*8     :: r(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, *)
  complex*16 :: c(0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1, *) !CAUTION "/2"!
  integer max_alpha
  integer alpha ! See info of FFTW, section of "Multi-Dimensional DFTs of Real Data"
  integer*8 plan(max_alpha)
#if defined(HAVE_LIBFFTW3)
# include "fftw3.f"
#else
# define FFTW_ESTIMATE 0
#endif
  do alpha = 1, max_alpha
     call dfftw_plan_dft_r2c_3d(plan(alpha), p%Lx, p%Ly, p%Lz, &
          & r(0,0,0,alpha), c(0,0,0,alpha), FFTW_ESTIMATE)
  end do
#if defined(HAVE_LIBFFTW3)
  !$omp parallel do
  do alpha = 1, max_alpha
     call dfftw_execute(plan(alpha))
  end do
  !$omp end parallel do
  do alpha = 1, max_alpha
     call dfftw_destroy_plan(plan(alpha))
  end do
#endif
end subroutine fft_r2c

subroutine fft_c2r(p,c,r,max_alpha)
  use Param_module
  implicit none
  type(Param_type) :: p
  complex*16 :: c(0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1, *) !CAUTION "/2"!
  real*8     :: r(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, *)
  integer max_alpha
  integer alpha ! See info of FFTW, section of "Multi-Dimensional DFTs of Real Data"
  integer*8 plan(max_alpha)
#if defined(HAVE_LIBFFTW3)
# include "fftw3.f"
#else
# define FFTW_ESTIMATE 0
#endif
  do alpha = 1, max_alpha
     call dfftw_plan_dft_c2r_3d(plan(alpha), p%Lx, p%Ly, p%Lz, &
          & c(0,0,0,alpha), r(0,0,0,alpha), FFTW_ESTIMATE)
  end do
#if defined(HAVE_LIBFFTW3)
  !$omp parallel do
  do alpha = 1, max_alpha
     call dfftw_execute(plan(alpha))
  end do
  !$omp end parallel do
  do alpha = 1, max_alpha
     call dfftw_destroy_plan(plan(alpha))
  end do
#endif
end subroutine fft_c2r
!

#if defined(SR11000)
subroutine n2pqr(n,pqr)
  implicit none
  integer, intent(in)  :: n
  integer, intent(out) :: pqr(3)
  integer tmp
  tmp=n
  pqr(:)=0
  do while(tmp.eq.(tmp/2)*2)
     pqr(1)=pqr(1)+1
     tmp=tmp/2
  end do
  do while(tmp.eq.(tmp/3)*3)
     pqr(2)=pqr(2)+1
     tmp=tmp/3
  end do
  do while(tmp.eq.(tmp/5)*5)
     pqr(3)=pqr(3)+1
     tmp=tmp/5
  end do
  !write(6,'(i6,3(a,i2))') n, ' = 2**',pqr(1), ' + 3**',pqr(2), ' + 5**',pqr(3)
  if (tmp.ne.1) stop 'STOP at subroutine n2pqr().'
end subroutine n2pqr

subroutine dfftw_plan_dft_r2c_3d(plan, Nx, Ny, Nz, r, c, flags)
  implicit none
  integer*8, intent(in) :: plan
  integer,   intent(in) :: Nx, Ny, Nz
  real*8     :: r(0:Nx-1, 0:Ny-1, 0:Nz-1)
  complex*16 :: c(0:Nx/2, 0:Ny-1, 0:Nz-1) !CAUTION "/2"!
  integer, intent(in) :: flags
  integer ip1(3), ip2(3), ip3(3), ndim1, ndim2
  integer, parameter :: IOPT(2) = (/1,1/)
  integer, parameter :: NWKW = 5
  complex*16, allocatable :: f(:,:,:), tb1(:),tb2(:),tb3(:), wk(:)
  integer ix, iy, iz, nwk, ier

  call n2pqr(Nx, ip1)
  call n2pqr(Ny, ip2)
  call n2pqr(Nz, ip3)

  if (ip1(2).eq.0 .and. ip1(3).eq.0) then
     ndim1 = Nx+1   ! Avoid bank conflict
  else
     ndim1 = Nx
  end if

  if (ip2(2).eq.0 .and. ip2(3).eq.0) then
     ndim2 = Ny+1   ! Avoid bank conflict
  else
     ndim2 = Ny
  end if

  allocate(f(0:ndim1-1,0:ndim2-1,0:Nz-1)); f(:,:,:)=(0.0d0,0.0d0)

  do iz = 0, Nz-1
     do iy = 0, Ny-1
        do ix = 0, Nx-1
           f(ix,iy,iz) = r(ix,iy,iz)
        end do
     end do
  end do

  allocate(tb1(Nx))
  allocate(tb2(Ny))
  allocate(tb3(Nz))

  nwk = MAX((Nx+NWKW)*Ny*Nz,(Ny+NWKW)*Nx*Nz) + 100
  allocate(wk(nwk))

  call HZFT7M(f, ndim1,ndim2, Nx,Ny,Nz, ip1,ip2,ip3, IOPT, tb1,tb2,tb3, wk,NWKW, ier)

  do iz = 0, Nz-1
     do iy = 0, Ny-1
        do ix = 0, Nx/2
           c(ix,iy,iz) = f(ix,iy,iz)
        end do
     end do
  end do

  deallocate(f,tb1,tb2,tb3,wk)
end subroutine dfftw_plan_dft_r2c_3d

subroutine dfftw_plan_dft_c2r_3d(plan, Nx, Ny, Nz, c, r, flags)
  implicit none
  integer*8, intent(in) :: plan
  integer,   intent(in) :: Nx, Ny, Nz
  complex*16 :: c(0:Nx/2, 0:Ny-1, 0:Nz-1) !CAUTION "/2"!
  real*8     :: r(0:Nx-1, 0:Ny-1, 0:Nz-1)
  integer, intent(in) :: flags
  integer ip1(3), ip2(3), ip3(3), ndim1, ndim2
  integer, parameter :: IOPT(2) = (/2,1/)
  integer, parameter :: NWKW = 5
  complex*16, allocatable :: f(:,:,:), tb1(:),tb2(:),tb3(:), wk(:)
  integer ix, iy, iz, nwk, ier

  call n2pqr(Nx, ip1)
  call n2pqr(Ny, ip2)
  call n2pqr(Nz, ip3)

  if (ip1(2).eq.0 .and. ip1(3).eq.0) then
     ndim1 = Nx+1   ! Avoid bank conflict
  else
     ndim1 = Nx
  end if

  if (ip2(2).eq.0 .and. ip2(3).eq.0) then
     ndim2 = Ny+1   ! Avoid bank conflict
  else
     ndim2 = Ny
  end if

  allocate(f(0:ndim1-1,0:ndim2-1,0:Nz-1)); f(:,:,:)=(0.0d0,0.0d0)

  do iz = 0, Nz-1
     do iy = 0, Ny-1
        do ix = 0, Nx/2
           f(ix,iy,iz) = c(ix,iy,iz)
        end do
        do ix = Nx/2+1,Nx-1
           f(ix,iy,iz) = conjg(c(Nx-ix,mod(Ny-iy,Ny),mod(Nz-iz,Nz)))
        end do
     end do
  end do

  allocate(tb1(Nx))
  allocate(tb2(Ny))
  allocate(tb3(Nz))

  nwk = MAX((Nx +NWKW)*Ny*Nz,(Ny+NWKW)*Nx*Nz) + 100
  allocate(wk(nwk))

  call HZFT7M(f, ndim1,ndim2, Nx,Ny,Nz, ip1,ip2,ip3, IOPT, tb1,tb2,tb3, wk,NWKW, ier)

  do iz = 0, Nz-1
     do iy = 0, Ny-1
        do ix = 0, Nx-1
           r(ix,iy,iz) = dble(f(ix,iy,iz))
        end do
     end do
  end do

  deallocate(f,tb1,tb2,tb3,wk)
end subroutine dfftw_plan_dft_c2r_3d
#endif
!

#if defined(HAVE_LIBACML) ||  defined(HAVE_LIBACML_MP)
subroutine dfftw_plan_dft_r2c_3d(plan, Nx, Ny, Nz, r, c, flags)
  implicit none
  integer*8, intent(in) :: plan
  integer,   intent(in) :: Nx, Ny, Nz
  real*8     :: r(0:Nx-1, 0:Ny-1, 0:Nz-1)
  complex*16 :: c(0:Nx/2, 0:Ny-1, 0:Nz-1) !CAUTION "/2"!
  integer, intent(in) :: flags
  complex*16, allocatable :: f(:,:,:), comm(:)
  integer ix, iy, iz, info

  allocate( f(0:Nx-1, 0:Ny-1, 0:Nz-1) ); f(:,:,:)=(0.0d0,0.0d0)
  allocate( comm(Nx*Ny*Nz+10*(Nx+Ny+Nz)) )

  do iz = 0, Nz-1
     do iy = 0, Ny-1
        do ix = 0, Nx-1
           f(ix,iy,iz) = r(ix,iy,iz)
        end do
     end do
  end do

  call ZFFT3D(1, Nx,Ny,Nz, f, comm, info)

  do iz = 0, Nz-1
     do iy = 0, Ny-1
        do ix = 0, Nx/2
           c(ix,iy,iz) = f(ix,iy,iz)
        end do
     end do
  end do

  deallocate(f,comm)
end subroutine dfftw_plan_dft_r2c_3d

subroutine dfftw_plan_dft_c2r_3d(plan, Nx, Ny, Nz, c, r, flags)
  implicit none
  integer*8, intent(in) :: plan
  integer,   intent(in) :: Nx, Ny, Nz
  complex*16 :: c(0:Nx/2, 0:Ny-1, 0:Nz-1) !CAUTION "/2"!
  real*8     :: r(0:Nx-1, 0:Ny-1, 0:Nz-1)
  integer, intent(in) :: flags
  complex*16, allocatable :: f(:,:,:), comm(:)
  integer ix, iy, iz, info

  allocate( f(0:Nx-1, 0:Ny-1, 0:Nz-1) ); f(:,:,:)=(0.0d0,0.0d0)
  allocate( comm(Nx*Ny*Nz+10*(Nx+Ny+Nz)) )

  do iz = 0, Nz-1
     do iy = 0, Ny-1
        do ix = 0, Nx/2
           f(ix,iy,iz) = c(ix,iy,iz)
        end do
        do ix = Nx/2+1,Nx-1
           f(ix,iy,iz) = conjg(c(Nx-ix,mod(Ny-iy,Ny),mod(Nz-iz,Nz)))
        end do
     end do
  end do

  call ZFFT3D(-1, Nx,Ny,Nz, f, comm, info)

  do iz = 0, Nz-1
     do iy = 0, Ny-1
        do ix = 0, Nx-1
           r(ix,iy,iz) = dble(f(ix,iy,iz))
        end do
     end do
  end do

  deallocate(f,comm)
end subroutine dfftw_plan_dft_c2r_3d
#endif
!

#if defined(BUILT_IN_FFT)
subroutine dfftw_plan_dft_r2c_3d(plan, Nx, Ny, Nz, r, c, flags)
  implicit none
  integer*8, intent(in) :: plan
  integer,   intent(in) :: Nx, Ny, Nz
  real*8     :: r(0:Nx-1, 0:Ny-1, 0:Nz-1)
  complex*16 :: c(0:Nx/2, 0:Ny-1, 0:Nz-1) !CAUTION "/2"!
  integer, intent(in) :: flags
  call fft3d(.true.,  Nx, Ny, Nz, r, c)
end subroutine dfftw_plan_dft_r2c_3d

subroutine dfftw_plan_dft_c2r_3d(plan, Nx, Ny, Nz, c, r, flags)
  implicit none
  integer*8, intent(in) :: plan
  integer,   intent(in) :: Nx, Ny, Nz
  complex*16 :: c(0:Nx/2, 0:Ny-1, 0:Nz-1) !CAUTION "/2"!
  real*8     :: r(0:Nx-1, 0:Ny-1, 0:Nz-1)
  integer, intent(in) :: flags
  call fft3d(.false., Nx, Ny, Nz, r, c)
end subroutine dfftw_plan_dft_c2r_3d
#endif
