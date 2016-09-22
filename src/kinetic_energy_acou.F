real*8 function kinetic_energy_acou(p,c)
  use Param_module
  use Coord_module
  implicit none
  !--- arguments -------------------------------------
  type(Param_type),  intent(in)    :: p
  type(Coord_type),  intent(in)    :: c
  !--- local -----------------------------------------
  real*8  :: tmp_e
  integer :: alpha, ix,iy,iz
  !--- END of variable definitions -------------------

  ! I am not sure whether I should use c%sum_p(ix, iy, iz) here.

  tmp_e = 0.0d0
!$omp parallel do private(iz, alpha, iy, ix) reduction(+:tmp_e)
  do iz=0, p%Lz-1
     do iy=0, p%Ly-1
        do ix=0, p%Lx-1
           do alpha = 1,3
              tmp_e = tmp_e + c%acouP(alpha,ix,iy,iz)**2 * c%mass_acou_inv(ix,iy,iz)
           end do
        end do
     end do
  end do
!$omp end parallel do
  kinetic_energy_acou = tmp_e / 2
end function kinetic_energy_acou
