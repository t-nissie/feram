! coord_module.F -*-f90-*-
! Time-stamp: <2015-07-07 16:13:10 takeshi>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif

#include "define.h"

module Coord_module
  use, intrinsic :: iso_c_binding
  implicit none
  type Coord_type
     real*8,     allocatable :: m_inv(:,:,:,:)   ! inverse of mass
     real*8,     allocatable :: dipoR(:,:,:,:)   ! Optical dipole displacements as a function of R
     complex*16, allocatable :: dipoK(:,:,:,:)   ! FT of dipoQ
     real*8,     allocatable :: dipoP(:,:,:,:)   ! Momenta
     real*8,     allocatable :: dVddi(:,:,:,:)   ! dV/dq for dipole
     complex*16, allocatable :: dipoT(:,:,:,:)   ! Only used in dVddi_dipole_dipole.F
     real*8,     allocatable :: E_field(:,:,:,:) ! external and local electric field
     real*8,     allocatable :: E_field_local(:,:,:,:) ! initial external electric field
     real*8,     allocatable :: dipoI(:,:,:,:,:) ! Fourier transformed potential  !!!REAL*8!!!
     real*8,     allocatable :: didiR(:,:,:,:)   ! 6 kind of dipoR*dipoR
     complex*16, allocatable :: didiK(:,:,:,:)   ! 6 kind of dipoR*dipoR
     real*8,     allocatable :: acouR(:,:,:,:)   ! Acoustic displacements in real space
     complex*16, allocatable :: acouK(:,:,:,:)   ! Acoustic displacements
     real*8,     allocatable :: acouP(:,:,:,:)
     real*8,     allocatable :: dVdacR(:,:,:,:)
     complex*16, allocatable :: dVdacK(:,:,:,:)
     real*8,     allocatable :: inhomo_K(  :,:, :,:,:)     ! FTed potential. See cholesky_d.f in https://gist.github.com/t-nissie/6386f1acc19cd38af621 .
     real*8,     allocatable :: inhomo_K_G(:,:, :,:,:)     ! inhomo_K = G tG, where G is a lower triangular matrix and tG is transpose of G. G(i,4) = 1/G(i,i).
     real*8,     allocatable :: inhomo_coup2_K(:,:, :,:,:) ! FTed potential
     logical,    allocatable :: sum_p(:,:,:) ! .true. if the u(R) is not defect nor mirrored film. This array will be initialized in read_defects_u.F
     real*8,     allocatable :: e_layer_dipo(:)
     real*8,     allocatable :: e_layer_acou(:)
     integer,    allocatable :: n_sum_layer(:)
     real*8                 strain(6)
     real*8                 homogeneous(6,6)
     real*8                 homogeneous_G(6,6)
     real*8                 homogeneous_G_inv(6)
     real*8                 homogeneous_coupling_2(6,6)
     real*8                 s_Nose, pi_Nose, H0! for Nose-Poincare Thermostat
     integer                n_sum_p
     type(C_PTR) ::         inho_ptr = c_null_ptr
     ! These plans are odered as in feram_fftw_wisdom.F.
     type(C_PTR) ::         plan_c2r_6_in  = c_null_ptr   ! inhoK->inhoR (dVddi_inho_coupling.F)
     type(C_PTR) ::         plan_r2c_3_out = c_null_ptr   ! dipoR->dipoK (dipoFFT.F), acouR->acouK (acouFFT.F)
     type(C_PTR) ::         plan_c2r_3_out = c_null_ptr   ! dVdacK->dVdacR (dVdac.F), dipoT->dVddi (dVddi-dipole-dipole.F)
                                                          ! acouK->acouR (write_system(). It is not crucial for seed.)
     type(C_PTR) ::         plan_r2c_6_out = c_null_ptr   ! didiR->didiK (dipoFFT.F)
  end type Coord_type

