real*8 function kinetic_energy_dipo(p,c)
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
  ! You can write it with single line...
  ! kinetic_energy_dipo = SUM( c%dipoP(:,:,:,:)**2 * c%m_inv(:,:,:,:) ) / 2

  tmp_e = 0.0d0
!$omp parallel do private(iz, alpha, iy, ix) reduction(+:tmp_e)
  do iz=0, p%Lz-1
     do alpha = 1,3
        do iy=0, p%Ly-1
           do ix=0, p%Lx-1
              if (c%sum_p(ix, iy, iz)) then
                 tmp_e = tmp_e + c%dipoP(ix,iy,iz,alpha)**2 * c%m_inv(ix,iy,iz,alpha)
              end if
           end do
        end do
     end do
  end do
!$omp end parallel do
  kinetic_energy_dipo = tmp_e / c%n_sum_p * p%N / 2
end function kinetic_energy_dipo
