! coord_module.F -*-f90-*-
! Time-stamp: <2015-03-27 14:21:24 takeshi>
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
