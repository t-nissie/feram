! fft_3d_3x3upper_r2c.F -*-f90-*-
! Time-stamp: <2012-05-02 17:47:58 t-nissie>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
#include "define.h"

subroutine fft_3d_3x3upper_r2c(p,r,c)
  use Param_module
  implicit none
  type(Param_type) :: p
  real*8     :: r(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 3, 3)
  complex*16 :: c(0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1, 3, 3) !CAUTION "/2"!
  integer alpha, beta
#if defined(HAVE_LIBFFTW3)
  integer ip
  integer*8 plan(6)
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
#elif defined(HAVE_LIBACML_MP)
  integer info
  real*8 comm(4*p%Lx+6*p%Ly+6*p%Lz+500)
  do beta = 1, 3
     do alpha = 1, beta
        call DZFFT3D(2, p%Lx, p%Ly, p%Lz, &
             & r(0,0,0,alpha,beta), c(0,0,0,alpha,beta), comm, info)
     end do
  end do
#else
  do beta = 1, 3
     do alpha = 1, beta
        call fft_3d(.true., p%Lx, p%Ly, p%Lz, &
             & r(0,0,0,alpha,beta), c(0,0,0,alpha,beta))
     end do
  end do
#endif
  c(:,:,:,2,1) = conjg(c(:,:,:,1,2))
  c(:,:,:,3,1) = conjg(c(:,:,:,1,3))
  c(:,:,:,3,2) = conjg(c(:,:,:,2,3))
end subroutine fft_3d_3x3upper_r2c
