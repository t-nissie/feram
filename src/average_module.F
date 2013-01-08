! average_module.F -*-f90-*-
! Time-stamp: <2013-01-08 20:04:20 t-nissie>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
#include "define.h"
module Average_module
  use Energy_module
  implicit none

  real*8,  parameter :: step     = 0.005d0
  real*8,  parameter :: step_inv = 1.0d0/step
  integer, parameter :: max_k    = 99

  type Average_type
     type(Energy_type) energy    
     real*8 e2
     real*8 dipo_kinetic_true
     real*8 strain(6)
     real*8 u(3)
     real*8 uu(6)
     real*8 e_layer(0:10000)
     integer*8, allocatable :: distribution(:,:)   !!! integer*8 !!!
     integer,   allocatable :: distribution3d(:,:,:)
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

    if (allocated(avg%distribution))   deallocate(avg%distribution)
    allocate(avg%distribution(3,-max_k:max_k))
    if (allocated(avg%distribution3d)) deallocate(avg%distribution3d)
    allocate(avg%distribution3d(-max_k:max_k,-max_k:max_k,-max_k:max_k))
    avg%distribution(:,:) = 0
    avg%distribution3d(:,:,:) = 0
  end subroutine reset_Average

  subroutine add_to_Average(p,c,e,avg,detail) ! We use p implicitly. Don't worry about compile warning on it.
    use Param_module
    use Coord_module
    implicit none
    !--- arguments -------------------------------------
    type(Param_type),   intent(in)    :: p
    type(Coord_type),   intent(in)    :: c
    type(Energy_type),  intent(in)    :: e
    type(Average_type), intent(inout) :: avg
    logical,            intent(in)    :: detail
    !--- local -----------------------------------------
    integer alpha,ix,iy,iz,k,kx,ky,kz
    real*8 u_tmp(3),  uu_tmp(3)
    character(90) message
    integer*8 tmp_distribution(3,-max_k:max_k)   !!! integer*8 !!!
    !--- END of variable definitions -------------------
    avg%energy            = avg%energy            + e
    avg%e2                = avg%e2                + e%total**2
    avg%dipo_kinetic_true = avg%dipo_kinetic_true + e%dipo_kinetic/c%s_Nose**2
    avg%strain(:)         = avg%strain(:)         + c%strain(:)

    if (trim(p%method).eq.'lf') then
       avg%e_layer(0:p%Lz-1)   = avg%e_layer(0:p%Lz-1)   + c%e_layer(0:p%Lz-1)
    end if

     u_tmp(1:3) = 0.0d0
    uu_tmp(1:3) = 0.0d0
!$omp parallel do private(iz, iy, ix) reduction(+:u_tmp,uu_tmp)
    do iz = 0, p%Lz-1
       do iy = 0, p%Ly-1
          do ix = 0, p%Lx-1
             if (c%sum_p(ix,iy,iz)) then
                 u_tmp(:) =  u_tmp(:) + c%dipoR(ix,iy,iz,:)
                uu_tmp(:) = uu_tmp(:) + c%dipoR(ix,iy,iz,:)**2
             end if
          end do
       end do
    end do
!$omp end parallel do

    avg%u(:) = avg%u(:) + u_tmp(:)
    avg%uu(1) = avg%uu(1) + u_tmp(1)**2
    avg%uu(2) = avg%uu(2) + u_tmp(2)**2
    avg%uu(3) = avg%uu(3) + u_tmp(3)**2
    avg%uu(4) = avg%uu(4) + u_tmp(2)*u_tmp(3)
    avg%uu(5) = avg%uu(5) + u_tmp(3)*u_tmp(1)
    avg%uu(6) = avg%uu(6) + u_tmp(1)*u_tmp(2)

    if (p%distribution_directory.ne.'never') then
       tmp_distribution(:,:)=0
!$omp parallel do private(iz, iy, ix, alpha) reduction(+:tmp_distribution)
       do iz = 0, p%Lz-1
          do iy = 0, p%Ly-1
             do ix = 0, p%Lx-1
                if (c%sum_p(ix,iy,iz)) then
                   do alpha = 1, 3
                      k = nint(c%dipoR(ix,iy,iz,alpha)*step_inv)
                      if (abs(k)<=max_k) tmp_distribution(alpha,k) = tmp_distribution(alpha,k) + 1
                   end do
                end if
             end do
          end do
       end do
