! molecular-dynamics.F -*-f90-*-
! Time-stamp: <2007-08-08 10:42:10 t-nissie>
! Author: Takeshi NISHIMATSU
! ref_1: Bond
!!
# include "define.h"
subroutine molecular_dynamics(p,c)
  use Param_module
  use Coord_module
  use Energy_module
  use Average_module
  implicit none
  !--- arguments -------------------------------------
  type(Param_type) :: p
  type(Coord_type) :: c
  !--- local -----------------------------------------
  type(Energy_type) :: e
  type(Average_type) :: avg
  integer i_step, i, ix, iy, iz
  character(100), parameter :: fmt_time_step = &
  & "('TIME_STEP ',i7,' ---------------------------------------------------')"
  character (len=85) :: message
  character (len=120) :: fn, fn_avg
  real*8 kelvin
  !--- END of variable definitions -------------------
  call msg(6, __FILE__, __LINE__, 'BEGIN', ': MD')

  write(fn_avg,'(a,a)') trim(p%filename), '.avg'
  open(unit=UNIT_AVG,file=fn_avg, status='REPLACE')

  kelvin = p%kelvin_start
  call msg_ez(6, &
    & 'INITIALIZE COORDINATES ==============================================================')
  call initialize_E_field(p,c)
  call initialize_dipoR(p,c,e)
  call write_Energy(p,c,e,6)
  write(message,"('strain',6e13.5)") c%strain(:)
  call msg_ez(6,message)

  do while ( (kelvin-p%kelvin_goal)*(p%kelvin_goal-p%kelvin_start) .le. 0.0d0 )

     write(message,'(f5.1,a)') kelvin, ' [K] ============================================='
     call msg(6, __FILE__, __LINE__, 'T = ', message)

     p%temperature_eV = kelvin / KELVIN_EV

     c%H0 = 0.0d0
     call Nose_Poincare_Hamiltonian(p,c,e)
     c%H0 = e%H_Nose_Poincare/c%s_Nose
     call Nose_Poincare_Hamiltonian(p,c,e)

     call reset_Average(avg)

     do i_step = 1, p%n_thermalize+p%n_average
        write(message,fmt_time_step) i_step; call msg_ez(6,message)

        !=== Swich on the external constant electric field ===================================
        if (i_step.eq.p%n_external_E_switch_on .and. p%external_E_field_frequency.eq.0.0d0) then
           do iz = 0, p%Lz-1
              do iy = 0, p%Ly-1
                 do ix = 0, p%Lx-1
                    c%E_field(ix,iy,iz,:) = c%E_field(ix,iy,iz,:) + p%external_E_field(:)
                 end do
              end do
           end do
           !call dipole_E_field_energy(p,c,e)
           !c%H0 = 0.0d0
           !call Nose_Poincare_Hamiltonian(p,c,e)
           !c%H0 = e%H_Nose_Poincare/c%s_Nose
           !call Nose_Poincare_Hamiltonian(p,c,e)
        end if

        !=== Swich on the external alternating electric field ================================
        if (i_step.gt.p%n_external_E_switch_on .and. p%external_E_field_frequency.gt.0.0d0) then
           stop ': Not implemented: alternating external electric field is not implemented yet.'
        end if

        !call leapfrog(p,c,e)       ! For debug. Total energy is the conservation value
        call nose_poincare(p,c,e)   ! H_Nose_Poincare == 0, always

        if (i_step-(i_step/p%n_coord_freq)*p%n_coord_freq.eq.0) then
           write(fn,'(a,a,i3.3,a,i7.7,a)') trim(p%filename), '.', int(kelvin), 'K', i_step, '.coord'
           call write_system(p,c,fn)
        end if

        write(message,"('strain',6e13.5)") c%strain(:)
        call msg_ez(6,message)

        !=== For debug =========================================================
        write(message,'(a,3e15.7)') 'dipoR(0,0,4,i)=', (c%dipoR(0,0,4,i), i=1,3)
        call msg_ez(6,message)
        write(message,'(a,3e15.7)') 'dVddi(0,0,4,i)=', (c%dVddi(0,0,4,i), i=1,3)
        call msg_ez(6,message)

        call write_Energy(p,c,e,6)

        if (i_step<=p%n_thermalize) cycle

        if (i_step.eq.p%n_thermalize+1) then
           call msg(6, __FILE__, __LINE__, 'AVERAGING', ' is started from this time step.')
        end if

        call add_to_Average(p,c,e,avg)
     end do

     call msg_ez(6,'END of ITERATIONS ---------------------------------------------------')
     call divide_and_write_Average(p,avg,kelvin)

     kelvin = kelvin + p%kelvin_step
  end do

  close(UNIT_AVG)
  call msg(6, __FILE__, __LINE__, 'END', ': MD')
end subroutine molecular_dynamics