contains
  subroutine alloc_Coord(p,c)
    use, intrinsic :: iso_c_binding
    use Param_module
    implicit none
    type(Param_type), intent(in)    :: p
    type(Coord_type), intent(inout) :: c
    integer iz

    include 'fftw3.f03'
    integer howmany,stride
    integer, parameter :: rank=3
    integer, parameter :: dist=1
    integer  LzLyLx(3)
    integer d_embed(3)
    integer z_embed(3)

    integer(C_SIZE_T) :: n_alloc_inho
    complex*16,pointer :: inhoK(:,:,:,:)
    real*8,    pointer :: inhoR(:,:,:,:)

    LzLyLx( 1)=p%Lz; LzLyLx( 2)=p%Ly; LzLyLx( 3)=p%Lx    ! p%padding_y will be introduced.
    d_embed(1)=p%Lz; d_embed(2)=p%Ly+p%padding_y; d_embed(3)=2*(p%Lx/2+1)
    z_embed(1)=p%Lz; z_embed(2)=p%Ly+p%padding_y; z_embed(3)=p%Lx/2+1
    call fftw_destroy_plan(c%plan_r2c_3_out)
    call fftw_destroy_plan(c%plan_r2c_6_out)   ! It is safe to destroy c_null_ptr.
    call fftw_destroy_plan(c%plan_c2r_6_in )   ! See fftw3/api/apiplan.c.
    call fftw_destroy_plan(c%plan_c2r_3_out)

    call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'alloc_Coord().')
    !--- m_inv ------------------------------
    if (allocated(c%m_inv)) deallocate(c%m_inv)
    allocate(c%m_inv(3, 0:2*(p%Lx/2+1)-1, 0:p%Ly+p%padding_y-1, 0:p%Lz-1))
  !!!first touch
!$omp parallel do
    do iz = 0,p%Lz-1
       c%m_inv(:,:,:,iz) = 0.0d0
    end do
!$omp end parallel do
    !--- dipo -------------------------------
    if (allocated(c%dipoR)) deallocate(c%dipoR)
    allocate(     c%dipoR(3, 0:2*(p%Lx/2+1)-1, 0:p%Ly+p%padding_y-1, 0:p%Lz-1))
    if (allocated(c%dipoK)) deallocate(c%dipoK)
    allocate(     c%dipoK(3, 0:p%Lx/2, 0:p%Ly+p%padding_y-1, 0:p%Lz-1)) !"/2" for real<->complex FFT
  !!!first touch
!$omp parallel do
    do iz = 0,p%Lz-1
       c%dipoR(:,:,:,iz) = 0.0d0
    end do
!$omp end parallel do
!$omp parallel do
    do iz = 0,p%Lz-1
       c%dipoK(:,:,:,iz) = (0.0d0,0.0d0)
    end do
!$omp end parallel do
    howmany = 3
    stride = howmany
    c%plan_r2c_3_out = fftw_plan_many_dft_r2c(rank,LzLyLx,howmany,&
         &                                  c%dipoR,d_embed,stride,dist,&
         &                                  c%dipoK,z_embed,stride,dist,FFTW_MEASURE)

    if (allocated(c%dipoP)) deallocate(c%dipoP)
    allocate(     c%dipoP(3, 0:2*(p%Lx/2+1)-1, 0:p%Ly+p%padding_y-1, 0:p%Lz-1))
    if (allocated(c%dVddi)) deallocate(c%dVddi)
    allocate(     c%dVddi(3, 0:2*(p%Lx/2+1)-1, 0:p%Ly+p%padding_y-1, 0:p%Lz-1))
    if (allocated(c%dipoT)) deallocate(c%dipoT)
    allocate(     c%dipoT(3, 0:p%Lx/2, 0:p%Ly+p%padding_y-1, 0:p%Lz-1))
  !!!first touch
!$omp parallel do
    do iz = 0,p%Lz-1
       c%dVddi(:,:,:,iz) = 0.0d0
    end do
!$omp end parallel do
!$omp parallel do
    do iz = 0,p%Lz-1
       c%dipoT(:,:,:,iz) = (0.0d0,0.0d0)
    end do
!$omp end parallel do

    if (allocated(c%E_field)) deallocate(c%E_field)
    allocate(     c%E_field(3, 0:2*(p%Lx/2+1)-1, 0:p%Ly+p%padding_y-1, 0:p%Lz-1))
  !!!first touch
!$omp parallel do
    do iz = 0,p%Lz-1
       c%E_field(:,:,:,iz) = 0.0d0
    end do
!$omp end parallel do

    if (allocated(c%E_field_local)) deallocate(c%E_field_local)
    allocate(     c%E_field_local(3, 0:2*(p%Lx/2+1)-1, 0:p%Ly+p%padding_y-1, 0:p%Lz-1))
  !!!first touch
!$omp parallel do
    do iz = 0,p%Lz-1
       c%E_field_local(:,:,:,iz) = 0.0d0
    end do