!$omp end parallel do
       avg%distribution(:,:) = avg%distribution(:,:) + tmp_distribution(:,:)

       do iz = 0, p%Lz-1
          do iy = 0, p%Ly-1
             do ix = 0, p%Lx-1
                if (c%sum_p(ix,iy,iz)) then
                   kx = nint(c%dipoR(ix,iy,iz,1)*step_inv); if (abs(kx)>max_k) cycle
                   ky = nint(c%dipoR(ix,iy,iz,2)*step_inv); if (abs(ky)>max_k) cycle
                   kz = nint(c%dipoR(ix,iy,iz,3)*step_inv); if (abs(kz)>max_k) cycle
                   avg%distribution3d(kx,ky,kz) = avg%distribution3d(kx,ky,kz) + 1
                end if
             end do
          end do
       end do
    end if

    if (detail) then
       u_tmp(:) = u_tmp(:) / c%n_sum_p
       write(message,'("<u>   =",3f10.6)') u_tmp(1:3)
       call msg_ez(UNIT_LOG,message)
       write(message,'("sigma =",3f10.6)') sqrt(uu_tmp(1:3)/c%n_sum_p - u_tmp(1:3)**2)
       call msg_ez(UNIT_LOG,message)
    end if
  end subroutine add_to_Average

  subroutine divide_and_write_Average(p,c,avg)
    use Param_module
    use Coord_module
    implicit none
    type(Param_type),   intent(in)    :: p
    type(Coord_type),   intent(in)    :: c
    type(Average_type), intent(inout) :: avg
    character (len=FILE_NAME_LEN)     :: fn_avg, fn_tmp, fn_T_layer
    real*8                            :: kelvin
    integer                           :: i,k,kx,ky,kz

    call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'divide_and_write_Average().')

    if (p%n_average.eq.0) then
       call msg(UNIT_LOG, __FILE__, __LINE__, 'END', 'divide_and_write_Average() immediately, because n_average=0.')
       return
    end if

    avg%energy = div_Energy(avg%energy, p%n_average)
    avg%energy = div_Energy(avg%energy, p%N)
    avg%e2                = avg%e2                / p%n_average * p%Ninv
    avg%dipo_kinetic_true = avg%dipo_kinetic_true / p%n_average * p%Ninv

    avg%strain(:) = avg%strain(:) / p%n_average

    if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
       avg%u(:)  = avg%u(:)  / p%n_average / c%n_sum_p
       avg%uu(:) = avg%uu(:) / p%n_average / c%n_sum_p
    else
       avg%u(:)  = avg%u(:)  / p%n_average * p%Ninv
       avg%uu(:) = avg%uu(:) / p%n_average * p%Ninv
    end if

    if (trim(p%method).eq.'lf') then
       kelvin = avg%dipo_kinetic_true * 0.666666666666666666666666666667d0 * KELVIN_EV
       avg%e_layer(0:p%Lz) = avg%e_layer(0:p%Lz) / p%n_average
       write(fn_T_layer,'(a,a)') trim(p%filename), '.T_layer'
       call msg(UNIT_LOG, __FILE__, __LINE__, 'FILE', fn_T_layer)
       open(UNIT=UNIT_T_LAYER,FILE=fn_T_layer)
       do i=0,p%Lz-1
          write(UNIT_T_LAYER,'(i9,f13.8)') i, avg%e_layer(i) / p%Lx / p%Ly * 0.666666666666666666666666666667d0 * KELVIN_EV
       end do
       close(UNIT_T_LAYER)
    else
       kelvin = p%kelvin
    end if

    write(fn_avg,'(a,a)') trim(p%filename), '.avg'
    call msg(UNIT_LOG, __FILE__, __LINE__, 'FILE', fn_avg)
    open(unit=UNIT_AVG,file=fn_avg, status='REPLACE')
    write(UNIT_AVG,"(f7.2,3f9.5,1(e15.5,5e13.5),1(e15.5,2e13.5),1(e15.5,5e13.5),1(1e15.5,11e13.5))")&
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

    if (p%distribution_directory.eq.'never') then
       call msg(UNIT_LOG, __FILE__, __LINE__, 'FILE', 'never write .distribution and .distribution3d files.')
    else
       if (p%distribution_directory.eq.'') then
          fn_tmp = trim(p%filename)
       else
          fn_tmp = trim(p%distribution_directory) // '/' // trim(p%filename)
       end if

       write(fn_avg,'(a,a)') trim(fn_tmp), '.distribution'
       call msg(UNIT_LOG, __FILE__, __LINE__, 'FILE', fn_avg)
       open(unit=UNIT_AVG,file=fn_avg, status='REPLACE')
       do k = -max_k, max_k
          write(UNIT_AVG,'(f7.4,3f12.7)') step*k, dble(avg%distribution(:,k)) * step_inv / c%n_sum_p / p%n_average
       end do
       close(UNIT_AVG)

       write(fn_avg,'(a,a)') trim(fn_tmp), '.distribution3d'
       call msg(UNIT_LOG, __FILE__, __LINE__, 'FILE', fn_avg)
       open(unit=UNIT_AVG,file=fn_avg, status='REPLACE')
       do kz = -max_k, max_k
          do ky = -max_k, max_k
             do kx = -max_k, max_k
                write(UNIT_AVG,'(i3,2i4,e11.5e1)') kx,ky,kz, dble(avg%distribution3d(kx,ky,kz)) * step_inv**3 / c%n_sum_p / p%n_average
             end do
          end do
       end do
       close(UNIT_AVG)
    end if

    call msg(UNIT_LOG, __FILE__, __LINE__, 'END', 'divide_and_write_Average().')
  end subroutine divide_and_write_Average
end module Average_module
