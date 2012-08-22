! coord_module.F -*-f90-*-
! Time-stamp: <2012-08-22 12:41:47 takeshi>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif

#include "define.h"

module Coord_module
  implicit none
  type Coord_type
#  if defined(HITACHI_SR)
#    define allocated associated
     real*8,     pointer     :: m_inv(:,:,:,:)   => null()
     real*8,     pointer     :: dipoR(:,:,:,:)   => null()
     complex*16, pointer     :: dipoK(:,:,:,:)   => null()
     real*8,     pointer     :: dipoP(:,:,:,:)   => null()
     real*8,     pointer     :: dVddi(:,:,:,:)   => null()
     complex*16, pointer     :: dipoT(:,:,:,:)   => null()
     real*8,     pointer     :: E_field(:,:,:,:) => null()
     real*8,     pointer     :: dipoI(:,:,:,:,:) => null()
     real*8,     pointer     :: didiR(:,:,:,:)   => null()
     complex*16, pointer     :: didiK(:,:,:,:)   => null()
    !real*8,     pointer     :: acouR(:,:,:,:)   => null()
     real*8,     pointer     :: inhoR(:,:,:,:)   => null()
     complex*16, pointer     :: inhoK(:,:,:,:)   => null()
     real*8,     pointer     :: inhomo_K(:,:,:, :,:)       => null()
     real*8,     pointer     :: inhomo_K_G(:,:, :,:,:)     => null()
     real*8,     pointer     :: inhomo_K_G_inv(:, :,:,:)   => null()
     real*8,     pointer     :: inhomo_coup2_K(:,:,:, :,:) => null()
     logical,    pointer     :: sum_p(:,:,:) => null()
     real*8,     pointer     :: e_layer(:)
#  else
     real*8,     allocatable :: m_inv(:,:,:,:)   ! inverse of mass
     real*8,     allocatable :: dipoR(:,:,:,:)   ! Optical dipole displacements as a function of R
     complex*16, allocatable :: dipoK(:,:,:,:)   ! FT of dipoQ
     real*8,     allocatable :: dipoP(:,:,:,:)   ! Momenta
     real*8,     allocatable :: dVddi(:,:,:,:)   ! dV/dq for dipole
     complex*16, allocatable :: dipoT(:,:,:,:)   ! Only used in dVddi_dipole_dipole.F
     real*8,     allocatable :: E_field(:,:,:,:) ! external and local electric field
     real*8,     allocatable :: dipoI(:,:,:,:,:) ! Fourier transformed potential  !!!REAL*8!!!
     real*8,     allocatable :: didiR(:,:,:,:)   ! 6 kind of dipoR*dipoR
     complex*16, allocatable :: didiK(:,:,:,:)   ! 6 kind of dipoR*dipoR
    !real*8,     allocatable :: acouR(:,:,:,:)   ! Acoustic displacements in real space
     real*8,     allocatable :: inhoR(:,:,:,:)   ! Only used in optimize-inho-strain.F
     complex*16, allocatable :: inhoK(:,:,:,:)   ! Only used in optimize-inho-strain.F
     real*8,     allocatable :: inhomo_K(:,:,:, :,:)       ! FTed potential
     real*8,     allocatable :: inhomo_K_G(:,:, :,:,:)     ! inhomo_K = G tG, where G is a lower triangular matrix and tG is transpose of G. G(i,4) = 1/G(i,i).
     real*8,     allocatable :: inhomo_coup2_K(:,:,:, :,:) ! FTed potential
     logical,    allocatable :: sum_p(:,:,:) ! .true. if the u(R) is not defect nor mirrored film. This array will be initialized in read_defects_u.F
     real*8,     allocatable :: e_layer(:)
#  endif
     real*8                 strain(6)
     real*8                 homogeneous(6,6)
     real*8                 homogeneous_G(6,6)
     real*8                 homogeneous_G_inv(6)
     real*8                 homogeneous_coupling_2(6,6)
     real*8                 s_Nose, pi_Nose, H0! for Nose-Poincare Thermostat
     integer                n_sum_p
     integer*8              plans_dipoR2C(3)
     integer*8              plans_didiR2C(6)
     integer*8              plans_inhoK2R(6)
     integer*8              plans_dipoT2dVddi(3)
  end type Coord_type

