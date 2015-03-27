! coord_module.F -*-f90-*-
! Time-stamp: <2015-03-27 12:28:57 takeshi>
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
     real*8,     allocatable :: inhoR(:,:,:,:)   ! Only used in optimize-inho-strain.F
     complex*16, allocatable :: inhoK(:,:,:,:)   ! Only used in optimize-inho-strain.F
     real*8,     allocatable :: inhomo_K(  :,:, :,:,:)     ! FTed potential
     real*8,     allocatable :: inhomo_K_G(:,:, :,:,:)     ! inhomo_K = G tG, where G is a lower triangular matrix and tG is transpose of G. G(i,4) = 1/G(i,i).
     real*8,     allocatable :: inhomo_coup2_K(:,:, :,:,:) ! FTed potential
     logical,    allocatable :: sum_p(:,:,:) ! .true. if the u(R) is not defect nor mirrored film. This array will be initialized in read_defects_u.F
     real*8,     allocatable :: e_layer_dipo(:)
     real*8,     allocatable :: e_layer_acou(:)
     real*8                 strain(6)
     real*8                 homogeneous(6,6)
     real*8                 homogeneous_G(6,6)
     real*8                 homogeneous_G_inv(6)
     real*8                 homogeneous_coupling_2(6,6)
     real*8                 s_Nose, pi_Nose, H0! for Nose-Poincare Thermostat
     integer                n_sum_p
     type(C_PTR) ::         plan_dipoR2C
     type(C_PTR) ::         plan_didiR2C
     type(C_PTR) ::         plan_inhoC2R
     type(C_PTR) ::         plan_acouC2R
  end type Coord_type

contains
  subroutine alloc_Coord(p,c)
    use Param_module
    implicit none
    type(Param_type), intent(in)    :: p
    type(Coord_type), intent(inout) :: c
    integer i
#   if defined(HAVE_LIBFFTW3)
    integer howmany,stride
    integer, parameter :: rank=3
    integer, parameter :: dist=1
    integer  LzLyLx(3)
    integer d_embed(3)
    integer z_embed(3)
    include 'fftw3.f03'
    LzLyLx( 1)=p%Lz; LzLyLx( 2)=p%Ly; LzLyLx( 3)=p%Lx    ! p%padding_y will be introduced.
    d_embed(1)=p%Lz; d_embed(2)=p%Ly; d_embed(3)=p%Lx    ! Not 2*(Lx/2+1), so far.
    z_embed(1)=p%Lz; z_embed(2)=p%Ly; z_embed(3)=p%Lx/2+1
#   endif
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
!$omp parallel do
    do i = 0,p%Lz-1
       c%dipoR(:,:,:,i) = 0.0d0
    end do
!$omp end parallel do
!$omp parallel do
    do i = 0,p%Lz-1
       c%dipoK(:,:,:,i) = (0.0d0,0.0d0)
    end do
!$omp end parallel do
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
!$omp parallel do
    do i = 0,p%Lz-1
       c%dVddi(:,:,:,i) = 0.0d0
    end do
!$omp end parallel do
!$omp parallel do
    do i = 0,p%Lz-1
       c%dipoT(:,:,:,i) = (0.0d0,0.0d0)
    end do
!$omp end parallel do

    if (allocated(c%E_field)) deallocate(c%E_field)
    allocate(     c%E_field(3, 0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1))
    !!!first touch
!$omp parallel do
    do i = 0,p%Lz-1
       c%E_field(:,:,:,i) = 0.0d0
    end do
!$omp end parallel do

    if (allocated(c%E_field_local)) deallocate(c%E_field_local)
    allocate(     c%E_field_local(3, 0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1))
    !!!first touch
!$omp parallel do
    do i = 0,p%Lz-1
       c%E_field_local(:,:,:,i) = 0.0d0
    end do
!$omp end parallel do

    if (allocated(c%dipoI)) deallocate(c%dipoI)
    allocate(     c%dipoI(3, 3, 0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1)) !"/2" for real<->complex FFT

    if (allocated(c%didiR)) deallocate(c%didiR)
    allocate(     c%didiR(6, 0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1))
    if (allocated(c%didiK)) deallocate(c%didiK)
    allocate(     c%didiK(6, 0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1))    !"/2" for real<->complex FFT
    !!!first touch
!$omp parallel do
    do i = 0,p%Lz-1
       c%didiR(:,:,:,i) = 0.0d0
    end do
!$omp end parallel do
!$omp parallel do
    do i = 0,p%Lz-1
       c%didiK(:,:,:,i) = (0.0d0,0.0d0)
    end do
!$omp end parallel do
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
!$omp parallel do
    do i = 0,p%Lz-1
       c%acouR(:,:,:,i) = 0.0d0
    end do
