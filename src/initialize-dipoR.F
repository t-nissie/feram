! initialize-dipoR.F -*-f90-*-
! Time-stamp: <2012-04-11 18:04:41 user2001>
! Author: Takeshi NISHIMATSU
! Description: Initialize dipoR and c%m_inv(:,:,:,:) with read_defects_u.F.
! Parents: hysteresis_loop.F or molecular-dynamics.F
!!
#include "define.h"
subroutine initialize_dipoR(p,c,e)
  use Param_module
  use Coord_module
  use Energy_module
  use marsaglia_tsang_uni64_module
  implicit none
  type(Param_type),  intent(in)    :: p
  type(Coord_type),  intent(inout) :: c
  type(Energy_type), intent(out)   :: e
  integer ix, iy, iz, alpha, ios, dummy_x, dummy_y, dummy_z
  real*8 dmy,kinetic_energy
  character (len=120) :: message
  character (len=120) :: restart_fn
  external kinetic_energy
  call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', '')
  write(restart_fn,'(a,a)') trim(p%filename), '.restart'
  open(unit=UNIT_SYSTEM, file=restart_fn, status='old', action='read', iostat=ios)
  if (ios.eq.0) then
     write(message,'(a,a)') trim(restart_fn), ' was found.'
     call msg(UNIT_LOG, __FILE__, __LINE__, 'FILE', message)
     do iz = 0, p%Lz-1
        do iy = 0, p%Ly-1
           do ix = 0, p%Lx-1
              read(UNIT_SYSTEM,*) dummy_x, dummy_y, dummy_z, &
                   c%dipoR(ix,iy,iz,1),c%dipoR(ix,iy,iz,2),c%dipoR(ix,iy,iz,3),&
                   c%dipoP(ix,iy,iz,1),c%dipoP(ix,iy,iz,2),c%dipoP(ix,iy,iz,3)
           end do
        end do
     end do
     close(UNIT_SYSTEM)
  else
     write(message,'(a,a)') trim(restart_fn), ' was NOT found.'
     call msg(UNIT_LOG, __FILE__, __LINE__, 'FILE', message)
     dmy = uni64(p%seed(1), p%seed(2))
     do alpha = 1, 3
        do iz = 0, p%Lz-1
           do iy = 0, p%Ly-1
              do ix = 0, p%Lx-1
                 c%dipoR(ix,iy,iz,alpha) = &
                      & normal_dist(p%init_dipo_avg(alpha),p%init_dipo_dev(alpha))
                 if ( cos(M_2PI*(p%k_stripe(1)*ix+p%k_stripe(2)*iy+p%k_stripe(3)*iz+1.0d-4)) < 0.0d0 ) then
                    c%dipoR(ix,iy,iz,alpha) = -c%dipoR(ix,iy,iz,alpha)
                 end if
              end do
           end do
        end do
     end do
     c%dipoP(:,:,:,:) = 0.0d0
  end if

  call read_defects_u(p,c)   ! Prepares fixed u for defects and c%m_inv(:,:,:,:).

  call mirror_force_mirror(p,c,e)

  c%s_Nose  = 1.0d0   ! s0
  c%pi_Nose = 0.0d0   ! pi0
  e%dipo_kinetic    = kinetic_energy(p,c)
  e%H_Nose_Poincare = 0.0d0

  call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '')
end subroutine initialize_dipoR