contains
  subroutine alloc_Coord(p,c)
    use Param_module
    implicit none
    type(Param_type), intent(in)    :: p
    type(Coord_type), intent(inout) :: c
    integer i
#   if defined(HAVE_LIBFFTW3)
    integer alpha
#   include "fftw3.f"
#   endif
    call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'alloc_Coord().')
    !--- m_inv ------------------------------
    if (allocated(c%m_inv)) deallocate(c%m_inv)
    allocate(c%m_inv(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 3))
    !--- dipo -------------------------------
    if (allocated(c%dipoR)) deallocate(c%dipoR)
    allocate(     c%dipoR(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 3))
    if (allocated(c%dipoK)) deallocate(c%dipoK)
    allocate(     c%dipoK(0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1, 3)) !"/2" See fft.F!
    !!!first touch
!$omp parallel do
    do i = 0,p%Lz-1
       c%dipoR(:,:,i,:) = 0.0d0
    end do
!$omp end parallel do
!$omp parallel do
    do i = 0,p%Lz-1
       c%dipoK(:,:,i,:) = (0.0d0,0.0d0)
    end do
!$omp end parallel do
#   if defined(HAVE_LIBFFTW3)
    do alpha = 1, 3
       call dfftw_plan_dft_r2c_3d(c%plans_dipoR2C(alpha), p%Lx, p%Ly, p%Lz, &
            & c%dipoR(0,0,0,alpha), c%dipoK(0,0,0,alpha), FFTW_MEASURE)
    end do
#   endif

    if (allocated(c%dipoP)) deallocate(c%dipoP)
    allocate(     c%dipoP(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 3))

    if (allocated(c%dVddi)) deallocate(c%dVddi)
    allocate(     c%dVddi(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 3))
    if (allocated(c%dipoT)) deallocate(c%dipoT)
    allocate(c%dipoT(0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1, 3))
    !!!first touch
!$omp parallel do
    do i = 0,p%Lz-1
       c%dVddi(:,:,i,:) = 0.0d0
    end do
!$omp end parallel do
!$omp parallel do
    do i = 0,p%Lz-1
       c%dipoT(:,:,i,:) = (0.0d0,0.0d0)
    end do
!$omp end parallel do
#   if defined(HAVE_LIBFFTW3)
    do alpha = 1, 3
       call dfftw_plan_dft_c2r_3d(c%plans_dipoT2dVddi(alpha), p%Lx, p%Ly, p%Lz, &
            & c%dipoT(0,0,0,alpha), c%dVddi(0,0,0,alpha), FFTW_MEASURE)
    end do
#   endif

    if (allocated(c%E_field)) deallocate(c%E_field)
    allocate(     c%E_field(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 3))
    !!!first touch
!$omp parallel do
    do i = 0,p%Lz-1
       c%E_field(:,:,i,:) = 0.0d0
    end do
!$omp end parallel do

    if (allocated(c%dipoI)) deallocate(c%dipoI)
    allocate(     c%dipoI(0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1, 3, 3)) !"/2" See fft.F!

    if (allocated(c%didiR)) deallocate(c%didiR)
    allocate(     c%didiR(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 6))
    if (allocated(c%didiK)) deallocate(c%didiK)
    allocate(     c%didiK(0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1, 6))    !"/2" See fft.F!
    !!!first touch
!$omp parallel do
    do i = 0,p%Lz-1
       c%didiR(:,:,i,:) = 0.0d0
    end do
!$omp end parallel do
!$omp parallel do
    do i = 0,p%Lz-1
       c%didiK(:,:,i,:) = (0.0d0,0.0d0)
    end do
!$omp end parallel do
#   if defined(HAVE_LIBFFTW3)
    do alpha = 1, 6
       call dfftw_plan_dft_r2c_3d(c%plans_didiR2C(alpha), p%Lx, p%Ly, p%Lz, &
            & c%didiR(0,0,0,alpha), c%didiK(0,0,0,alpha), FFTW_MEASURE)
    end do
