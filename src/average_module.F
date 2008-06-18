! average_module.F -*-f90-*-
! Time-stamp: <2008-06-12 10:21:57 takeshi>
! Author: Takeshi NISHIMATSU
!!
#include "define.h"
module Average_module
  type Average_type
     real*8 total_energy
     real*8 e2
     real*8 strain(6)
     real*8 u(3)
     real*8 uu(6)
  end type Average_type

contains
  subroutine reset_Average(avg)
    implicit none
    !--- arguments -------------------------------------
    type(Average_type), intent(inout) :: avg
    !--- END of variable definitions -------------------
    avg%total_energy = 0.0d0
    avg%e2           = 0.0d0
    avg%strain(:)    = 0.0d0
    avg%u(:)         = 0.0d0
    avg%uu(:)        = 0.0d0
  end subroutine reset_Average

  subroutine add_to_Average(p,c,e,avg) ! We use p implicitly. Don't worry about compile warning on it.
    use Param_module
    use Coord_module
    use Energy_module
    implicit none
    !--- arguments -------------------------------------
    type(Param_type),   intent(in)    :: p
    type(Coord_type),   intent(in)    :: c
    type(Energy_type),  intent(in)    :: e
    type(Average_type), intent(inout) :: avg
    !--- local -----------------------------------------
    integer alpha
    real*8 u_tmp(3)
    character(90) message
    !--- END of variable definitions -------------------
    avg%total_energy    = avg%total_energy  + e%total
    avg%e2              = avg%e2            + e%total**2
    avg%strain(:)       = avg%strain(:)     + c%strain(:)

    if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
       do alpha = 1, 3
          if (p%gap.eq.0) then
             u_tmp(alpha) = SUM(c%dipoR(:,:,0:p%film_thickness-1,alpha))
          else
             u_tmp(alpha) = SUM(c%dipoR(:,:,(p%gap+1)/2:p%gap/2+p%film_thickness,alpha))
          end if
       end do
    else
       u_tmp(:) = dble(c%dipoK(0,0,0,:))
    end if

    avg%u(:) = avg%u(:) + u_tmp(:)
    avg%uu(1) = avg%uu(1) + u_tmp(1)**2
    avg%uu(2) = avg%uu(2) + u_tmp(2)**2
    avg%uu(3) = avg%uu(3) + u_tmp(3)**2
    avg%uu(4) = avg%uu(4) + u_tmp(2)*u_tmp(3)
    avg%uu(5) = avg%uu(5) + u_tmp(3)*u_tmp(1)
    avg%uu(6) = avg%uu(6) + u_tmp(1)*u_tmp(2)

    write(message,"('u=',3e13.5)") u_tmp(:)
    call msg_ez(6,message)

  end subroutine add_to_Average

  subroutine divide_and_write_Average(p,avg)
    use Param_module
    implicit none
    type(Param_type),   intent(in)    :: p
    type(Average_type), intent(inout) :: avg
    character (len=120)               :: fn_avg

    if (p%n_average.eq.0) return

    avg%total_energy    = avg%total_energy    / p%n_average / p%N
    avg%e2              = avg%e2              / p%n_average / p%N

    avg%strain(:)       = avg%strain(:)       / p%n_average

    if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
       avg%u(:)  = avg%u(:)  /p%n_average /(p%Lx*p%Ly*p%film_thickness)
       avg%uu(:) = avg%uu(:) /p%n_average /(p%Lx*p%Ly*p%film_thickness)
    else
       avg%u(:)  = avg%u(:)  /p%n_average /p%N
       avg%uu(:) = avg%uu(:) /p%n_average /p%N
    end if




    write(fn_avg,'(a,a)') trim(p%filename), '.avg'
    open(unit=UNIT_AVG,file=fn_avg, status='REPLACE')

    write(UNIT_AVG,"(f6.1,3f9.5,17e13.5)"),&
         p%kelvin, p%external_E_field(1:3), avg%total_energy, avg%e2, avg%strain(1:6),&
         avg%u(1:3), avg%uu(1:6)

    close(UNIT_AVG)
  end subroutine divide_and_write_Average
end module Average_module