!$omp end parallel do

    if (allocated(c%dipoI)) deallocate(c%dipoI)
    allocate(     c%dipoI(3, 3, 0:p%Lx/2, 0:p%Ly+p%padding_y-1, 0:p%Lz-1)) !"/2" for real<->complex FFT
  !!!first touch
!$omp parallel do
    do iz = 0,p%Lz-1
       c%dipoI(:,:, :,:,iz) = 0.0d0
    end do
!$omp end parallel do

    if (allocated(c%didiR)) deallocate(c%didiR)
    allocate(     c%didiR(6, 0:2*(p%Lx/2+1)-1, 0:p%Ly+p%padding_y-1, 0:p%Lz-1))
    if (allocated(c%didiK)) deallocate(c%didiK)
    allocate(     c%didiK(6, 0:p%Lx/2, 0:p%Ly+p%padding_y-1, 0:p%Lz-1))    !"/2" for real<->complex FFT
  !!!first touch
!$omp parallel do
    do iz = 0,p%Lz-1
       c%didiR(:,:,:,iz) = 0.0d0
    end do
!$omp end parallel do
!$omp parallel do
    do iz = 0,p%Lz-1
       c%didiK(:,:,:,iz) = (0.0d0,0.0d0)
    end do
!$omp end parallel do
    howmany = 6
    stride = howmany
    c%plan_r2c_6_out = fftw_plan_many_dft_r2c(rank,LzLyLx,howmany,&
         &                                  c%didiR,d_embed,stride,dist,&
         &                                  c%didiK,z_embed,stride,dist,FFTW_MEASURE)

    !--- acou -------------------------------
    if (allocated(c%acouR)) deallocate(c%acouR)
    allocate(c%acouR(3, 0:2*(p%Lx/2+1)-1, 0:p%Ly+p%padding_y-1, 0:p%Lz-1))
    if (allocated(c%acouK)) deallocate(c%acouK)
    allocate(c%acouK(3, 0:p%Lx/2, 0:p%Ly+p%padding_y-1, 0:p%Lz-1))
    if (allocated(c%acouP)) deallocate(c%acouP)
    allocate(c%acouP(3, 0:2*(p%Lx/2+1)-1, 0:p%Ly+p%padding_y-1, 0:p%Lz-1))
  !!!first touch
!$omp parallel do
    do iz = 0,p%Lz-1
       c%acouR(:,:,:,iz) = 0.0d0
    end do
!$omp end parallel do
!$omp parallel do
    do iz = 0,p%Lz-1
       c%acouK(:,:,:,iz) = (0.0d0,0.0d0)
    end do
!$omp end parallel do
!$omp parallel do
    do iz = 0,p%Lz-1
       c%acouP(:,:,:,iz) = 0.0d0
    end do
!$omp end parallel do
    howmany = 3
    stride = howmany
    c%plan_c2r_3_out = fftw_plan_many_dft_c2r(rank,LzLyLx,howmany,&
         &                                  c%acouK,z_embed,stride,dist,&
         &                                  c%acouR,d_embed,stride,dist,FFTW_MEASURE)

    !--- force on acoustic displacement --------
    if (allocated(c%dVdacR)) deallocate(c%dVdacR)
    allocate(c%dVdacR(3, 0:2*(p%Lx/2+1)-1, 0:p%Ly+p%padding_y-1, 0:p%Lz-1))
    if (allocated(c%dVdacK)) deallocate(c%dVdacK)
    allocate(c%dVdacK(3, 0:p%Lx/2, 0:p%Ly+p%padding_y-1, 0:p%Lz-1))
  !!!first touch
!$omp parallel do
    do iz = 0,p%Lz-1
       c%dVdacR(:,:,:,iz) = 0.0d0
    end do
!$omp end parallel do
!$omp parallel do
    do iz = 0,p%Lz-1
       c%dVdacK(:,:,:,iz) = (0.0d0,0.0d0)
    end do
!$omp end parallel do

    !--- inhomogeneous strain ---------------
    howmany = 6
    if (c_associated(c%inho_ptr)) call fftw_free(c%inho_ptr)
    n_alloc_inho = howmany * (p%Lx/2+1) * (p%Ly+p%padding_y) * p%Lz
    c%inho_ptr = fftw_alloc_complex(n_alloc_inho)
    call c_f_pointer(c%inho_ptr, inhoK, [howmany,   (p%Lx/2+1), p%Ly+p%padding_y, p%Lz])
    call c_f_pointer(c%inho_ptr, inhoR, [howmany, 2*(p%Lx/2+1), p%Ly+p%padding_y, p%Lz])
