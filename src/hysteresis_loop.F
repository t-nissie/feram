! hysteresis_loop.F -*-f90-*-
! Time-stamp: <2012-04-14 12:03:49 user2001>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
# include "define.h"
subroutine hysteresis_loop(p,c)
  use Param_module
  use Coord_module
  use Energy_module
  implicit none
  !--- arguments -------------------------------------
  type(Param_type) :: p
  type(Coord_type) :: c
  !--- local -----------------------------------------
  type(Energy_type) :: e
  real*8, allocatable :: E_field_initial(:,:,:,:) ! initial external electric field
  real*8 E_field_add(3), u(3)
  integer i_step, ix, iy, iz, alpha
  character(120), parameter :: fmt_time_step = &
       "('TIME_STEP ',i8,3f16.12,' -----------------------------------------------------')"
  character (len=150) :: message
  character (len=120) :: fn_hl, fn_system
  !character (len=126) :: bzip2_command
  !--- END of variable definitions -------------------
  call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'MD')

  allocate(E_field_initial(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 3))

  write(message,'(f5.1,a)') p%kelvin, ' [K] BEGIN ================================================'
  call msg(UNIT_LOG, __FILE__, __LINE__, 'T = ', message)

  call initialize_E_field(p,c)
  E_field_initial = c%E_field
  call initialize_dipoR(p,c,e)
  write(message,fmt_time_step) 0, p%external_E_field
  call msg_ez(UNIT_LOG,message)
  e%total = e%dipo_kinetic + sum_potential_energies(e)
  call write_Energy(p,c,e,UNIT_LOG)
!   write(message,"('strain',6e13.5)") c%strain(:)
!   call msg_ez(UNIT_LOG,message)

  write(fn_hl,'(a,a)') trim(p%filename), '.hl'
  open(unit=UNIT_HL,file=fn_hl, status='REPLACE')

  E_field_add(:) = 0.0d0

  do i_step = p%n_hysteresis_loop_continue, p%n_thermalize+p%n_average
     if (i_step>=p%n_thermalize) then
        E_field_add = -2*p%external_E_field*(i_step-p%n_thermalize)/p%n_average
!$omp parallel do
        do iz = 0, p%Lz-1
           do alpha = 1,3
              do iy = 0, p%Ly-1
                 do ix = 0, p%Lx-1
                    c%E_field(ix,iy,iz,alpha) = E_field_initial(ix,iy,iz,alpha) + E_field_add(alpha)
                 end do
              end do
           end do
        end do
!$omp end parallel do
     end if

     if (p%verbose>=2) then
        call msg_ez(UNIT_LOG,'')
        write(message,fmt_time_step) i_step, p%external_E_field+E_field_add
        call msg_ez(UNIT_LOG,message)
     end if

     call velocity_scaling(p,c,e)

     e%total = e%dipo_kinetic + sum_potential_energies(e)
     if (p%verbose>=2) then
        call write_Energy(p,c,e,UNIT_LOG)
     end if

     if (i_step>=p%n_thermalize) then
        if (mod(i_step-p%n_thermalize, p%n_hl_freq) == 0) then
           do alpha = 1, 3
              u(alpha) = SUM(c%dipoR(:,:,:,alpha), MASK=c%sum_p(:,:,:))
           end do
           u(:) = u(:) / c%n_sum_p
           write(UNIT_HL,"(i10.10,f6.1,3f16.12,9e13.5)") &
                i_step,p%kelvin, p%external_E_field+E_field_add, c%strain(1:6), u(1:3)
           call flush(UNIT_HL)
           write(fn_system,'(a,a)') trim(p%filename), '.coord'
           call write_system(p,c,fn_system)
        end if
        if (mod(i_step-p%n_thermalize, p%n_coord_freq) == 0) then
           write(fn_system,'(a,a,i10.10,a)') trim(p%filename), '.', i_step, '.coord'
           call write_system(p,c,fn_system)
           !write(bzip2_command,'(a,a)') 'bzip2 ', trim(fn_system)
           !call system(bzip2_command)
        end if
     end if
  end do

  close(UNIT_HL)

  write(message,'(f5.1,a)') p%kelvin, ' [K] END =================================================='
  call msg(UNIT_LOG, __FILE__, __LINE__, 'T = ', message)

  deallocate(E_field_initial)
  call msg(UNIT_LOG, __FILE__, __LINE__, 'END', 'MD')
end subroutine hysteresis_loop
