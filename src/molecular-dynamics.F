! molecular-dynamics.F -*-f90-*-
! Time-stamp: <2016-06-21 12:30:28 takeshi>
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
  use wave_module
  use msg_module
  implicit none
  !--- arguments -------------------------------------
  type(Param_type) :: p
  type(Coord_type) :: c
  !--- local -----------------------------------------
  type(Energy_type) :: e
  type(Average_type) :: avg
  integer i_step, ix, iy, iz, alpha
  real*8 E_field_add(3), u(3)
  character(120), parameter :: fmt_time_step = &
       "('TIME_STEP ',i8,3f16.12,' ------------------------------------------------')"
  character (len=120) :: message
  character (len=120) :: fn
  logical             :: detail
  !--- END of variable definitions -------------------
  call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'MD')

  write(message,'(a,f6.1,a)') 'T = ', p%kelvin, ' [K] BEGIN =========================================================================='
  call msg_ez(UNIT_LOG, message)

  call initialize_E_field(p,c)
  if (.not. p%continue) call initialize_dipoR(p,c,e)

  E_field_add = wave(p%E_wave_type, 0, p%n_thermalize, p%n_E_wave_period, p%external_E_field) !Redundant. The same is in initialize_E_field.F.
  write(message,fmt_time_step) 0, E_field_add
  call msg_ez(UNIT_LOG,message)

  e%total = e%dipo_kinetic/c%s_Nose**2 + e%acou_kinetic + sum_potential_energies(e)
  call write_Energy(p,c,e,UNIT_LOG)
  !write(message,"('strain',6e13.5)") c%strain(:)
  !call msg_ez(UNIT_LOG,message)

  if (p%n_E_wave_period>0) open(unit=UNIT_HL,file=trim(p%filename)//'.hl', status='REPLACE')
  if (p%output_polarization) open(unit=UNIT_POLARIZATION, file=trim(p%filename)//'.polarization', status='REPLACE')

  c%H0 = 0.0d0
  call Nose_Poincare_Hamiltonian(p,c,e)
  c%H0 = e%H_Nose_Poincare/c%s_Nose
  call Nose_Poincare_Hamiltonian(p,c,e)

  call reset_Average(avg)
!$omp parallel do
  do iz = 0,p%Lz-1
     c%dipoRavg(:,:,:,iz) = 0.0d0
  end do
!$omp end parallel do

  do i_step = 1, p%n_thermalize+p%n_average

     if (p%E_wave_type .ne. '') then
        E_field_add(:) = wave(p%E_wave_type, i_step, p%n_thermalize, p%n_E_wave_period, p%external_E_field(:))
!$omp parallel do
        do iz = 0, p%Lz-1
              do iy = 0, p%Ly-1
                 do ix = 0, p%Lx-1
                    c%E_field(:,ix,iy,iz) = c%E_field_local(:,ix,iy,iz) + E_field_add(:)
                 end do
              end do
        end do
!$omp end parallel do
        ! We may need mirror of c%E_field around here.
        if ((  i_step>=p%n_thermalize          .or. &
             & p%E_wave_type .eq. 'ramping_on' .or. &
             & p%E_wave_type .eq. 'ramping_off'     ) .and. mod(i_step-p%n_thermalize, p%n_hl_freq) == 0) then
           do alpha = 1, 3
              u(alpha) = SUM(c%dipoR(alpha,:,:,:), MASK=c%sum_p(:,:,:))
           end do
           u(:) = u(:) / c%n_sum_p
           write(UNIT_HL,"(i10.10,f6.1,3f16.12,9e13.5,6f4.1,1(1e15.5,14e13.5))") &
                i_step,p%kelvin, E_field_add, c%strain(1:6), u(1:3), 0.0d0, 0.0d0, 0.0d0, 0.0d0, 0.0d0, 0.0d0, &
                e%dipo_kinetic    ,&
                e%short_range     ,&
                e%long_range      ,&
                e%dipole_E_field  ,&
                e%unharmonic      ,&
                e%homo_strain     ,&
                e%homo_coupling   ,&
                e%inho_strain     ,&
                e%inho_coupling   ,&
                e%inho_modulation ,&
                e%total           ,&
                e%H_Nose_Poincare ,&
                e%total**2        ,&
                e%dipo_kinetic/c%s_Nose**2 ,&
                e%acou_kinetic
           flush(UNIT_HL)
           write(fn,'(a,a)') trim(p%filename), '.coord'
           call write_system(p,c,fn)
        end if
     end if

     detail = p%verbose>=2 .or. mod(i_step,p%n_coord_freq).eq.0 &
          &   .or. i_step.eq.p%n_thermalize+p%n_average
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

     if (i_step <= p%n_thermalize) cycle

     call add_to_Average(p,c,e,avg,detail)
!$omp parallel do
     do iz = 0,p%Lz-1
        c%dipoRavg(:,:,:,iz) = c%dipoRavg(:,:,:,iz) + c%dipoR(:,:,:,iz)
     end do
!$omp end parallel do
  end do

  call divide_and_write_Average(p,c,avg)
  call divide_and_write_dipoRavg(p,c)

  write(message,'(a,f6.1,a)') 'T = ', p%kelvin, ' [K] END ============================================================================'
  call msg_ez(UNIT_LOG, message)

  if (p%n_E_wave_period>0) close(UNIT_HL)
  if (p%output_polarization) close(UNIT_POLARIZATION)
  call msg(UNIT_LOG, __FILE__, __LINE__, 'END', 'MD')
end subroutine molecular_dynamics
