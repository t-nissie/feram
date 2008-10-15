! hysteresis_loop.F -*-f90-*-
! Time-stamp: <2008-10-14 20:26:14 takeshi>
! Author: Takeshi NISHIMATSU
!!
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
  real*8 E_field_add(3),u(3),uu(6)
  integer i_step, ix, iy, iz
  character(120), parameter :: fmt_time_step = &
       "('TIME_STEP ',i8,3f16.12,' -----------------------------------------------------')"
  character (len=150) :: message
  character (len=120) :: fn_hl
  !--- END of variable definitions -------------------
  call msg(6, __FILE__, __LINE__, 'BEGIN', ': MD')

  allocate(E_field_initial(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 3))

  write(message,'(f5.1,a)') p%kelvin, ' [K] BEGIN ========================================================'
  call msg(6, __FILE__, __LINE__, 'T = ', message)


  call initialize_E_field(p,c)
  E_field_initial = c%E_field
  call initialize_dipoR(p,c,e)
  write(message,fmt_time_step) 0, p%external_E_field
  call msg_ez(6,message)
  call write_Energy(p,c,e,6)
!   write(message,"('strain',6e13.5)") c%strain(:)
!   call msg_ez(6,message)


  write(fn_hl,'(a,a)') trim(p%filename), '.hl'
  open(unit=UNIT_HL,file=fn_hl, status='REPLACE')

  do i_step = 1, p%n_thermalize+p%n_average

     if (i_step>p%n_thermalize) then
        E_field_add = -2*p%external_E_field*(i_step-p%n_thermalize)/p%n_average
        do iz = 0, p%Lz-1
           do iy = 0, p%Ly-1
              do ix = 0, p%Lx-1
                 c%E_field(ix,iy,iz,:) = E_field_initial(ix,iy,iz,:) + E_field_add(:)
              end do
           end do
        end do
     end if

     call msg_ez(6,'')
     write(message,fmt_time_step) i_step, p%external_E_field+E_field_add
     call msg_ez(6,message)

!      if (i_step-(i_step/p%n_coord_freq)*p%n_coord_freq.eq.0) then
!         write(   fn,'(a,a,i7.7,a)') trim(p%filename), '.', i_step, '.coord'
!         call write_system(p,c,fn)
!         if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
!            write(fn,'(a,a,i7.7,a)') trim(p%filename), '.', i_step, '.fft'
!            call write_fft(p,c,fn)
!         end if
!      end if

!      write(message,"('strain',6e13.5)") c%strain(:)
!      call msg_ez(6,message)

!      !=== For debug =========================================================
!      write(message,'(a,3e15.7)') 'dipoR(0,0,4,i)=', (c%dipoR(0,0,4,i), i=1,3)
!      call msg_ez(6,message)
!      write(message,'(a,3e15.7)') 'dVddi(0,0,4,i)=', (c%dVddi(0,0,4,i), i=1,3)
!      call msg_ez(6,message)


     call write_Energy(p,c,e,6)

     if (i_step>=p%n_thermalize .and. mod(i_step,p%n_coord_freq)==0) then
        u(:)  = real(c%dipoK(0,0,0,1:3))
        if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
           u(:)  = u(:)  / (p%Lx*p%Ly*p%film_thickness)
           uu(:) = uu(:) / (p%Lx*p%Ly*p%film_thickness)
        else
           u(:)  = u(:)  / p%N
           uu(:) = uu(:) / p%N
        end if
        write(UNIT_HL,"(f6.1,3f16.12,9e13.5)") p%kelvin, p%external_E_field+E_field_add, c%strain(1:6), u(1:3)
     end if
  end do

  close(UNIT_HL)

  write(message,'(f5.1,a)') p%kelvin, ' [K] END =========================================================='
  call msg(6, __FILE__, __LINE__, 'T = ', message)

  deallocate(E_field_initial)
  call msg(6, __FILE__, __LINE__, 'END', ': MD')
end subroutine hysteresis_loop
