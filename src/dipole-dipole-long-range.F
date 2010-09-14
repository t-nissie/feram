! dipole-dipole-long-range.F -*-f90-*-
! Time-stamp: <2010-09-14 18:51:03 takeshi>
! Author: Takeshi NISHIMATSU
!!
#include "define.h"
subroutine dipole_dipole_long_range(p,long_range)
  use Param_module
  implicit none
  !--- arguments -------------------------------------
  type(Param_type), intent(in)     :: p
  real*8,           intent(out)    :: long_range(0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1, 3, 3) !"/2" See fft.F!
  !--- local -----------------------------------------
  real*8,     allocatable :: TMPreal(:,:,:,:,:)
  complex*16, allocatable :: TMPcomplex(:,:,:,:,:)
  real*8   four_pi_over_unit_cell_volume, two_pi_over_a, four_kappa2
  real*8   Lx_a0, Ly_a0, Lz_a0
  integer  ix, iy, iz, jx, jy, jz, alpha, beta, nx, ny, nz
  integer  max_x, max_y, max_z
  real*8   k(3), kG(3), kGkG
  real*8   r(3), n(3), rn(3), rnrn, rn_norm
  character(50)            :: message
  !--- decay functions -------------------------------
  real*8   B_decay,C_decay
  external B_decay,C_decay
  !--- END of variable definitions -------------------

  call msg(6, __FILE__, __LINE__, 'BEGIN', message)

  four_pi_over_unit_cell_volume  = 4 * M_PI / p%a0**3
  two_pi_over_a                  = 2 * M_PI / p%a0
  four_kappa2                    = 4 * p%kappa**2
  Lx_a0 = p%Lx * p%a0
  Ly_a0 = p%Ly * p%a0
  Lz_a0 = p%Lz * p%a0

  max_x = 24/p%Lx
  max_y = 24/p%Ly
  max_z = 24/p%Lz

  allocate(   TMPreal(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 3, 3))
  allocate(TMPcomplex(0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1, 3, 3)) !"/2" See fft.F!
  TMPreal(:,:,:,:,:)=0.0d0

  !--- BEGIN of self-interaction correction ----------------
  do alpha = 1, 3
     TMPreal(0, 0, 0, alpha, alpha) = - 2 * M_2_SQRTPI * p%kappa**3 / 3
  end do
  !--- END of self-interaction correction ------------------
!
  !--- BEGIN of real-space summation -----------------------
  do jz = -1-max_z, max_z
     n(3) = jz * Lz_a0
     do jy = -1-max_y, max_y
        n(2) = jy * Ly_a0
        do jx = -1-max_x, max_x
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
           do iy = 0, p%Ly-1
              k(2) = dble(iy)/p%Ly; if (k(2).gt.0.5d0) k(2)=k(2)-1.0d0
              do ix = 0, p%Lx/2
                 k(1) = dble(ix) / p%Lx


                 do nz = -max_z, max_z
                    kG(3) = two_pi_over_a*(k(3)+nz)
                    do ny = -max_y, max_y
                       kG(2) = two_pi_over_a*(k(2)+ny)
                       do nx = -max_x, max_x
                          if (ix.eq.0 .and. iy.eq.0 .and. iz.eq.0 .and. &
                            & nx.eq.0 .and. ny.eq.0 .and. nz.eq.0) cycle
                          kG(1) = two_pi_over_a*(k(1)+nx)
                          kGkG = kG(1)**2 + kG(2)**2 + kG(3)**2
                          long_range(ix,iy,iz,alpha,beta) = &
                               & long_range(ix,iy,iz,alpha,beta) &
                               & + four_pi_over_unit_cell_volume * kG(alpha) * kG(beta) &
                               &   * exp(-kGkG/four_kappa2) / kGkG
                       end do
                    end do
                 end do

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
