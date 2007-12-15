! molecular-dynamics.F -*-f90-*-
! Time-stamp: <2007-12-15 12:19:04 takeshi>
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
  integer i_step, i
  character(120), parameter :: fmt_time_step = &
  & "('TIME_STEP ',i7,' ---------------------------------------------------------------------------------')"
  character (len=120) :: message
  character (len=120) :: fn, fn_avg
  !--- END of variable definitions -------------------
  call msg(6, __FILE__, __LINE__, 'BEGIN', ': MD')

  write(message,'(f5.1,a)') p%kelvin, ' [K] BEGIN ========================================================'
  call msg(6, __FILE__, __LINE__, 'T = ', message)

  write(message,fmt_time_step) 0; call msg_ez(6,message)
  call initialize_E_field(p,c)
  call initialize_dipoR(p,c,e)
  call write_Energy(p,c,e,6)
  write(message,"('strain',6e13.5)") c%strain(:)
  call msg_ez(6,message)


  c%H0 = 0.0d0
  call Nose_Poincare_Hamiltonian(p,c,e)
  c%H0 = e%H_Nose_Poincare/c%s_Nose
  call Nose_Poincare_Hamiltonian(p,c,e)

  call reset_Average(avg)

  do i_step = 1, p%n_thermalize+p%n_average
     write(message,fmt_time_step) i_step; call msg_ez(6,message)

     !call leapfrog(p,c,e)       ! For debug. Total energy is the conservation value
     call nose_poincare(p,c,e)   ! H_Nose_Poincare == 0, always

     if (i_step-(i_step/p%n_coord_freq)*p%n_coord_freq.eq.0) then
        write(fn,'(a,a,i7.7,a)') trim(p%filename), '.', i_step, '.coord'
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

  write(message,'(f5.1,a)') p%kelvin, ' [K] END =========================================================='
  call msg(6, __FILE__, __LINE__, 'T = ', message)
  call divide_and_write_Average(p,avg)

  call msg(6, __FILE__, __LINE__, 'END', ': MD')
end subroutine molecular_dynamics
