! fft.F -*-f90-*-
! Time-stamp: <2012-01-12 12:20:50 t-nissie>
! Author: Takeshi NISHIMATSU
! Architectures and Libraries:
!    FFTW3 (HAVE_LIBFFTW3, including wrapper in Intel MKL)
!    MATRIX/MPP of HITACHI SR11000 and SR16000 (HITACHI_SR)
!    ACML (HAVE_LIBACML_MP)
!    Fujitsu SSL2 (__sparc)
!    Built in minimal FFT library (BUILT_IN_FFT)
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
#include "define.h"

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
  ip = 0
  do beta = 1, 3
     do alpha = 1, beta
        ip = ip + 1
        call dfftw_plan_dft_r2c_3d(plan(ip), p%Lx, p%Ly, p%Lz, &
             & r(0,0,0,alpha,beta), c(0,0,0,alpha,beta), FFTW_ESTIMATE)
     end do
  end do
  do ip = 1, 6
     call dfftw_execute(plan(ip))
  end do
  do ip = 1, 6
     call dfftw_destroy_plan(plan(ip))
  end do
#else
  do beta = 1, 3
     do alpha = 1, beta
        call matrix_mpp_fft(1, p%Lx, p%Ly, p%Lz, &
             & r(0,0,0,alpha,beta), c(0,0,0,alpha,beta))
     end do
  end do
#endif
  c(:,:,:,2,1) = conjg(c(:,:,:,1,2))
  c(:,:,:,3,1) = conjg(c(:,:,:,1,3))
  c(:,:,:,3,2) = conjg(c(:,:,:,2,3))
end subroutine fft_r2c_3x3upper

#if defined(HITACHI_SR)
subroutine n2pqr(n,pqr)
  implicit none
  integer, intent(in)  :: n
  integer, intent(out) :: pqr(3)
  integer tmp
  tmp=n
  pqr(:)=0
  do while(mod(tmp,2)==0)
     pqr(1)=pqr(1)+1
     tmp=tmp/2
  end do
  do while(mod(tmp,3)==0)
     pqr(2)=pqr(2)+1
     tmp=tmp/3
  end do
  do while(mod(tmp,5)==0)
     pqr(3)=pqr(3)+1
     tmp=tmp/5
  end do
  !write(6,'(i6,3(a,i2))') n, ' = 2**',pqr(1), ' + 3**',pqr(2), ' + 5**',pqr(3)
  if (tmp.ne.1) stop 'fft.F:132: STOP at subroutine n2pqr().'
end subroutine n2pqr

