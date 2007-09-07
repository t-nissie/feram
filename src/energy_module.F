! energy.F -*-f90-*-
! Time-stamp: <2007-08-08 14:17:58 t-nissie>
! Author: Takeshi NISHIMATSU
!!
module Energy_module
  type Energy_type
     ! energy per unit cell   ! calculated in
     real*8 dipo_kinetic      ! leapfrog.F or nose-poincare.F, initialize in initialize_dipoR.F
     real*8 dipole_dipole     ! subroutine write_Energy() below
     real*8 dipole_E_field    ! -m.E, dVddi_E_field.F
     real*8 unharmonic        ! unharmonic.F
     real*8 homo_strain       ! optimize-homo-strain.F
     real*8 homo_coupling     ! optimize-homo-strain.F
     real*8 inho_strain       ! optimize-inho-strain.F
     real*8 inho_coupling     ! optimize-inho-strain.F
     real*8 total

     real*8 H_Nose_Poincare
  end type Energy_type
!
contains
  subroutine write_Energy(p,c,e,fd)
    use Param_module
    use Coord_module
    implicit none
    !--- arguments -------------------------------------
    type(Param_type),  intent(in)    :: p
    type(Coord_type),  intent(inout) :: c
    type(Energy_type), intent(out)   :: e
    integer fd
    !--- local -----------------------------------------
    character(30), parameter :: fmt = "(a15,f18.12,' [eV/u.c.]')"
    character(45) message
    !--- END of variable definitions -------------------

    e%total = e%dipo_kinetic/c%s_Nose**2  &
          & + e%dipole_dipole &
          & + e%unharmonic    &
          & + e%homo_strain   &
          & + e%homo_coupling &
          & + e%inho_strain   &
          & + e%inho_coupling
    write(message,fmt) 'dipo_kinetic   ', e%dipo_kinetic/c%s_Nose**2/p%N
                                                                 call msg_ez(fd,message)
    write(message,fmt) 'dipole_dipole  ', e%dipole_dipole/p%N;   call msg_ez(fd,message)
    write(message,fmt) 'dipole_E_field ', e%dipole_E_field/p%N;  call msg_ez(fd,message)
    write(message,fmt) 'unharmonic     ', e%unharmonic/p%N;      call msg_ez(fd,message)
    write(message,fmt) 'homo_strain    ', e%homo_strain/p%N;     call msg_ez(fd,message)
    write(message,fmt) 'homo_coupling  ', e%homo_coupling/p%N;   call msg_ez(fd,message)
    write(message,fmt) 'inho_strain    ', e%inho_strain/p%N;     call msg_ez(fd,message)
    write(message,fmt) 'inho_coupling  ', e%inho_coupling/p%N;   call msg_ez(fd,message)
    call msg_ez(fd,'--------------------------------------------')
    write(message,fmt) 'total_energy   ', e%total/p%N;           call msg_ez(fd,message)
    write(message,fmt) 'H_Nose_Poincare', e%H_Nose_Poincare/p%N; call msg_ez(fd,message)

    write(message,'(a7,f14.8,a9,f14.8)') 's_Nose=', c%s_Nose, ' pi_Nose=', c%pi_Nose
    call msg_ez(fd,message)
  end subroutine write_Energy

  subroutine Nose_Poincare_Hamiltonian(p,c,e)
    use Param_module
    use Coord_module
    implicit none
    !--- arguments -------------------------------------
    type(Param_type),  intent(in)    :: p
    type(Coord_type),  intent(inout) :: c
    type(Energy_type), intent(out)   :: e
    !--- local -----------------------------------------
    !real*8 total
    !character(30), parameter :: fmt = "(a14,f16.10,' [eV/u.c.]')"
    !character(45) message
    !--- END of variable definitions -------------------
    e%H_Nose_Poincare = &
       & e%dipo_kinetic / c%s_Nose**2 &
       & + e%dipole_dipole &
       & + e%dipole_E_field&
       & + e%unharmonic    &
       & + e%homo_strain   &
       & + e%homo_coupling &
       & + e%inho_strain   &
       & + e%inho_coupling &
       & + c%pi_Nose**2/2/p%Q_Nose &
       & + 3*p%N*p%temperature_eV*log(c%s_Nose) - c%H0
    e%H_Nose_Poincare = e%H_Nose_Poincare * c%s_Nose
  end subroutine Nose_Poincare_Hamiltonian

  subroutine inhomogeneous_strain_energy(p,c,e,acouK)
    use Param_module
    use Coord_module
    implicit none
    !--- arguments -------------------------------------
    type(Param_type),  intent(in)    :: p
    type(Coord_type),  intent(in)    :: c
    type(Energy_type), intent(inout) :: e
    complex*16  acouK(3, 0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1)
    !--- local -----------------------------------------
    integer alpha,beta, ix,iy,iz
    !--- END of variable definitions -------------------

    e%inho_strain = 0.0d0
    do alpha = 1,3
       do beta = 1,3
          do iz = 0, p%Lz-1
             do iy = 0, p%Ly-1
                !-----------------------------------------------------------------
                ix = 0
                e%inho_strain = e%inho_strain + dble( conjg(acouK(alpha,ix,iy,iz)) * &
                     &    c%inhomo_K(ix,iy,iz,alpha,beta) * acouK(beta, ix,iy,iz)) / 2
                !-----------------------------------------------------------------
                do ix = 1, p%Lx/2-1
                   e%inho_strain = e%inho_strain+dble(conjg(acouK(alpha,ix,iy,iz)) * &
                        & c%inhomo_K(ix,iy,iz,alpha,beta) * acouK(beta, ix,iy,iz))
                end do
                !-----------------------------------------------------------------
                ix=p%Lx/2
                e%inho_strain = e%inho_strain + dble( conjg(acouK(alpha,ix,iy,iz)) * &
                     &    c%inhomo_K(ix,iy,iz,alpha,beta) * acouK(beta, ix,iy,iz)) / 2
                !-----------------------------------------------------------------
             end do
          end do
       end do
    end do

    e%inho_strain = e%inho_strain / p%N    ! Do NOT divide it by 2 here.
                                           ! It has been already devided.
  end subroutine inhomogeneous_strain_energy

  subroutine inhomogeneous_coupling_energy(p,c,e,acouK)
    use Param_module
    use Coord_module
    implicit none
    !--- arguments -------------------------------------
    type(Param_type),  intent(in)    :: p
    type(Coord_type),  intent(in)    :: c
    type(Energy_type), intent(inout) :: e
    complex*16  acouK(3, 0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1)
    !--- local -----------------------------------------
    integer i, alpha, ix,iy,iz
    !--- END of variable definitions -------------------

    e%inho_coupling = 0.0d0
    do i = 1,6
       do alpha = 1,3
          do iz = 0, p%Lz-1
             do iy = 0, p%Ly-1
                !-----------------------------------------------------------------
                ix = 0
                e%inho_coupling = e%inho_coupling + dble( conjg(acouK(alpha,ix,iy,iz)) * &
                     &    c%inhomo_coup2_K(ix,iy,iz,alpha,i) * c%didiK(ix,iy,iz,i) ) / 2
                !-----------------------------------------------------------------
                do ix = 1, p%Lx/2-1
                   e%inho_coupling = e%inho_coupling+dble(conjg(acouK(alpha,ix,iy,iz)) * &
                        & c%inhomo_coup2_K(ix,iy,iz,alpha,i) * c%didiK(ix,iy,iz,i) )
                end do
                !-----------------------------------------------------------------
                ix=p%Lx/2
                e%inho_coupling = e%inho_coupling + dble( conjg(acouK(alpha,ix,iy,iz)) * &
                     &    c%inhomo_coup2_K(ix,iy,iz,alpha,i) * c%didiK(ix,iy,iz,i) ) / 2
                !-----------------------------------------------------------------
             end do
          end do
       end do
    end do
    e%inho_coupling = e%inho_coupling * 2 / p%N
  end subroutine inhomogeneous_coupling_energy

  subroutine dipole_E_field_energy(p,c,e)
    use Param_module
    use Coord_module
    implicit none
    !--- arguments -------------------------------------
    type(Param_type),  intent(in)    :: p
    type(Coord_type),  intent(in)    :: c
    type(Energy_type), intent(inout) :: e
    !--- local -----------------------------------------
    integer ix,iy,iz
    !--- END of variable definitions -------------------

    e%dipole_E_field = 0.0d0
    do iz = 0, p%Lz-1
       do iy = 0, p%Ly-1
          do ix = 0, p%Lx-1
             e%dipole_E_field = e%dipole_E_field + sum(c%dipoR(ix,iy,iz,:)*c%E_field(ix,iy,iz,:))
          end do
       end do
    end do
    e%dipole_E_field = - p%Z_star * e%dipole_E_field

  end subroutine dipole_E_field_energy
end module Energy_module