#   endif

    !--- acou -------------------------------
    !if (allocated(c%acouR)) deallocate(c%acouR)
    !allocate(     c%acouR(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 3))

    !--- inhomogeneous ----------------------
    if (allocated(c%inhoR)) deallocate(c%inhoR)
    allocate(c%inhoR(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 6))
    if (allocated(c%inhoK)) deallocate(c%inhoK)
    allocate(c%inhoK(0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1, 6))
    !!!first touch
!$omp parallel do
    do i = 0,p%Lz-1
       c%inhoR(:,:,i,:) = 0.0d0
    end do
!$omp end parallel do
!$omp parallel do
    do i = 0,p%Lz-1
       c%inhoK(:,:,i,:) = (0.0d0,0.0d0)
    end do
!$omp end parallel do
#   if defined(HAVE_LIBFFTW3)
    do alpha = 1, 6
       call dfftw_plan_dft_c2r_3d(c%plans_inhoK2R(alpha), p%Lx, p%Ly, p%Lz, &
            & c%inhoK(0,0,0,alpha), c%inhoR(0,0,0,alpha), FFTW_MEASURE)
    end do
#   endif

    if (allocated(c%inhomo_K)) deallocate(c%inhomo_K)
    allocate(     c%inhomo_K(0:p%Lx/2,0:p%Ly-1,0:p%Lz-1, 3,3))

    if (allocated(c%inhomo_K_G)) deallocate(c%inhomo_K_G)
    allocate(     c%inhomo_K_G(3,4, 0:p%Lx/2,0:p%Ly-1,0:p%Lz-1))

    if (allocated(c%inhomo_coup2_K)) deallocate(c%inhomo_coup2_K)
#if defined(__xlc__)
    if (mod(p%Ly,16).eq.0 .and. mod(p%Lz,16).eq.0) then
       allocate(c%inhomo_coup2_K(0:p%Lx/2,0:p%Ly-1+3,0:p%Lz-1, 3,6))   ! padding
    else
       allocate(c%inhomo_coup2_K(0:p%Lx/2,0:p%Ly-1  ,0:p%Lz-1, 3,6))
    end if
#else
    allocate(c%inhomo_coup2_K(0:p%Lx/2,0:p%Ly-1  ,0:p%Lz-1, 3,6))
#endif
!$omp parallel do
    do i = 0,p%Lz-1
       c%inhomo_coup2_K(:,:,i,:,:) = 0.0d0
    end do
!$omp end parallel do

    !--- sum_p ------------------------------
    if (allocated(c%sum_p)) deallocate(c%sum_p)
    allocate(c%sum_p(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1))
    !--- e_layer for thermal conductivity----
    if (allocated(c%e_layer)) deallocate(c%e_layer)
    allocate(c%e_layer(0:p%Lz-1))
    !--- end --------------------------------
    call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '  alloc_Coord().')
  end subroutine alloc_Coord

  subroutine write_system(p,c,fn)
    use Param_module
    implicit none
    type(Param_type), intent(in) :: p
    type(Coord_type), intent(in) :: c
    character(len=*) :: fn
    integer ix,iy,iz,i

    call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', '')
    open(unit=UNIT_SYSTEM, file=fn, status='replace')
    do iz = 0, p%Lz-1
       do iy = 0, p%Ly-1
          do ix = 0, p%Lx-1
             if (c%sum_p(ix,iy,iz)) then
                write(UNIT_SYSTEM,'(i4,2i5,3f10.6,6e13.5)') ix, iy, iz, &
                     & (c%dipoR(ix,iy,iz,i)         ,i=1,3),&
                     & (c%dipoP(ix,iy,iz,i)/c%s_Nose,i=1,3),&
                     & (c%dVddi(ix,iy,iz,i)         ,i=1,3)
             end if
          end do
       end do
    end do
    close(UNIT_SYSTEM)
    call msg(UNIT_LOG, __FILE__, __LINE__, 'FILE', fn)
    call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '')
  end subroutine write_system

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
          write(UNIT_SYSTEM,*) abs(c%dipoK(ix,yy,0,3)), c%dipoK(ix,yy,0,3)
       end do
       write(UNIT_SYSTEM,*) ''
    end do
    close(UNIT_SYSTEM)
    call msg(UNIT_LOG, __FILE__, __LINE__, 'FILENAME', fn)
    call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '')
  end subroutine write_fft

end module Coord_module
