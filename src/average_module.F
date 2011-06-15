! average_module.F -*-f90-*-
! Time-stamp: <2011-06-15 18:31:28 takeshi>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
#include "define.h"
module Average_module
  use Energy_module
  implicit none
  type Average_type
     type(Energy_type) energy    
     real*8 e2
     real*8 dipo_kinetic_true
     real*8 strain(6)
     real*8 u(3)
     real*8 uu(6)
     real*8 e_layer(0:10000)
  end type Average_type

contains
  subroutine reset_Average(avg)
    implicit none
    !--- arguments -------------------------------------
    type(Average_type), intent(inout) :: avg
    !--- END of variable definitions -------------------
    avg%energy            = Energy_type(0.0d0, 0.0d0, 0.0d0, 0.0d0, 0.0d0, 0.0d0, 0.0d0, 0.0d0, 0.0d0, 0.0d0)
    avg%e2                = 0.0d0
    avg%dipo_kinetic_true = 0.0d0
    avg%strain(:)         = 0.0d0
    avg%u(:)              = 0.0d0
    avg%uu(:)             = 0.0d0
    avg%e_layer(:)        = 0.0d0
  end subroutine reset_Average

  subroutine add_to_Average(p,c,e,avg) ! We use p implicitly. Don't worry about compile warning on it.
    use Param_module
    use Coord_module
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
    avg%energy            = avg%energy            + e
    avg%e2                = avg%e2                + e%total**2
    avg%dipo_kinetic_true = avg%dipo_kinetic_true + e%dipo_kinetic/c%s_Nose**2
    avg%strain(:)         = avg%strain(:)         + c%strain(:)

    if (p%method.eq.'lf ') then
       avg%e_layer(0:p%Lz-1)   = avg%e_layer(0:p%Lz-1)   + c%e_layer(0:p%Lz-1)
    end if

    do alpha = 1, 3
       u_tmp(alpha) = SUM(c%dipoR(:,:,:,alpha), MASK=c%sum_p(:,:,:))
    end do

    avg%u(:) = avg%u(:) + u_tmp(:)
    avg%uu(1) = avg%uu(1) + u_tmp(1)**2
    avg%uu(2) = avg%uu(2) + u_tmp(2)**2
    avg%uu(3) = avg%uu(3) + u_tmp(3)**2
    avg%uu(4) = avg%uu(4) + u_tmp(2)*u_tmp(3)
    avg%uu(5) = avg%uu(5) + u_tmp(3)*u_tmp(1)
    avg%uu(6) = avg%uu(6) + u_tmp(1)*u_tmp(2)

#if defined(DETAILED_MESSAGES)
    write(message,"('u=',3e13.5)") u_tmp(:)
    call msg_ez(UNIT_LOG,message)
#endif
  end subroutine add_to_Average

  subroutine divide_and_write_Average(p,c,avg)
    use Param_module
    use Coord_module
    implicit none
    type(Param_type),   intent(in)    :: p
    type(Coord_type),   intent(in)    :: c
    type(Average_type), intent(inout) :: avg
    character (len=120)               :: fn_avg
    character (len=200)               :: fn_T_layer
    real*8                            :: kelvin
    integer                           :: i

    if (p%n_average.eq.0) return

    avg%energy = div_energy(avg%energy, p%n_average)
    avg%energy = div_energy(avg%energy, p%N)
    avg%e2                = avg%e2                / p%n_average / p%N
    avg%dipo_kinetic_true = avg%dipo_kinetic_true / p%n_average / p%N

    avg%strain(:) = avg%strain(:) / p%n_average

    if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
       avg%u(:)  = avg%u(:)  / p%n_average / c%n_sum_p
       avg%uu(:) = avg%uu(:) / p%n_average / c%n_sum_p
    else
       avg%u(:)  = avg%u(:)  / p%n_average / p%N
       avg%uu(:) = avg%uu(:) / p%n_average / p%N
    end if

    if (p%method.eq.'lf ') then
       kelvin = avg%dipo_kinetic_true * 0.666666666666666666666666666667d0 * KELVIN_EV
       avg%e_layer(0:p%Lz) = avg%e_layer(0:p%Lz) / p%n_average
    else
       kelvin = p%kelvin
    end if

    write(fn_avg,'(a,a)') trim(p%filename), '.avg'
    open(unit=UNIT_AVG,file=fn_avg, status='REPLACE')

    write(UNIT_AVG,"(f6.1,3f9.5,1(e15.5,5e13.5),1(e15.5,2e13.5),1(e15.5,5e13.5),1(1e15.5,11e13.5))")&
         kelvin, p%external_E_field(1:3), avg%strain(1:6), avg%u(1:3), avg%uu(1:6),&
         avg%energy%dipo_kinetic    ,&
         avg%energy%dipole_dipole   ,&
         avg%energy%dipole_E_field  ,&
         avg%energy%unharmonic      ,&
         avg%energy%homo_strain     ,&
         avg%energy%homo_coupling   ,&
         avg%energy%inho_strain     ,&
         avg%energy%inho_coupling   ,&
         avg%energy%total           ,&
         avg%energy%H_Nose_Poincare ,&
         avg%e2                     ,&
         avg%dipo_kinetic_true

    close(UNIT_AVG)

    write(fn_T_layer,'(a,a)') trim(p%filename), '.T_layer'
    open(UNIT=UNIT_T_LAYER,FILE=fn_T_layer)
    do i=0,p%Lz-1
       write(UNIT_T_LAYER,'(i9,f13.8)') i, avg%e_layer(i) / p%Lx / p%Ly * 0.666666666666666666666666666667d0 * KELVIN_EV
    end do
    close(UNIT_T_LAYER)
  end subroutine divide_and_write_Average
end module Average_module
