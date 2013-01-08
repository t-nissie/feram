! molecular-dynamics.F -*-f90-*-
! Time-stamp: <2013-01-08 18:25:56 takeshi>
! Author: Takeshi NISHIMATSU
! ref_1: Bond
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
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
  integer i_step
  character(120), parameter :: fmt_time_step = &
  & "('TIME_STEP ',i7,' ---------------------------------------------------------------------------------')"
  character (len=120) :: message
  character (len=120) :: fn
  logical             :: detail
  !--- END of variable definitions -------------------
  call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'MD')

  write(message,'(a,f6.1,a)') 'T = ', p%kelvin, ' [K] BEGIN ========================================================'
  call msg_ez(UNIT_LOG, message)

  write(message,fmt_time_step) 0; call msg_ez(UNIT_LOG,message)
  call initialize_E_field(p,c)
  call initialize_dipoR(p,c,e)
  e%total = e%dipo_kinetic/c%s_Nose**2 + sum_potential_energies(e)
  call write_Energy(p,c,e,UNIT_LOG)
  !write(message,"('strain',6e13.5)") c%strain(:)
  !call msg_ez(UNIT_LOG,message)


  c%H0 = 0.0d0
  call Nose_Poincare_Hamiltonian(p,c,e)
  c%H0 = e%H_Nose_Poincare/c%s_Nose
  call Nose_Poincare_Hamiltonian(p,c,e)

  call reset_Average(avg)

  do i_step = 1, p%n_thermalize+p%n_thermal_conductivity+p%n_average
     detail = p%verbose>=2 .or. mod(i_step,p%n_coord_freq).eq.0 &
          &   .or. i_step.eq.p%n_thermalize+p%n_thermal_conductivity+p%n_average
     if (detail) then
        write(message,fmt_time_step) i_step; call msg_ez(UNIT_LOG,message)
     end if

     if (p%method.eq.'md ') then
        call nose_poincare(p,c,e)   ! H_Nose_Poincare == 0, always
     else if (p%method.eq.'vs ') then
        call velocity_scaling(p,c,e)
     else if (p%method.eq.'lf ') then
        call leapfrog(p,c,e,i_step)        ! Leapfrog
     end if

     if (mod(i_step,p%n_coord_freq).eq.0) then
        write(   fn,'(a,a,i10.10,a)') trim(p%filename), '.', i_step, '.coord'
        call write_system(p,c,fn)
        if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
           write(fn,'(a,a,i10.10,a)') trim(p%filename), '.', i_step, '.fft'
           call write_fft(p,c,fn)
        end if
     end if

     !write(message,"('strain',6e13.5)") c%strain(:)
     !call msg_ez(UNIT_LOG,message)

     e%total = e%dipo_kinetic/c%s_Nose**2 + sum_potential_energies(e)
     if (detail) then
        call write_Energy(p,c,e,UNIT_LOG)
     end if

     if (i_step <= p%n_thermalize+p%n_thermal_conductivity) cycle

     !if (i_step.eq.p%n_thermalize+1) then
     !   call msg(UNIT_LOG, __FILE__, __LINE__, 'AVERAGING', 'is started from this time step.')
     !end if

     call add_to_Average(p,c,e,avg,detail)
  end do

  write(message,'(a,f6.1,a)') 'T = ', p%kelvin, ' [K] END =========================================================='
  call msg_ez(UNIT_LOG, message)
  call divide_and_write_Average(p,c,avg)

  call msg(UNIT_LOG, __FILE__, __LINE__, 'END', 'MD')
end subroutine molecular_dynamics
