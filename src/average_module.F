! average_module.F -*-f90-*-
! Time-stamp: <2007-08-08 08:02:36 t-nissie>
! Author: Takeshi NISHIMATSU
!!
#include "define.h"
module Average_module
  type Average_type
     real*8 total_energy
     real*8 strain(6)
     real*8 sorted_strain(6)
     real*8 polarization(3)             ! <u_alpha>
     real*8 abs_polarization(3)
     real*8 didiK000pUC(6)              ! <u_alpha*u_beta>
     real*8 correlation(N_CORRELATION)  ! <u_z(i,j)*(u_z(i+l,j)+u_z(i,j+l))/2> - <u_z>**2
  end type Average_type

contains
  subroutine reset_Average(avg)
    implicit none
    !--- arguments -------------------------------------
    type(Average_type), intent(inout) :: avg
    !--- END of variable definitions -------------------
    avg%total_energy        = 0.0d0
    avg%strain(:)           = 0.0d0
    avg%sorted_strain(:)    = 0.0d0
    avg%polarization(:)     = 0.0d0
    avg%abs_polarization(:) = 0.0d0
    avg%didiK000pUC(:)      = 0.0d0
    avg%correlation(:)      = 0.0d0
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
    real*8 corr(N_CORRELATION)
    real*8 strain_tmp(6), polarization_tmp(3)
    character(90) message
    !--- END of variable definitions -------------------
    avg%total_energy    = avg%total_energy    + e%total

    strain_tmp(:) = c%strain(:)
    call quicksort(strain_tmp,1,3)
    call quicksort(strain_tmp,4,6)
    avg%strain(:)        = avg%strain(:)        + c%strain(:)
    avg%sorted_strain(:) = avg%sorted_strain(:) + strain_tmp(:)

    if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
       do alpha = 1, 3
          if (p%gap.eq.0) then
             polarization_tmp(alpha) = SUM(c%dipoR(:,:,0:p%film_thickness-1,alpha))
          else
             polarization_tmp(alpha) = SUM(c%dipoR(:,:,(p%gap+1)/2:p%gap/2+p%film_thickness,alpha))
          end if
       end do
    else
       polarization_tmp(:) = dble(c%dipoK(0,0,0,:))
    end if
    avg%polarization(:)     = avg%polarization(:)     +     polarization_tmp(:)
    avg%abs_polarization(:) = avg%abs_polarization(:) + abs(polarization_tmp(:))
    write(message,"('polarization=',3e13.5)") polarization_tmp(:)
    call msg_ez(6,message)

    avg%didiK000pUC(:)  = avg%didiK000pUC(:)  + dble(c%didiK(0,0,0,:))

    if (p%bulk_or_film.eq.'epit') then
       call correlation(p,c,corr)
       avg%correlation(:)  = avg%correlation(:)  + corr(:)
    end if
  end subroutine add_to_Average

  subroutine correlation(p,c,corr)
    use Param_module
    use Coord_module
    implicit none
    !--- arguments -------------------------------------
    type(Param_type),   intent(in)    :: p
    type(Coord_type),   intent(in)    :: c
    real*8 corr(N_CORRELATION)
    !--- local -----------------------------------------
    integer z, l, ix, iy, ixl, iyl
    real*8 pz
    character(100) message
    !--- END of variable definitions -------------------
    z = p%Lz/4

    pz = SUM( c%dipoR(:,:,z,3) )/(p%Lx*p%Ly)

    corr(:) = 0.0d0
    do l = 1, N_CORRELATION
       do iy = 0, p%Ly-1
          iyl=iy+l; if (iyl.ge.p%Ly) iyl=iyl-p%Ly
          do ix = 0, p%Lx-1
             ixl=ix+l; if (ixl.ge.p%Lx) ixl=ixl-p%Lx
             corr(l) = corr(l) + c%dipoR(ix,iy,z,3)*(c%dipoR(ixl,iy,z,3)+c%dipoR(ix,iyl,z,3))
          end do
       end do
       corr(l) = corr(l)/(2*p%Lx*p%Ly) - pz**2
    end do
    write(message,"('pz-corr(:)=',6e13.5)") pz,(corr(ix),ix=1,5)
    call msg_ez(6,message)
  end subroutine correlation

  subroutine divide_and_write_Average(p,avg,kelvin)
    use Param_module
    implicit none
    !--- arguments -------------------------------------
    type(Param_type),   intent(in)    :: p
    type(Average_type), intent(inout) :: avg
    real*8 kelvin
    !--- END of variable definitions -------------------
    if (p%n_average.eq.0) return

    avg%total_energy    = avg%total_energy    / p%n_average / p%N

    avg%strain(:)       = avg%strain(:)       / p%n_average
    avg%sorted_strain(:)= avg%sorted_strain(:)/ p%n_average

    if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
       avg%polarization(:)     = avg%polarization(:)     /p%n_average /(p%Lx*p%Ly*p%film_thickness)
       avg%abs_polarization(:) = avg%abs_polarization(:) /p%n_average /(p%Lx*p%Ly*p%film_thickness)
    else
       avg%polarization(:)     = avg%polarization(:)     /p%n_average /p%N
       avg%abs_polarization(:) = avg%abs_polarization(:) /p%n_average /p%N
    end if

    if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
       avg%didiK000pUC(:)  = avg%didiK000pUC(:) / p%n_average / (p%Lx*p%Ly*p%film_thickness*2)
    else
       avg%didiK000pUC(:)  = avg%didiK000pUC(:) / p%n_average / p%N
    end if

    avg%correlation(:)  = avg%correlation(:) / p%n_average

    write(UNIT_AVG,"(f6.1,' avg%total_energy'    ,1e13.5)") kelvin, avg%total_energy
    write(UNIT_AVG,"(f6.1,' avg%strain'          ,6e13.5)") kelvin, avg%strain(:)
    write(UNIT_AVG,"(f6.1,' avg%sorted_strain'   ,6e13.5)") kelvin, avg%sorted_strain(:)
    write(UNIT_AVG,"(f6.1,' avg%polarization'    ,3e15.7)") kelvin, avg%polarization(:)
    write(UNIT_AVG,"(f6.1,' avg%abs_polarization',3e15.7)") kelvin, avg%abs_polarization(:)
    write(UNIT_AVG,"(f6.1,' avg%didiK000pUC'     ,6e13.5)") kelvin, avg%didiK000pUC(:)
    write(UNIT_AVG,"(f6.1,' avg%correlation'     ,5e13.5)") kelvin, avg%correlation(:)
    call flush(UNIT_AVG)
  end subroutine divide_and_write_Average
end module Average_module
