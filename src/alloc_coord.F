! alloc_coord.F -*-f90-*-
! Time-stamp: <2015-03-27 15:37:06 t-nissie>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif

#include "define.h"

subroutine alloc_Coord(p,c)
  use, intrinsic :: iso_c_binding
  use Param_module
  use Coord_module
  implicit none
  type(Param_type), intent(in)    :: p
  type(Coord_type), intent(inout) :: c
#if defined(HAVE_LIBFFTW3)
  include 'fftw3.f03'
  integer howmany,stride
  integer, parameter :: rank=3
  integer, parameter :: dist=1
  integer  LzLyLx(3)
  integer d_embed(3)
  integer z_embed(3)
  LzLyLx( 1)=p%Lz; LzLyLx( 2)=p%Ly; LzLyLx( 3)=p%Lx    ! p%padding_y will be introduced.
  d_embed(1)=p%Lz; d_embed(2)=p%Ly; d_embed(3)=p%Lx    ! Not 2*(Lx/2+1), so far.
  z_embed(1)=p%Lz; z_embed(2)=p%Ly; z_embed(3)=p%Lx/2+1
#endif
  call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'alloc_Coord().')
  !--- m_inv ------------------------------
  if (allocated(c%m_inv)) deallocate(c%m_inv)
  allocate(c%m_inv(3, 0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1))
  !--- dipo -------------------------------
  if (allocated(c%dipoR)) deallocate(c%dipoR)
  allocate(     c%dipoR(3, 0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1))
  if (allocated(c%dipoK)) deallocate(c%dipoK)
  allocate(     c%dipoK(3, 0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1)) !"/2" for real<->complex FFT
!!!first touch
  !$omp parallel
     c%dipoR(:,:,:,:) = 0.0d0
  !$omp end parallel
  !$omp parallel
     c%dipoK(:,:,:,:) = (0.0d0,0.0d0)
  !$omp end parallel
#   if defined(HAVE_LIBFFTW3)
  howmany = 3
  stride = howmany
  c%plan_dipoR2C = fftw_plan_many_dft_r2c(rank,LzLyLx,howmany,&
       &                                  c%dipoR,d_embed,stride,dist,&
       &                                  c%dipoK,z_embed,stride,dist,FFTW_MEASURE)
#   endif
  if (allocated(c%dipoP)) deallocate(c%dipoP)
  allocate(     c%dipoP(3, 0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1))
  if (allocated(c%dVddi)) deallocate(c%dVddi)
  allocate(     c%dVddi(3, 0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1))
  if (allocated(c%dipoT)) deallocate(c%dipoT)
  allocate(     c%dipoT(3, 0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1))
!!!first touch
  !$omp parallel
     c%dVddi(:,:,:,:) = 0.0d0
  !$omp end parallel
  !$omp parallel
     c%dipoT(:,:,:,:) = (0.0d0,0.0d0)
  !$omp end parallel

  if (allocated(c%E_field)) deallocate(c%E_field)
  allocate(     c%E_field(3, 0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1))
!!!first touch
  !$omp parallel
     c%E_field(:,:,:,:) = 0.0d0
  !$omp end parallel

  if (allocated(c%E_field_local)) deallocate(c%E_field_local)
  allocate(     c%E_field_local(3, 0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1))
!!!first touch
  !$omp parallel
     c%E_field_local(:,:,:,:) = 0.0d0
  !$omp end parallel

  if (allocated(c%dipoI)) deallocate(c%dipoI)
  allocate(     c%dipoI(3, 3, 0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1)) !"/2" for real<->complex FFT

  if (allocated(c%didiR)) deallocate(c%didiR)
  allocate(     c%didiR(6, 0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1))
  if (allocated(c%didiK)) deallocate(c%didiK)
  allocate(     c%didiK(6, 0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1))    !"/2" for real<->complex FFT
!!!first touch
  !$omp parallel
     c%didiR(:,:,:,:) = 0.0d0
  !$omp end parallel
  !$omp parallel
     c%didiK(:,:,:,:) = (0.0d0,0.0d0)
  !$omp end parallel
