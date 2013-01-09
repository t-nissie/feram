! optimize-inho-strain.F   -*-f90-*-
! Time-stamp: <2013-01-09 21:39:55 takeshi>
! Author: Takeshi NISHIMATSU
! Caution: Before calling this subroutine, didiR should be prepared by dipoFFT.F
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
#include "define.h"
subroutine optimize_inho_strain(p,c,e)
  use Param_module
  use Coord_module
  use Energy_module
  implicit none
  !--- arguments -------------------------------------
  type(Param_type),  intent(in)    :: p
  type(Coord_type),  intent(inout) :: c
  type(Energy_type), intent(out)   :: e
  !--- local -----------------------------------------
  real*8                  :: k(3), eta_B_over_2m(6)
  complex*16              :: acouK_tmp(3)
  complex*16              :: tmp
  integer                 :: i, alpha,beta, ix,iy,iz
  !--- END of variable definitions -------------------
  !call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', &
  !     & 'Optimize inhomogeneous strain. Calculate related energies and accelerations.')

  !--- optimize inhomogeneous strain -----------------------------------
  ! Linear equations for acouK,
  !    inhomo_K(1:3,1:3) * acouK(1:3) = - inhomo_coup2_K(1:3,1:6) * c%didiK(1:6) ,
  ! are solved for all k-points.
  ! * inhomo_K is positive definite real symmetric matrix. See elastic.F and cholesky_d.f.
  ! * acouK(0,0,0,1:3)=0 is guaranteed by c%inhomo_K_G(1:3,1:4, 0,0,0)=0.
!$omp parallel do private(iz,iy,ix,alpha,beta,acouK_tmp,tmp)
  do iz = 0, p%Lz-1
     do iy = 0, p%Ly-1
        do ix = 0, p%Lx/2
              do alpha = 1, 3
                 acouK_tmp(alpha) = &
                      & - SUM(c%inhomo_coup2_K(ix,iy,iz,alpha,:) * c%didiK(ix,iy,iz,:))
              end do
              ! See [2] of cholesky_d.f
              do alpha = 1, 3
                 tmp = (0.0d0,0.0d0)
                 do beta = 1, alpha-1
                    tmp = tmp + c%inhomo_K_G(alpha,beta, ix,iy,iz)*acouK_tmp(beta)
                 end do
                 acouK_tmp(alpha) = (acouK_tmp(alpha)-tmp) * c%inhomo_K_G(alpha,4, ix,iy,iz)
              end do
              ! See [3] of cholesky_d.f
              do alpha = 3, 1, -1
                 tmp = (0.0d0,0.0d0)
                 do beta = alpha+1, 3
                    tmp = tmp + acouK_tmp(beta)*c%inhomo_K_G(beta,alpha, ix,iy,iz)
                 end do
                 acouK_tmp(alpha) = (acouK_tmp(alpha)-tmp) * c%inhomo_K_G(alpha,4, ix,iy,iz)
              end do
              !
              c%acouK(ix,iy,iz,:) = acouK_tmp(:)
        end do
     end do
  end do
!$omp end parallel do

  !--- calculate some emergies -----------------------------------------
  call inhomogeneous_strain_energy(p,c,e)
  call inhomogeneous_coupling_energy(p,c,e)

  !call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '')
end subroutine optimize_inho_strain
