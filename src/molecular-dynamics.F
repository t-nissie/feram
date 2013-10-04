! molecular-dynamics.F -*-f90-*-
! Time-stamp: <2013-10-04 12:32:15 takeshi>
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
  integer i_step, ix, iy, iz, alpha
  real*8 E_field_add(3)
  character(120), parameter :: fmt_time_step = &
       "('TIME_STEP ',i8,3f16.12,' -----------------------------------------------------')"
  character (len=120) :: message
  character (len=120) :: fn
  logical             :: detail
  !--- END of variable definitions -------------------
  call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'MD')

  E_field_add = 0.0d0

  write(message,'(a,f6.1,a)') 'T = ', p%kelvin, ' [K] BEGIN ========================================================'
  call msg_ez(UNIT_LOG, message)

  call initialize_E_field(p,c)
  call initialize_dipoR(p,c,e)

  if (p%E_wave.eq.'triangular_sin' .or. p%E_wave.eq.'sin') then
     write(message,fmt_time_step) 0, 0.0d0
  else
     write(message,fmt_time_step) 0, p%external_E_field
  end if
  call msg_ez(UNIT_LOG,message)

  e%total = e%dipo_kinetic/c%s_Nose**2 + e%acou_kinetic + sum_potential_energies(e)
  call write_Energy(p,c,e,UNIT_LOG)
  !write(message,"('strain',6e13.5)") c%strain(:)
  !call msg_ez(UNIT_LOG,message)


  c%H0 = 0.0d0
  call Nose_Poincare_Hamiltonian(p,c,e)
  c%H0 = e%H_Nose_Poincare/c%s_Nose
  call Nose_Poincare_Hamiltonian(p,c,e)

  call reset_Average(avg)

  do i_step = 1, p%n_thermalize+p%n_thermal_conductivity+p%n_average

     if (p%n_E_wave_period>0 .and. i_step>=p%n_thermalize) then
        if (p%E_wave.eq.'triangular_cos') then
           E_field_add = abs(mod((i_step-p%n_thermalize)                      ,p%n_E_wave_period)-p%n_E_wave_period/2)-p%n_E_wave_period/4
        else
           E_field_add = abs(mod((i_step-p%n_thermalize+3*p%n_E_wave_period/4),p%n_E_wave_period)-p%n_E_wave_period/2)-p%n_E_wave_period/4
        end if
        E_field_add = p%external_E_field * E_field_add / (p%n_E_wave_period/4.0)
!$omp parallel do
        do iz = 0, p%Lz-1
           do alpha = 1,3
              do iy = 0, p%Ly-1
                 do ix = 0, p%Lx-1
                    c%E_field(ix,iy,iz,alpha) = c%E_field_local(ix,iy,iz,alpha) + E_field_add(alpha)
                 end do
              end do
           end do
        end do
!$omp end parallel do
     end if

     ! Needs mirror of c%E_field around here, maybe.

     detail = p%verbose>=2 .or. mod(i_step,p%n_coord_freq).eq.0 &
          &   .or. i_step.eq.p%n_thermalize+p%n_thermal_conductivity+p%n_average
     if (detail) then
        write(message,fmt_time_step) i_step, E_field_add; call msg_ez(UNIT_LOG,message)
     end if

     select case (p%method)
     case ('md')
        call nose_poincare(p,c,e)   ! H_Nose_Poincare == 0, always
     case ('vs')
        call velocity_scaling(p,c,e)
     case ('lf')
        call leapfrog(p,c,e,i_step)        ! Leapfrog
     end select

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

     e%total = e%dipo_kinetic/c%s_Nose**2 + e%acou_kinetic + sum_potential_energies(e)
     if (detail) then
        call write_Energy(p,c,e,UNIT_LOG)
     end if

     if (i_step <= p%n_thermalize+p%n_thermal_conductivity) cycle

     !if (i_step.eq.p%n_thermalize+1) then
     !   call msg(UNIT_LOG, __FILE__, __LINE__, 'AVERAGING', 'is started from this time step.')
     !end if

     call add_to_Average(p,c,e,avg,detail)
  end do

  call divide_and_write_Average(p,c,avg)

  write(message,'(a,f6.1,a)') 'T = ', p%kelvin, ' [K] END =========================================================='
  call msg_ez(UNIT_LOG, message)

  call msg(UNIT_LOG, __FILE__, __LINE__, 'END', 'MD')
end subroutine molecular_dynamics
