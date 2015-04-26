! dVddi-dipole-dipole.F -*-f90-*-
! Time-stamp: <2015-04-26 17:47:03 takeshi>
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
  !--- arguments -------------------------------------
  type(Param_type), intent(in)    :: p
  type(Coord_type), intent(inout) :: c
  type(Energy_type), intent(out)  :: e
  !--- local -----------------------------------------
  integer alpha, ix, iy, iz
  real*8 e_dipole_dipole
#if defined(HAVE_LIBFFTW3)
  include 'fftw3.f03'
#endif
  !--- END of variable definitions -------------------
  !call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'calc dVddi, calc e%dipo_dipo')
!$omp parallel do private(iz,iy,ix,alpha)
  do iz=0, p%Lz-1
     do alpha = 1,3
        do iy=0, p%Ly-1
           do ix=0, p%Lx/2
              c%dipoT(alpha,ix,iy,iz) = dot_product(c%dipoI(alpha,:, ix,iy,iz), c%dipoK(:, ix,iy,iz))
           end do
        end do
     end do
  end do
!$omp end parallel do

!write(6,*) c%dipoI(1,1,1,1,1)
!write(6,*) c%dipoK(1,1,1,1)
!write(6,*) c%dipoT(1,1,1,1)

#if defined(HAVE_LIBFFTW3)
  call fftw_execute_dft_c2r(c%plan_c2r_3_out, c%dipoT, c%dVddi)
#else
# error "Not implemented yet."
  ! do alpha = 1, 3
  !    call fft_3d_r2c_or_c2r_out_of_place(.false., p%Lx, p%Ly, p%Lz, &
  !         & c%dVddi(0,0,0,alpha), c%dipoT(0,0,0,alpha))
  ! end do
#endif

!write(6,*) c%dVddi(1,1,1,1)

!$omp parallel do
  do iz=0, p%Lz-1
     c%dVddi(:,:,:,iz) = c%dVddi(:,:,:,iz) * p%Ninv
  end do
!$omp end parallel do

  !if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') thenx
  !   call mirror(p, c%dVddi)
  !end if

  !=== e%dipole_dipole = SUM( c%dipoR(:,:,:,:) * c%dVddi(:,:,:,:) ) / 2 ===========
  e_dipole_dipole = 0.0d0
!$omp parallel do private(iz, alpha, iy, ix) reduction(+:e_dipole_dipole)
  do iz=0, p%Lz-1
     do iy=0, p%Ly-1
        do ix=0, p%Lx-1
           do alpha = 1,3
              e_dipole_dipole = e_dipole_dipole + c%dipoR(alpha,ix,iy,iz) * c%dVddi(alpha,ix,iy,iz)
           end do
        end do
     end do
  end do
!$omp end parallel do
  e%dipole_dipole = e_dipole_dipole / 2
  !================================================================================

  !call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '')
end subroutine dVddi_dipole_dipole