subroutine matrix_mpp_fft(iopt1, Nx, Ny, Nz, r, c)
  implicit none
  integer,   intent(in) :: iopt1
  integer,   intent(in) :: Nx, Ny, Nz
  integer,   save       :: Nx_last=0, Ny_last=0, Nz_last=0
  real*8                :: r(0:Nx-1, 0:Ny-1, 0:Nz-1)
  complex*16            :: c(0:Nx/2, 0:Ny-1, 0:Nz-1) !CAUTION "/2"!
  integer,   save       :: ip1(3), ip2(3), ip3(3), ndim1, nwk1, nwk2, ipara
  integer               :: iopt(2)
  integer,   parameter  :: NWKW  = 5
  complex*16,save       :: tb1(2048), tb2(2048), tb3(2048)
  complex*16,allocatable:: wk1(:), wk2(:)
  integer               :: ier, ix, iy, iz
  character(len=10)     :: ipara_s

  iopt(1)=iopt1

  if (Nx.ne.Nx_last .or. Ny.ne.Ny_last .or. Nz.ne.Nz_last) then
     if (mod(Nx,2).ne.0) stop 'fft.F:173: Nx must be an even number.'
     call n2pqr(Nx, ip1)
     call n2pqr(Ny, ip2)
     call n2pqr(Nz, ip3)
     ndim1 = Nx+2
     ipara = $NUMTHRD()
     write(ipara_s,'(i8)') ipara
     call msg(UNIT_LOG, __FILE__, __LINE__, 'ipara = ', ipara_s)
     nwk1 = (Nx/2+NWKW)*(Ny+NWKW)*(Nz+NWKW) + 100
     nwk2 = (Nx/2+NWKW)*MAX(Ny+NWKW,Nz+NWKW)*ipara + 100
     iopt(2)=1
     Nx_last=Nx
     Ny_last=Ny
     Nz_last=Nz
  else
     iopt(2)=2
  end if

  allocate(wk1(nwk1), wk2(nwk2))

  if (iopt1==1) then
     do iz = 0, Nz-1
        do iy = 0, Ny-1
           do ix = 0, Nx/2-1
              c(ix,iy,iz) = cmplx(r(2*ix,iy,iz),r(2*ix+1,iy,iz),kind(0.0d0))
           end do
        end do
     end do
     call HDFZ7M(c, ndim1,Ny, Nx,Ny,Nz, ip1,ip2,ip3, iopt,tb1,tb2,tb3,  wk1,wk2, NWKW,ipara, ier)
  else
     call HZFD7M(c, ndim1,Ny, Nx,Ny,Nz, ip1,ip2,ip3, iopt,tb1,tb2,tb3,  wk1,wk2, NWKW,ipara, ier)
     do iz = 0, Nz-1
        do iy = 0, Ny-1
           do ix = 0, Nx/2-1
              r(2*ix  ,iy,iz) =  dble(c(ix,iy,iz))
              r(2*ix+1,iy,iz) = aimag(c(ix,iy,iz))
           end do
        end do
     end do
  end if

  deallocate(wk1,wk2)
end subroutine matrix_mpp_fft
#endif
!

#if defined(__sparc)
subroutine dfftw_plan_dft_r2c_3d(plan, Nx, Ny, Nz, r, c, flags)
  implicit none
  integer*8, intent(in) :: plan
  integer,   intent(in) :: Nx, Ny, Nz
  real*8,    intent(in) :: r(0:Nx-1, 0:Ny-1, 0:Nz-1)
! complex*16,intent(out):: c(0:Nx/2,         0:Ny-1, 0:Nz-1) !CAUTION "/2"!
  real*8,    intent(out):: c(0:2*(Nx/2+1)-1, 0:Ny-1, 0:Nz-1)
  integer,   intent(in) :: flags
  integer ix, iy, iz, icon
  do iz = 0, Nz-1
     do iy = 0, Ny-1
        do ix = 0, Nx-1
           c(ix,iy,iz) = r(ix,iy,iz)
        end do
     end do
  end do
  call DM_V3DRCF(c, 2*(Nx/2+1), Nx, Ny, Nz, 1,  1, ICON)
end subroutine dfftw_plan_dft_r2c_3d

subroutine dfftw_plan_dft_c2r_3d(plan, Nx, Ny, Nz, c, r, flags)
  implicit none
  integer*8, intent(in) :: plan
  integer,   intent(in) :: Nx, Ny, Nz
  complex*16            :: c(0:Nx/2, 0:Ny-1, 0:Nz-1) !CAUTION "/2"!
  real*8,    intent(out):: r(0:Nx-1, 0:Ny-1, 0:Nz-1)
  integer,   intent(in) :: flags
  integer ix, iy, iz, icon
  call DM_V3DRCF(c, 2*(Nx/2+1), Nx, Ny, Nz, 1, -1, ICON)
  do iz = 0, Nz-1
     do iy = 0, Ny-1
        do ix = 0, Nx-1
           if (mod(ix,2)==0) then
              r(ix,iy,iz) =  dble(c(ix/2,iy,iz))
           else
              r(ix,iy,iz) = aimag(c(ix/2,iy,iz))
           end if
        end do
     end do
  end do
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
