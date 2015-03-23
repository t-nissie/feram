! nose-poincare.F   -*-f90-*-
! Time-stamp: <2015-03-22 17:05:26 takeshi>
! Author: Takeshi NISHIMATSU and Umesh V Waghmare
! Description:
! Pearents: hysteresis_loop.F, initialize-dipoR.F, leapfrog.F, nose-poincare.F
! ref_1: Stephen D. Bond, Benedict J. Leimkuhler and Brian B. Laird:
!         J. Comput. Phys. Vol.151 p.114 (1999)
!!
subroutine nose_poincare(p,c,e)
  use Param_module
  use Coord_module
  use Energy_module
  implicit none
  type(Param_type),  intent(inout) :: p
  type(Coord_type),  intent(inout) :: c
  type(Energy_type), intent(out)   :: e
  real*8 CB, s_Nose_old, delta_H, kinetic_energy_dipo, dt2s
  integer iy,iz,alpha
  external kinetic_energy_dipo
  !call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', '')

  dt2s = p%dt_2*c%s_Nose
!$omp parallel do
  do iz=0, p%Lz-1
     c%dipoP(:,:,:,iz) = c%dipoP(:,:,:,iz) - dt2s * c%dVddi(:,:,:,iz) !(35a)
  end do
!$omp end parallel do
  e%dipo_kinetic = kinetic_energy_dipo(p,c)
  CB = p%n_freedom*p%temperature_eV*(1.0d0+log(c%s_Nose)) &
       - e%dipo_kinetic/c%s_Nose**2 &
       + sum_potential_energies(e) &
       - c%H0
  CB = p%dt_2 * CB - c%pi_Nose
  c%pi_Nose = -2 * CB / (1.0d0 + sqrt(1.0d0-CB*p%dt/p%Q_Nose)) !(38) <- (35b)
  s_Nose_old = c%s_Nose
  c%s_Nose  = c%s_Nose * ( 1.0d0 + p%dt_2*c%pi_Nose/p%Q_Nose ) / & 
                       & ( 1.0d0 - p%dt_2*c%pi_Nose/p%Q_Nose )         !(35c)
!$omp parallel do
     do iz=0, p%Lz-1
        do iy=0, p%Ly-1
           c%dipoR(:,:,iy,iz) = c%dipoR(:,:,iy,iz) &
                & + p%dt_2 * (1/c%s_Nose+1/s_Nose_old) * c%dipoP(:,:,iy,iz) * c%m_inv(:,:,iy,iz)   !(35d)
        end do
     end do
!$omp end parallel do

  !call msg(UNIT_LOG, __FILE__, __LINE__, 'dipoR', 'is updated.')

  call mirror_force_mirror(p,c,e)

  ! e%dipo_kinetic was already calculated.
  call Nose_Poincare_Hamiltonian(p,c,e)
  delta_H = e%H_Nose_Poincare / c%s_Nose
  c%pi_Nose = c%pi_Nose &
       & + p%dt_2*(2*e%dipo_kinetic/c%s_Nose**2 - p%n_freedom*p%temperature_eV) &
       & - p%dt_2*delta_H                                              !(35e)

!$omp parallel do
     do iz=0, p%Lz-1
        c%dipoP(:,:,:,iz) = c%dipoP(:,:,:,iz) - (p%dt_2*c%s_Nose) * c%dVddi(:,:,:,iz)
     end do
!$omp end parallel do
                                                                            !(35f)
  ! calculate e%dipo_kinetic and e%H_Nose_Poincare for write_Energy()
  e%dipo_kinetic = kinetic_energy_dipo(p,c)
  call Nose_Poincare_Hamiltonian(p,c,e)

  !call msg(UNIT_LOG, __FILE__, __LINE__, 'END', 'dipoP is updated at this end.')
end subroutine nose_poincare