!!!first touch!!! Here, indexes of arrays do not have to start from 0. It is simpler than dVddi_inho_coupling.F.
!$omp parallel do
    do iz = 1, p%Lz
       inhoK(:,:,:,iz) = (0.0d0,0.0d0)
    end do
!$omp end parallel do
    stride = howmany
    c%plan_c2r_6_in = fftw_plan_many_dft_c2r(rank,LzLyLx,howmany,&
         &                                   inhoK,z_embed,stride,dist,&
         &                                   inhoR,d_embed,stride,dist,FFTW_MEASURE)

    if (allocated(c%inhomo_K)) deallocate(c%inhomo_K)
    allocate(     c%inhomo_K(3,3, 0:p%Lx/2,0:p%Ly+p%padding_y-1,0:p%Lz-1))

    if (allocated(c%inhomo_K_G)) deallocate(c%inhomo_K_G)
    allocate(     c%inhomo_K_G(3,4, 0:p%Lx/2,0:p%Ly+p%padding_y-1,0:p%Lz-1))

    if (allocated(c%inhomo_coup2_K)) deallocate(c%inhomo_coup2_K)
    allocate(c%inhomo_coup2_K(3,6, 0:p%Lx/2,0:p%Ly+p%padding_y-1  ,0:p%Lz-1))

  !!!first touch
!$omp parallel do
    do iz = 0,p%Lz-1
       c%inhomo_K(:,:, :,:,iz) = 0.0d0
    end do
!$omp end parallel do
!$omp parallel do
    do iz = 0,p%Lz-1
       c%inhomo_K_G(:,:, :,:,iz) = 0.0d0
    end do
!$omp end parallel do
!$omp parallel do
    do iz = 0,p%Lz-1
       c%inhomo_coup2_K(:,:, :,:,iz) = 0.0d0
    end do
!$omp end parallel do

    !--- sum_p ------------------------------
    if (allocated(c%sum_p)) deallocate(c%sum_p)
    allocate(c%sum_p(0:2*(p%Lx/2+1)-1, 0:p%Ly+p%padding_y-1, 0:p%Lz-1))
  !!!first touch
!$omp parallel do
    do iz = 0,p%Lz-1
       c%sum_p(:,:,iz) = .false.
    end do
!$omp end parallel do

    !--- e_layer_dipo and e_layer_and for thermal conductivity----
    if (allocated(c%e_layer_dipo)) deallocate(c%e_layer_dipo)
    allocate(c%e_layer_dipo(0:p%Lz-1))
    if (allocated(c%e_layer_acou)) deallocate(c%e_layer_acou)
    allocate(c%e_layer_acou(0:p%Lz-1))
    if (allocated(c%n_sum_layer)) deallocate(c%n_sum_layer)
    allocate(c%n_sum_layer(0:p%Lz-1))
  !!!first touch
!$omp parallel do
    do iz = 0,p%Lz-1
       c%e_layer_dipo(iz) = 0.0d0
       c%e_layer_acou(iz) = 0.0d0
       c%n_sum_layer( iz) = p%Lx * p%Ly
    end do
!$omp end parallel do
    !--- end --------------------------------
    call msg(UNIT_LOG, __FILE__, __LINE__, 'END', 'alloc_Coord().')
  end subroutine alloc_Coord

  subroutine write_fft(p,c,fn)
    use Param_module
    implicit none
    type(Param_type), intent(in) :: p
    type(Coord_type), intent(in) :: c
    character(len=*) :: fn
    integer ix,iy,yy

    call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', '')
    open(unit=UNIT_SYSTEM,file=fn)
    do iy= -p%Ly/2, p%Ly/2
       if (iy<0) then
          yy=p%Ly+iy
       else
          yy=iy
       end if
       do ix=0, p%Lx/2
          write(UNIT_SYSTEM,*) abs(c%dipoK(3,ix,yy,0)), c%dipoK(3,ix,yy,0)
       end do
       write(UNIT_SYSTEM,*) ''
    end do
    close(UNIT_SYSTEM)
    call msg(UNIT_LOG, __FILE__, __LINE__, 'FILENAME', fn)
    call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '')
  end subroutine write_fft
end module Coord_module
