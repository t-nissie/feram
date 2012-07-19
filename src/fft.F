! fft.F -*-f90-*-
! Time-stamp: <2012-07-19 20:35:10 t-nissie>
! Author: Takeshi NISHIMATSU
! Architectures and Libraries:
!    FFTW3 (HAVE_LIBFFTW3, including wrapper in Intel MKL)
!    MATRIX/MPP of HITACHI SR11000 and SR16000 (HAVE_LIBMATMPP)
!    ACML (HAVE_LIBACML_MP)
!    Fujitsu SSL2 (__sparc)
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif

subroutine fft_dummy()
  write(6,*) 'This is a dummy subroutine.'
end subroutine fft_dummy

#if defined(HAVE_LIBMATMPP)
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
  if (tmp.ne.1) stop 'fft.F:37: STOP at subroutine n2pqr().'
end subroutine n2pqr

!        Nx          8   9
!        Nx/2        4   4
!    c(0:Nx/2)      10  10
!     2*(Nx/2+1)-1   9   9
! r(0:2*(Nx/2+1)-1) 10  10
!     2*(Nx/2+1)    10  10   ndim1
subroutine fft_3d_r2c_or_c2r_in_place(mode, Nx, Ny, Nz, r)
  implicit none
  logical,   intent(in) :: mode
  integer,   intent(in) :: Nx, Ny, Nz
  real*8, intent(inout) :: r(0:2*(Nx/2+1)-1, 0:Ny-1, 0:Nz-1)
  integer,   save       :: Nx_last=0, Ny_last=0, Nz_last=0
  integer,   save       :: ip1(3), ip2(3), ip3(3), ndim1, nwk1, nwk2, ipara
  integer               :: iopt(2)
  integer,   parameter  :: NWKW  = 5
  complex*16,save       :: tb1(2048), tb2(2048), tb3(2048)
  complex*16,allocatable:: wk1(:), wk2(:)
  integer               :: ier

  if (mode) then
     iopt(1)=1
  else
     iopt(1)=2
  end if

  if (Nx.ne.Nx_last .or. Ny.ne.Ny_last .or. Nz.ne.Nz_last) then
     call n2pqr(Nx, ip1)
     call n2pqr(Ny, ip2)
     call n2pqr(Nz, ip3)
     if (ip1(1).eq.0) then
        write(0,'(a,a,i3,a)') __FILE__, ':', __LINE__, ': On SR16000 with MATRIX/MPP, NX must be even.'
        stop 4
     end if
     ndim1 = 2*(Nx/2+1)
     ipara = $NUMTHRD()
     write(0,'(a,i8)') 'fft.F: ipara = ', ipara
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

  if (mode) then
     call HDFZ7M(r, ndim1,Ny, Nx,Ny,Nz, ip1,ip2,ip3, iopt,tb1,tb2,tb3,  wk1,wk2, NWKW,ipara, ier)
  else
     call HZFD7M(r, ndim1,Ny, Nx,Ny,Nz, ip1,ip2,ip3, iopt,tb1,tb2,tb3,  wk1,wk2, NWKW,ipara, ier)
  end if

  deallocate(wk1,wk2)
end subroutine fft_3d_r2c_or_c2r_in_place

subroutine fft_3d_r2c_or_c2r_out_of_place(mode, Nx, Ny, Nz, r, c)
  implicit none
  logical,   intent(in) :: mode
  integer,   intent(in) :: Nx, Ny, Nz
  real*8, intent(inout) :: r(0:Nx-1, 0:Ny-1, 0:Nz-1)
  real*8, intent(inout) :: c(0:2*(Nx/2+1)-1, 0:Ny-1, 0:Nz-1)
  ! cf complex*16       :: c(0:Nx/2, 0:Ny-1, 0:Nz-1) !CAUTION "/2"!
  integer,   save       :: Nx_last=0, Ny_last=0, Nz_last=0
  integer,   save       :: ip1(3), ip2(3), ip3(3), ndim1, nwk1, nwk2, ipara
  integer               :: iopt(2)
  integer,   parameter  :: NWKW  = 5
  complex*16,save       :: tb1(2048), tb2(2048), tb3(2048)
  complex*16,allocatable:: wk1(:), wk2(:)
  integer               :: ier, ix, iy, iz

  if (mode) then
     iopt(1)=1
  else
     iopt(1)=2
  end if

  if (Nx.ne.Nx_last .or. Ny.ne.Ny_last .or. Nz.ne.Nz_last) then
     call n2pqr(Nx, ip1)
     call n2pqr(Ny, ip2)
     call n2pqr(Nz, ip3)
     if (ip1(1).eq.0) then
        write(0,'(a,a,i3,a)') __FILE__, ':', __LINE__, ': On SR16000 with MATRIX/MPP, NX must be even.'
        stop 4
     end if
     ndim1 = 2*(Nx/2+1)
     ipara = $NUMTHRD()
     write(0,'(a,i8)') 'fft.F: ipara = ', ipara
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

  if (mode) then
     do iz = 0, Nz-1
        do iy = 0, Ny-1
           do ix = 0, Nx-1
              c(ix,iy,iz) = r(ix,iy,iz)
           end do
        end do
     end do
     call HDFZ7M(c, ndim1,Ny, Nx,Ny,Nz, ip1,ip2,ip3, iopt,tb1,tb2,tb3,  wk1,wk2, NWKW,ipara, ier)
  else
     call HZFD7M(c, ndim1,Ny, Nx,Ny,Nz, ip1,ip2,ip3, iopt,tb1,tb2,tb3,  wk1,wk2, NWKW,ipara, ier)
     do iz = 0, Nz-1
        do iy = 0, Ny-1
           do ix = 0, Nx-1
              r(ix,iy,iz) =  c(ix,iy,iz)
           end do
        end do
     end do
  end if

  deallocate(wk1,wk2)
