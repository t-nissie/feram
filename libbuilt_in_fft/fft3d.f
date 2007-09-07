! fft3d.f -*-f90-*-
! Time-stamp: <2007-06-05 17:14:57 t-nissie>
! Author: Takeshi NISHIMATSU
! Reference2: Akira Nukada: FFTSS
!             http://ssi.is.s.u-tokyo.ac.jp/fftss/index.html.en
!             http://ssi.is.s.u-tokyo.ac.jp/CREST_2nd_symposium/FFTSS.pdf
!
! CAUTION!!!: fft3d(.false., Nx,Ny,Nz, r, c) alters c.
!!
subroutine fft3d(mode, Nx,Ny,Nz, r, c)
  implicit none
  logical,    intent(in)    :: mode   ! .true. - forward, .false. - inverse
  integer,    intent(in)    :: Nx,Ny,Nz
  real*8     :: r(0:Nx-1, 0:Ny-1, 0:Nz-1)
  complex*16 :: c(0:Nx/2, 0:Ny-1, 0:Nz-1) !CAUTION "/2"!

  integer ix,iy,iz, Nx2,Nx2_1,Nx2_1_Ny
  complex*16 :: tmp(0:1024)

  Nx2 = Nx/2
  Nx2_1 = Nx2+1
  Nx2_1_Ny = Nx2_1*Ny

  if (mode) then
     !$omp parallel do private(ix,iy,tmp)
     do iz = 0, Nz-1
        do iy = 0, Ny-1
           tmp(0:Nx-1) = r(0:Nx-1,iy,iz)
           call fft1d(mode, Nx, tmp, 1)
           c(0:Nx2,iy,iz) = tmp(0:Nx2)
        end do
        do ix = 0, Nx2                                                              !!
           call fft1d(mode, Ny, c(ix,0,iz), Nx2_1)                                  !!
        end do                                                                      !!
     end do
     !$omp end parallel do
     !$omp parallel do private(ix,tmp)                                                 !
     do iy = 0, Ny-1                                                                   !
        do ix = 0, Nx2                                                                 !
           call fft1d(mode, Nz, c(ix,iy,0), Nx2_1_Ny)                                  !
        end do                                                                         !
     end do                                                                            !
     !$omp end parallel do                                                             !
  else
     !$omp parallel do private(ix,tmp)                                                 !
     do iy = 0, Ny-1                                                                   !
        do ix = 0, Nx2                                                                 !
           call fft1d(mode, Nz, c(ix,iy,0), Nx2_1_Ny)                                  !
        end do                                                                         !
     end do                                                                            !
     !$omp end parallel do                                                             !
     !$omp parallel do private(ix,iz,tmp)
     do iz = 0, Nz-1
        do ix = 0, Nx2                                                              !!
           call fft1d(mode, Ny, c(ix,0,iz), Nx2_1)                                  !!
        end do                                                                      !!
        do iy = 0, Ny-1
           do ix = 0,Nx2
              tmp(ix)    = c(ix,iy,iz)
              tmp(Nx-ix) = conjg(c(ix,iy,iz))   ! tmp(Nx) is no problem.
           end do
           call fft1d(mode, Nx, tmp, 1)
           r(0:Nx-1,iy,iz) = dble(tmp(0:Nx-1))
        end do
     end do
     !$omp end parallel do
  end if
end subroutine fft3d