!$omp end parallel do
!$omp parallel do
    do i = 0,p%Lz-1
       c%acouK(:,:,:,i) = (0.0d0,0.0d0)
    end do
!$omp end parallel do
!$omp parallel do
    do i = 0,p%Lz-1
       c%acouP(:,:,:,i) = 0.0d0
    end do
!$omp end parallel do
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
!$omp parallel do
    do i = 0,p%Lz-1
       c%dVdacR(:,:,:,i) = 0.0d0
    end do
!$omp end parallel do
!$omp parallel do
    do i = 0,p%Lz-1
       c%dVdacK(:,:,:,i) = (0.0d0,0.0d0)
    end do
!$omp end parallel do

    !--- inhomogeneous strain ---------------
    if (allocated(c%inhoR)) deallocate(c%inhoR)
    allocate(c%inhoR(6, 0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1))
    if (allocated(c%inhoK)) deallocate(c%inhoK)
    allocate(c%inhoK(6, 0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1))
    !!!first touch
!$omp parallel do
    do i = 0,p%Lz-1
       c%inhoR(:,:,:,i) = 0.0d0
    end do
!$omp end parallel do
!$omp parallel do
    do i = 0,p%Lz-1
       c%inhoK(:,:,:,i) = (0.0d0,0.0d0)
    end do
!$omp end parallel do
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
#   warning "padding_y should be added for SR16000 and FX10."
!$omp parallel do
    do i = 0,p%Lz-1
       c%inhomo_coup2_K(:,:, :,:,i) = 0.0d0
    end do
!$omp end parallel do

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

  subroutine write_system(p,c,fn)
    use Param_module
    implicit none
    type(Param_type), intent(in) :: p
    type(Coord_type), intent(inout) :: c
    character(len=*) :: fn
    character(len=FILE_NAME_LEN) :: coord_directory_fn
    integer ix,iy,iz,i
#if defined(HAVE_LIBFFTW3)
  include 'fftw3.f03'
#endif

    call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', '')

    if (p%coord_directory.eq.'never') then
       call msg(UNIT_LOG, __FILE__, __LINE__, 'END', 'never write .coord files.')
       return
    else if (p%coord_directory.eq.'') then
       coord_directory_fn = trim(fn)
    else
       coord_directory_fn = trim(p%coord_directory) // '/' // trim(fn)
    end if

    if (p%mass_acou <= 0.0d0) then
!$omp parallel do
       do i = 0,p%Lz-1
          c%acouK(:,:,:,i) = (0.0d0, -1.0d0) * c%acouK(:,:,:,i)
       end do
!$omp end parallel do

#    if defined(HAVE_LIBFFTW3)
       call fftw_execute_dft_c2r(c%plan_acouC2R, c%acouK, c%acouR)
#    else
#      error "Not implemented yet."
       ! do alpha = 1, 3
       !    call fft_3d_r2c_or_c2r_out_of_place(.false., p%Lx, p%Ly, p%Lz, &
       !         & c%acouR(0,0,0,alpha), c%acouK(0,0,0,alpha))
       ! end do
#    endif

!$omp parallel do
       do i = 0,p%Lz-1
          c%acouR(:,:,:,i) = c%acouR(:,:,:,i) * p%Ninv
       end do
!$omp end parallel do
    end if

    open(unit=UNIT_SYSTEM, file=coord_directory_fn, status='replace')
    do iz = 0, p%Lz-1
       do iy = 0, p%Ly-1
          do ix = 0, p%Lx-1
                write(UNIT_SYSTEM,'(i4,2i5,3f10.6,6e13.5,6f11.6)') ix, iy, iz, &
                     & (c%dipoR(i,ix,iy,iz)         ,i=1,3),&
                     & (c%dipoP(i,ix,iy,iz)/c%s_Nose,i=1,3),&
                     & (c%dVddi(i,ix,iy,iz)         ,i=1,3),&
                     & (c%acouR(i,ix,iy,iz)         ,i=1,3),&
                     & (c%acouP(i,ix,iy,iz)         ,i=1,3)
          end do
       end do
    end do
    close(UNIT_SYSTEM)
    call msg(UNIT_LOG, __FILE__, __LINE__, 'FILE', trim(coord_directory_fn))
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
          write(UNIT_SYSTEM,*) abs(c%dipoK(3,ix,yy,0)), c%dipoK(3,ix,yy,0)
       end do
       write(UNIT_SYSTEM,*) ''
    end do
    close(UNIT_SYSTEM)
    call msg(UNIT_LOG, __FILE__, __LINE__, 'FILENAME', fn)
    call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '')
  end subroutine write_fft

end module Coord_module