end subroutine fft_3d_r2c_or_c2r_out_of_place

subroutine fft_3d_fwd_or_bkd(mode, Nx, Ny, Nz, a)
  implicit none
  logical,   intent(in) :: mode
  integer,   intent(in) :: Nx, Ny, Nz
  integer,   save       :: Nx_last=0, Ny_last=0, Nz_last=0
  complex*16            :: a(0:Nx-1, 0:Ny-1, 0:Nz-1)
  integer,   save       :: ip1(3), ip2(3), ip3(3), nwk
  integer               :: iopt(2)
  integer,   parameter  :: NWKW = 5
  complex*16,save       :: tb1(2048), tb2(2048), tb3(2048)
  complex*16,allocatable:: wk(:)
  integer               :: ier

  if (mode) then
     iopt(1)=1
  else
     iopt(1)=2
  end if

  if (Nx.ne.Nx_last .or. Ny.ne.Ny_last .or. Nz.ne.Nz_last) then
     call n2pqr(Nx, ip1)
     call n2pqr(Ny, ip2)
     call n2pqr(Nz, ip3)
     nwk = max((Nx+NWKW)*Ny*Nz,Nx*(Ny+NWKW)*Nz) + 100
     iopt(2)=1
     Nx_last=Nx
     Ny_last=Ny
     Nz_last=Nz
  else
     iopt(2)=2
  end if

  allocate(wk(nwk))

  call HZFT7M(a, Nx,Ny, Nx,Ny,Nz, ip1,ip2,ip3, iopt,tb1,tb2,tb3, wk,NWKW, ier)

  deallocate(wk)
end subroutine fft_3d_fwd_or_bkd
#endif
!

#if defined(__sparc)
!        Nx          8   9
!        Nx/2        4   4
!    c(0:Nx/2)      10  10
!     2*(Nx/2+1)-1   9   9
! r(0:2*(Nx/2+1)-1) 10  10
subroutine fft_3d_r2c_or_c2r_out_of_place(mode, Nx, Ny, Nz, r, c)
  implicit none
  logical,   intent(in)    :: mode
  integer,   intent(in)    :: Nx, Ny, Nz
  real*8,    intent(inout) :: r(0:Nx-1, 0:Ny-1, 0:Nz-1)
! complex*16,intent(out)   :: c(0:Nx/2,         0:Ny-1, 0:Nz-1) !CAUTION "/2"!
  real*8,    intent(inout) :: c(0:2*(Nx/2+1)-1, 0:Ny-1, 0:Nz-1)
  integer ix, iy, iz, icon

  if (mode) then
     do iz = 0, Nz-1
        do iy = 0, Ny-1
           do ix = 0, Nx-1
              c(ix,iy,iz) = r(ix,iy,iz)
           end do
        end do
     end do
     call DM_V3DRCF(c, 2*(Nx/2+1), Nx, Ny, Nz, 1,  1, ICON)
  else
     call DM_V3DRCF(c, 2*(Nx/2+1), Nx, Ny, Nz, 1, -1, ICON)
     do iz = 0, Nz-1
        do iy = 0, Ny-1
           do ix = 0, Nx-1
              r(ix,iy,iz) =  c(ix,iy,iz)
           end do
        end do
     end do
  end if
end subroutine fft_3d_r2c_or_c2r_out_of_place

subroutine fft_3d_fwd_or_bkd(mode, Nx, Ny, Nz, a)
  implicit none
  logical,   intent(in) :: mode
  integer,   intent(in) :: Nx, Ny, Nz
  complex*16            :: a(0:Nx-1, 0:Ny-1, 0:Nz-1)
  integer               :: isn
  integer               :: icon

  if (mode) then
     isn=1
  else
     isn=-1
  end if

  call DM_V3DCFT(a, Nx, Nx,Ny,Nz, isn, ICON)
end subroutine fft_3d_fwd_or_bkd
#endif
