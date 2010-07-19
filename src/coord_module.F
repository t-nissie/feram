! coord_module.F -*-f90-*-
! Time-stamp: <2010-07-19 16:51:38 takeshi>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif

#include "define.h"

module Coord_module
  implicit none
  type Coord_type
#  if defined(SR11000)
#    define allocated associated
     real*8,     pointer     :: m_inv(:,:,:,:)   => null()
     real*8,     pointer     :: dipoR(:,:,:,:)   => null()
     complex*16, pointer     :: dipoK(:,:,:,:)   => null()
     real*8,     pointer     :: dipoP(:,:,:,:)   => null()
     real*8,     pointer     :: dVddi(:,:,:,:)   => null()
     real*8,     pointer     :: E_field(:,:,:,:) => null()
     real*8,     pointer     :: dipoI(:,:,:,:,:) => null()
     real*8,     pointer     :: didiR(:,:,:,:)   => null()
     complex*16, pointer     :: didiK(:,:,:,:)   => null()
    !real*8,     pointer     :: acouR(:,:,:,:)   => null()
     real*8,     pointer     :: inhomo_K(:,:,:, :,:)       => null()
     real*8,     pointer     :: inhomo_coup2_K(:,:,:, :,:) => null()
#  else
     real*8,     allocatable :: m_inv(:,:,:,:)   ! inverse of mass
     real*8,     allocatable :: dipoR(:,:,:,:)   ! Optical dipole displacements as a function of R
     complex*16, allocatable :: dipoK(:,:,:,:)   ! FT of dipoQ
     real*8,     allocatable :: dipoP(:,:,:,:)   ! Momenta
     real*8,     allocatable :: dVddi(:,:,:,:)   ! dV/dq for dipole
     real*8,     allocatable :: E_field(:,:,:,:) ! external and local electric field
     real*8,     allocatable :: dipoI(:,:,:,:,:) ! Fourier transformed potential  !!!REAL*8!!!
     real*8,     allocatable :: didiR(:,:,:,:)   ! 6 kind of dipoR*dipoR
     complex*16, allocatable :: didiK(:,:,:,:)   ! 6 kind of dipoR*dipoR
    !real*8,     allocatable :: acouR(:,:,:,:)   ! Acoustic displacements in real space
     real*8,     allocatable :: inhomo_K(:,:,:, :,:)       ! FTed potential
     real*8,     allocatable :: inhomo_coup2_K(:,:,:, :,:) ! FTed potential
#  endif
     real*8                 strain(6)
     real*8                 homogeneous(6,6)
     real*8                 homogeneous_coupling_2(6,6)
     real*8                 s_Nose, pi_Nose, H0! for Nose-Poincare Thermostat
  end type Coord_type

contains
  subroutine alloc_Coord(p,c)
    use Param_module
    implicit none
    type(Param_type), intent(in)    :: p
    type(Coord_type), intent(inout) :: c
    call msg(6, __FILE__, __LINE__, 'BEGIN', ': alloc_Coord().')
    !--- m_inv ------------------------------
    if (allocated(c%m_inv)) deallocate(c%m_inv)
    allocate(c%m_inv(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 3))
    !--- dipo -------------------------------
    if (allocated(c%dipoR)) deallocate(c%dipoR)
    allocate(     c%dipoR(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 3))
    if (allocated(c%dipoK)) deallocate(c%dipoK)
    allocate(     c%dipoK(0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1, 3)) !"/2" See fft.F!
    if (allocated(c%dipoP)) deallocate(c%dipoP)
    allocate(     c%dipoP(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 3))
    if (allocated(c%dVddi)) deallocate(c%dVddi)
    allocate(     c%dVddi(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 3))
    if (allocated(c%E_field)) deallocate(c%E_field)
    allocate(     c%E_field(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 3))
    if (allocated(c%dipoI)) deallocate(c%dipoI)
    allocate(     c%dipoI(0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1, 3, 3)) !"/2" See fft.F!
    if (allocated(c%didiR)) deallocate(c%didiR)
    allocate(     c%didiR(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 6))
    if (allocated(c%didiK)) deallocate(c%didiK)
    allocate(     c%didiK(0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1, 6))    !"/2" See fft.F!
    !--- acou -------------------------------
    !if (allocated(c%acouR)) deallocate(c%acouR)
    !allocate(     c%acouR(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 3))
    !--- inhomogeneous ----------------------
    if (allocated(c%inhomo_K)) deallocate(c%inhomo_K)
    allocate(     c%inhomo_K(0:p%Lx/2,0:p%Ly-1,0:p%Lz-1, 3,3))
    if (allocated(c%inhomo_coup2_K)) deallocate(c%inhomo_coup2_K)
    allocate(     c%inhomo_coup2_K(0:p%Lx/2,0:p%Ly-1,0:p%Lz-1, 3,6))
    !--- end --------------------------------
    call msg(6, __FILE__, __LINE__, 'END', ':   alloc_Coord().')
  end subroutine alloc_Coord

  subroutine write_system(p,c,fn)
    use Param_module
    implicit none
    type(Param_type), intent(in) :: p
    type(Coord_type), intent(in) :: c
    character(len=*) :: fn
    integer ix,iy,iz,i

    call msg(6, __FILE__, __LINE__, 'BEGIN', '')
    open(unit=UNIT_SYSTEM, file=fn, status='replace')
    do iz = 0, p%Lz-1
       do iy = 0, p%Ly-1
          do ix = 0, p%Lx-1
             write(UNIT_SYSTEM,'(i4,2i5,3f10.6,6e13.5)') ix, iy, iz, &
                  & (c%dipoR(ix,iy,iz,i)         ,i=1,3),&
                  & (c%dipoP(ix,iy,iz,i)/c%s_Nose,i=1,3),&
                  & (c%dVddi(ix,iy,iz,i)         ,i=1,3)
          end do
       end do
    end do
    close(UNIT_SYSTEM)
    call msg(6, __FILE__, __LINE__, 'FILE: ', fn)
    call msg(6, __FILE__, __LINE__, 'END', '')
  end subroutine write_system

  subroutine write_fft(p,c,fn)
    use Param_module
    implicit none
    type(Param_type), intent(in) :: p
    type(Coord_type), intent(in) :: c
    character(len=*) :: fn
    integer ix,iy,yy

    call msg(6, __FILE__, __LINE__, 'BEGIN', '')
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
    call msg(6, __FILE__, __LINE__, 'FILE: ', fn)
    call msg(6, __FILE__, __LINE__, 'END', '')
  end subroutine write_fft

end module Coord_module
