! dipole-dipole-long-range.F -*-f90-*-
! Time-stamp: <2008-04-16 17:53:05 takeshi>
! Author: Takeshi NISHIMATSU
!!
#include "define.h"
subroutine dipole_dipole_long_range(p,long_range)
  use Param_module
  implicit none
  !--- arguments -------------------------------------
  type(Param_type), intent(inout)  :: p
  real*8,           intent(out)    :: long_range(0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1, 3, 3) !"/2" See fft.F!
  !--- local -----------------------------------------
  real*8,     allocatable :: TMPreal(:,:,:,:,:)
  complex*16, allocatable :: TMPcomplex(:,:,:,:,:)
  real*8   four_pi_over_unit_cell_volume, two_pi_over_a, four_kappa2
  real*8   Lx_a0, Ly_a0, Lz_a0
  integer  ix, iy, iz, jx, jy, jz, alpha, beta
  integer  max_x, max_y, max_z
  real*8   k(3),kk
  real*8   r(3), n(3), rn(3), rnrn, rn_norm
  character(50)            :: message
  !--- decay functions -------------------------------
  real*8   B_decay,C_decay
  external B_decay,C_decay
  !--- END of variable definitions -------------------

  if (p%kappa<=0.0d0) then
     p%kappa = sqrt(M_PI) / p%a0 / (dble(p%Lx*p%Ly*p%Lz))**(1.0d0/6)
  end if
  write(message,'(a,f10.4)') ': p%kappa = ', p%kappa
  call msg(6, __FILE__, __LINE__, 'BEGIN', message)

  four_pi_over_unit_cell_volume  = 4 * M_PI / p%a0**3
  two_pi_over_a                  = 2 * M_PI / p%a0
  four_kappa2                    = 4 * p%kappa**2
  Lx_a0 = p%Lx * p%a0
  Ly_a0 = p%Ly * p%a0
  Lz_a0 = p%Lz * p%a0

  allocate(   TMPreal(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 3, 3))
  allocate(TMPcomplex(0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1, 3, 3)) !"/2" See fft.F!
  TMPreal(:,:,:,:,:)=0.0d0

  max_x = 16/p%Lx
  max_y = 16/p%Ly
  max_z = 16/p%Lz

  !--- BEGIN of self-interaction correction ----------------
  do alpha = 1, 3
     TMPreal(0, 0, 0, alpha, alpha) = - 2 * M_2_SQRTPI * p%kappa**3 / 3
  end do
  !--- END of self-interaction correction ------------------
!
  !--- BEGIN of real-space summation -----------------------
  do jz = -1-max_x, max_x
     n(3) = jz * Lz_a0
     do jy = -1-max_y, max_y
        n(2) = jy * Ly_a0
        do jx = -1-max_z, max_z
           n(1) = jx * Lx_a0
           do beta = 1, 3
              do alpha = 1, 3
                 do iz = 0, p%Lz-1
                    r(3) = iz * p%a0
                    do iy = 0, p%Ly-1
                       r(2) = iy * p%a0
                       do ix = 0, p%Lx-1
                          if (jx.eq.0 .and. jy.eq.0 .and. jz.eq.0 .and. &
                          &   ix.eq.0 .and. iy.eq.0 .and. iz.eq.0) cycle
                          r(1) = ix * p%a0
                          rn(1) = r(1) + n(1)
                          rn(2) = r(2) + n(2)
                          rn(3) = r(3) + n(3)
                          rnrn = rn(1)**2 + rn(2)**2 + rn(3)**2
                          rn_norm = sqrt(rnrn)
                          if (alpha.eq.beta) then
                            TMPreal(ix, iy, iz, alpha, beta) = &
                          & TMPreal(ix, iy, iz, alpha, beta) + B_decay(rn_norm, rnrn, p%kappa)
                          end if
                          TMPreal(ix, iy, iz, alpha, beta) = &
                        & TMPreal(ix, iy, iz, alpha, beta)   &
                        &   - rn(alpha) * rn(beta) * C_decay(rn_norm, rnrn, p%kappa)
                       end do
                    end do
                 end do
              end do
           end do
        end do
     end do
  end do
  !--- END of real-space summation -------------------------

  call fft_r2c_3x3upper(p, TMPreal, TMPcomplex)
  long_range(:,:,:,:,:) = dble(TMPcomplex(:,:,:,:,:))
  deallocate(TMPreal,TMPcomplex)
!
  !--- BEGIN of reciplocal-space summation -----------------
  do beta = 1, 3
     do alpha = 1, 3
        do iz = 0, p%Lz-1
           k(3) = dble(iz)/p%Lz; if (k(3).gt.0.5d0) k(3)=k(3)-1.0d0
           k(3) = k(3) * two_pi_over_a
           do iy = 0, p%Ly-1
              k(2) = dble(iy)/p%Ly; if (k(2).gt.0.5d0) k(2)=k(2)-1.0d0
              k(2) = k(2) * two_pi_over_a
              do ix = 0, p%Lx/2
                 if (ix.eq.0 .and. iy.eq.0 .and. iz.eq.0) cycle
                 k(1) = dble(ix) / p%Lx * two_pi_over_a
                 kk = k(1)**2 + k(2)**2 + k(3)**2
                 long_range(ix,iy,iz,alpha,beta) = &
               & long_range(ix,iy,iz,alpha,beta) &
               & + four_pi_over_unit_cell_volume * k(alpha) * k(beta) &
               &   * exp(-kk/four_kappa2) / kk
              end do
           end do
        end do
     end do
  end do
  !--- END of reciplocal-space summation -------------------

  !--- BEGIN of Gamma=0 part -------------------------------
  !do alpha = 1, 3
  !   long_range(0, 0, 0, alpha, alpha) = &
  ! & long_range(0, 0, 0, alpha, alpha) + four_pi_over_unit_cell_volume/3
  !end do
  !--- END of Gamma=0 part ---------------------------------

  long_range(:,:,:,:,:) = long_range(:,:,:,:,:) &
       &               * (HARTREE_BOHR * p%Z_star**2 / p%epsilon_inf)
  call msg(6, __FILE__, __LINE__, 'END', '')
end subroutine dipole_dipole_long_range