#   if defined(HAVE_LIBFFTW3)
  howmany = 6
  stride = howmany
  c%plan_didiR2C = fftw_plan_many_dft_r2c(rank,LzLyLx,howmany,&
       &                                  c%didiR,d_embed,stride,dist,&
       &                                  c%didiK,z_embed,stride,dist,FFTW_MEASURE)
#   endif

  !--- acou -------------------------------
  if (allocated(c%acouR)) deallocate(c%acouR)
  allocate(c%acouR(3, 0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1))
  if (allocated(c%acouK)) deallocate(c%acouK)
  allocate(c%acouK(3, 0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1))
  if (allocated(c%acouP)) deallocate(c%acouP)
  allocate(c%acouP(3, 0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1))
!!!first touch
  !$omp parallel
     c%acouR(:,:,:,:) = 0.0d0
  !$omp end parallel
  !$omp parallel
     c%acouK(:,:,:,:) = (0.0d0,0.0d0)
  !$omp end parallel
  !$omp parallel
     c%acouP(:,:,:,:) = 0.0d0
  !$omp end parallel
#   if defined(HAVE_LIBFFTW3)
  howmany = 3
  stride = howmany
  c%plan_acouC2R = fftw_plan_many_dft_c2r(rank,LzLyLx,howmany,&
       &                                  c%acouK,z_embed,stride,dist,&
       &                                  c%acouR,d_embed,stride,dist,FFTW_MEASURE)
#   endif

  !--- force on acoustic displacement --------
  if (allocated(c%dVdacR)) deallocate(c%dVdacR)
  allocate(c%dVdacR(3, 0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1))
  if (allocated(c%dVdacK)) deallocate(c%dVdacK)
  allocate(c%dVdacK(3, 0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1))
!!!first touch
  !$omp parallel
     c%dVdacR(:,:,:,:) = 0.0d0
  !$omp end parallel
  !$omp parallel
     c%dVdacK(:,:,:,:) = (0.0d0,0.0d0)
  !$omp end parallel

  !--- inhomogeneous strain ---------------
  if (allocated(c%inhoR)) deallocate(c%inhoR)
  allocate(c%inhoR(6, 0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1))
  if (allocated(c%inhoK)) deallocate(c%inhoK)
  allocate(c%inhoK(6, 0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1))
!!!first touch
  !$omp parallel
     c%inhoR(:,:,:,:) = 0.0d0
  !$omp end parallel
  !$omp parallel
     c%inhoK(:,:,:,:) = (0.0d0,0.0d0)
  !$omp end parallel
#   if defined(HAVE_LIBFFTW3)
  howmany = 6
  stride = howmany
  c%plan_inhoC2R = fftw_plan_many_dft_c2r(rank,LzLyLx,howmany,&
       &                                  c%inhoK,z_embed,stride,dist,&
       &                                  c%inhoR,d_embed,stride,dist,FFTW_MEASURE)
#   endif

  if (allocated(c%inhomo_K)) deallocate(c%inhomo_K)
  allocate(     c%inhomo_K(3,3, 0:p%Lx/2,0:p%Ly-1,0:p%Lz-1))

  if (allocated(c%inhomo_K_G)) deallocate(c%inhomo_K_G)
  allocate(     c%inhomo_K_G(3,4, 0:p%Lx/2,0:p%Ly-1,0:p%Lz-1))

  if (allocated(c%inhomo_coup2_K)) deallocate(c%inhomo_coup2_K)
  allocate(c%inhomo_coup2_K(3,6, 0:p%Lx/2,0:p%Ly-1  ,0:p%Lz-1))

  !$omp parallel
     c%inhomo_coup2_K(:,:, :,:,:) = 0.0d0
  !$omp end parallel

  !--- sum_p ------------------------------
  if (allocated(c%sum_p)) deallocate(c%sum_p)
  allocate(c%sum_p(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1))
  !--- e_layer_dipo and e_layer_and for thermal conductivity----
  if (allocated(c%e_layer_dipo)) deallocate(c%e_layer_dipo)
  allocate(c%e_layer_dipo(0:p%Lz-1))
  if (allocated(c%e_layer_acou)) deallocate(c%e_layer_acou)
  allocate(c%e_layer_acou(0:p%Lz-1))
  !--- end --------------------------------
  call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '  alloc_Coord().')
end subroutine alloc_Coord
