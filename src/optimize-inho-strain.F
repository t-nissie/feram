! optimize-inho-strain.F   -*-f90-*-
! Time-stamp: <2016-06-24 16:35:32 takeshi>
! Author: Takeshi NISHIMATSU
! Caution: Before calling this subroutine, didiR should be prepared by dipoFFT.F
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
#include "define.h"
subroutine optimize_inho_strain(p,c)
  use Param_module
  use Coord_module
  use msg_module
  implicit none
  type(Param_type), intent(in)    :: p
  type(Coord_type), intent(inout) :: c
  complex*16 :: acouK_tmp(3)
  complex*16 :: tmp
  integer    :: alpha,beta, ix,iy,iz
  if (p%verbose>=2) call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'optimize_inho_strain().')
  !--- optimize inhomogeneous strain -----------------------------------
  ! Linear equations for acouK,
  !    inhomo_K(1:3,1:3) * acouK(1:3) = - inhomo_coup2_K(1:3,1:6) * c%didiK(1:6) ,
  ! are solved for all k-points.
  ! * inhomo_K is positive definite real symmetric matrix. See elastic.F
  !   and cholesky_d.f in https://gist.github.com/t-nissie/6386f1acc19cd38af621 .
  ! * acouK(1:3, 0,0,0)=0 is guaranteed by c%inhomo_K_G(1:3,1:4, 0,0,0)=0.
!$omp parallel do private(iz,iy,ix,alpha,beta,acouK_tmp,tmp)
  do iz = 0, p%Lz-1
     do iy = 0, p%Ly-1
        do ix = 0, p%Lx/2
              do alpha = 1, 3
                 acouK_tmp(alpha) = &
                      & - c%c_k_modulation_k(alpha,ix,iy,iz) &
                      & - dot_product(c%inhomo_coup2_K(alpha,:, ix,iy,iz), c%didiK(:, ix,iy,iz))
              end do
              ! See [2] of cholesky_d.f in https://gist.github.com/t-nissie/6386f1acc19cd38af621
              do alpha = 1, 3
                 tmp = (0.0d0,0.0d0)
                 do beta = 1, alpha-1
                    tmp = tmp + c%inhomo_K_G(alpha,beta, ix,iy,iz)*acouK_tmp(beta)
                 end do
                 acouK_tmp(alpha) = (acouK_tmp(alpha)-tmp) * c%inhomo_K_G(alpha,4, ix,iy,iz)
              end do
              ! See [3] of cholesky_d.f in https://gist.github.com/t-nissie/6386f1acc19cd38af621
              do alpha = 3, 1, -1
                 tmp = (0.0d0,0.0d0)
                 do beta = alpha+1, 3
                    tmp = tmp + acouK_tmp(beta)*c%inhomo_K_G(beta,alpha, ix,iy,iz)
                 end do
                 acouK_tmp(alpha) = (acouK_tmp(alpha)-tmp) * c%inhomo_K_G(alpha,4, ix,iy,iz)
              end do
              !
              c%acouK(:,ix,iy,iz) = acouK_tmp(:)
        end do
     end do
  end do
!$omp end parallel do
  if (p%verbose>=2) call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '')
end subroutine optimize_inho_strain
