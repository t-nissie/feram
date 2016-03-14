! dVddi-dipole-dipole.F -*-f90-*-
! Time-stamp: <2016-03-14 23:07:25 takeshi>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
subroutine dVddi_dipole_dipole(p,c,e)
  use Param_module
  use Coord_module
  use Energy_module
  implicit none
  type(Param_type), intent(in)    :: p
  type(Coord_type), intent(inout) :: c
  type(Energy_type), intent(out)  :: e
  integer alpha, ix, iy, iz
  real*8 e_long_range,  e_short_range
  include 'fftw3.f03'

!$omp parallel do private(iz,iy,ix,alpha)
  do iz=0, p%Lz-1
     do iy=0, p%Ly-1
        do ix=0, p%Lx/2
           do alpha = 1,3
              c%dipoT(alpha,ix,iy,iz) = dot_product(c%short_range(alpha,:, ix,iy,iz), c%dipoK(:, ix,iy,iz))
           end do
        end do
     end do
  end do
!$omp end parallel do

  call fftw_execute_dft_c2r(c%plan_c2r_3_out, c%dipoT, c%dVddi)

!$omp parallel do
  do iz=0, p%Lz-1
     c%dVddi(:,:,:,iz) = c%dVddi(:,:,:,iz) * p%Ninv
  end do
!$omp end parallel do

!$omp parallel do private(iz,iy,ix,alpha)
  do iz=0, p%Lz-1
     do iy=0, p%Ly-1
        do ix=0, p%Lx/2
           do alpha = 1,3
              c%dipoT(alpha,ix,iy,iz) = dot_product(c%long_range(alpha,:, ix,iy,iz), c%Z_u_K(:, ix,iy,iz))
           end do
        end do
     end do
  end do
!$omp end parallel do

  call fftw_execute_dft_c2r(c%plan_c2r_3_out, c%dipoT, c%dVddi_long)

!$omp parallel do
  do iz=0, p%Lz-1
     do iy=0, p%Ly-1
        do ix=0, p%Lx-1
           c%dVddi_long(:,ix,iy,iz) = c%Z_starR(ix,iy,iz) * c%dVddi_long(:,ix,iy,iz) * p%Ninv
        end do
     end do
  end do
!$omp end parallel do

!=== e%short_range = SUM( c%dipoR(:,:,:,:) * c%dVddi(:,:,:,:) ) / 2 ===========
  e_short_range = 0.0d0
!$omp parallel do private(iz, alpha, iy, ix) reduction(+:e_short_range)
  do iz=0, p%Lz-1
     do iy=0, p%Ly-1
        do ix=0, p%Lx-1
           e_short_range = e_short_range + dot_product(c%dipoR(:,ix,iy,iz),c%dVddi(:,ix,iy,iz))
        end do
     end do
  end do
!$omp end parallel do
  e%short_range = e_short_range / 2

!=== e%long_range = SUM( c%dipoR(:,:,:,:) * c%dVddi(:,:,:,:) ) / 2 ===========
  e_long_range = 0.0d0
!$omp parallel do private(iz, alpha, iy, ix) reduction(+:e_long_range)
  do iz=0, p%Lz-1
     do iy=0, p%Ly-1
        do ix=0, p%Lx-1
           e_long_range = e_long_range + dot_product(c%dipoR(:,ix,iy,iz),c%dVddi_long(:,ix,iy,iz))
        end do
     end do
  end do
!$omp end parallel do
  e%long_range = e_long_range / 2

!$omp parallel do
  do iz=0, p%Lz-1
     do iy=0, p%Ly-1
        do ix=0, p%Lx-1
           c%dVddi(:,ix,iy,iz) = c%dVddi(:,ix,iy,iz) + c%dVddi_long(:,ix,iy,iz)
        end do
     end do
  end do
!$omp end parallel do

  !if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') thenx
  !   call mirror(p, c%dVddi)
  !end if
end subroutine dVddi_dipole_dipole
