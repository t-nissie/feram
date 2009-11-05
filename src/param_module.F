! param_module.F -*-f90-*-
! Time-stamp: <2009-11-05 16:53:49 takeshi>
! Author: Takeshi NISHIMATSU
!!
# include "define.h"
module Param_module
  implicit none
  type Param_type
     !=== Parameters initially given by user =============================
     !--- Unit in use ---------------------------------
     ! Length:     Angstrom
     ! Energy:     eV
     ! Force:      eV Angstrom^-1
     ! Charge:     e
     ! E field:    V Angstrom^-1
     ! A point charge q [e] makes E field at distance r [Angstrom]:
     !             E = 14.399645*q/r^2 [V Angstrom^-1]
     ! Electrostatic potential of point
     ! charges q, q' [e] in distance r [Angstrom]:
     !             U = 14.399644*q*q'/r [eV]
     !                 14.399644 = Hartree [eV] * r_Bohr [Angstrom]
     !                           = 27.21138344 * 0.5291772083 = Hartree_Bohr
     ! Time:       pico second (ps)
     ! Frequency:  THz
     ! Mass:       eV Angstrom^-2 ps^2
     !             = 1.60217653e-19 [J] * (1.e-10 [m])^-2 * (1.e-12 [s])^2
     !             = 1.60217653e-23 [kg]
     !             = 1.60217653e-20 [g]
     !             = 9648.53377163899 [atomic mass unit (amu)]
     !             (N_Avogadro = 6.0221415e23 [mol^-1 (amu/g)])
     !
     !--- Method, Temperature, and mass ---------------
     character(len=3) :: method ! 'md' for MD in the canonical ensemble using the Nose-Poincare thermostat, 'lf' for MD in the
     real*8 GPa          ! [GPa]            microcanonical ensemble using the leap-frog method, or 'mc' for Monte Carlo method
     real*8 kelvin       ! [K]
     real*8 mass_dipo    ! [eV Angstrom^-2 ps^2]
     real*8 Q_Nose       ! [eV ps^2]
     !--- System geometry -----------------------------
     character(len=4) :: bulk_or_film
     integer Lx, Ly, Lz ! Integer
     integer gap        ! 1, 3, 5, 7, ...
     real*8 a0          ! lattice constant [Angstrom]
     real*8 epi_strain
     !--- Time step -----------------------------------
     real*8 dt          ! Time step width delta t [pico second]
     integer n_thermalize
     integer n_average
     integer n_coord_freq  ! frequency for writing out the coordinates
     !!--- External electric field ---------------------
     real*8    external_E_field(3)  ! External electric field [V/Angstrom]
     !--- On-site (Polynomial of order 6) -------------
     real*8 P_kappa2    ! P_6(u) = kappa2*u^2 + alpha*u^4
     real*8 P_alpha     !  + gamma*(u_y*u_z+u_z*u_x+u_x*u_y),
     real*8 P_gamma     !  + k1*u^6
     real*8 P_k1        !  + k2*[u_x^4(u_y^2+u_z^2)+u_y^4(u_z^2+u_x^2)+u_z^4(u^x2+u_y^2)]
     real*8 P_k2        !  + k3*u_x^2u_y^2u_z^2
     real*8 P_k3        ! where u^2 = u_x^2 + u_y^2 + u_z^2, u^4=(u^2)^2, u^6=(u^2)^3
     real*8 P_k4        ! for u^8
     !--- Inter-site ----------------------------------
     real*8 j(7)
     !--- Elastic Constants ---------------------------
     real*8 B11, B12 ,B44
     !--- Elastic Coupling ----------------------------
     real*8 B1xx, B1yy, B4yz
     !--- Dipole --------------------------------------
     integer random_seed_array(MAX_RANDOM_SEED_SIZE)
     real*8  init_dipo_avg(3) ! Average   of initial dipole displacements
     real*8  init_dipo_dev(3) ! Deviation of initial dipole displacements
     real*8  k_stripe(3)      ! wave number of striped domain structure in 2*pi/a_0 unit
     real*8 Z_star        ! Born effective charge
     real*8 epsilon_inf   ! relative dielectric constant of core ions
     real*8 kappa         ! arbitrary kappa for dipole-dipole-long-range.F
     integer defect_position(3)
     real*8  defect_u(3)
     logical plot_dispersion
     !--- DDB2short -----------------------------------
     real*8 DDB_a
     real*8 DDB_b
     real*8 DDB_c
     real*8 DDB_d
     real*8 DDB_e
     real*8 DDB_f
     real*8 DDB_g
     !=== Parameters to be calculated from above =========================
     integer film_thickness
     integer N
     real*8 dt_2
     integer n_freedom
     real*8 unit_cell_volume
     real*8 pNa03 ![eV]
     real*8 temperature_eV
     !=== etc ============================================================
     character(len=100) :: filename
  end type Param_type

contains
  subroutine read_Param(p,fd)
    implicit none
    type(Param_type),intent(inout) :: p
    integer,         intent(in)    :: fd
    character (len=300) str
    character (len=30)  name, dmy1, dmy2
    integer io, line_number, i
    real*8 mass_amu

    call msg(6, __FILE__, __LINE__, 'BEGIN', ': read_Param().')

    ! Default parameters
    p%kelvin = 0.0d0
    p%temperature_eV = 0.0d0
    p%bulk_or_film = 'bulk'
    p%defect_position(1)  = -1    ; p%defect_position(2)  = -1    ; p%defect_position(3)  = -1
    p%defect_u(1)         = 0.0d0 ; p%defect_u(2)         = 0.0d0 ; p%defect_u(3)         = 0.0d0
    p%external_E_field(:) = 0.0d0
    p%P_kappa2 = 0.0d0
    p%P_alpha  = 0.0d0
    p%P_gamma  = 0.0d0
    p%j(:)     = 0.0d0
    p%P_k1     = 0.0d0
    p%P_k2     = 0.0d0
    p%P_k3     = 0.0d0
    p%P_k4     = 0.0d0
    p%random_seed_array(:) = 0
    p%init_dipo_avg(:) = 0.00d0
    p%init_dipo_dev(:) = 0.05d0
    p%n_coord_freq           = huge(1)   ! maximum integer
    p%kappa = 0.0d0
    p%plot_dispersion = .false.
    p%DDB_a = 0.0d0
    p%DDB_b = 0.0d0
    p%DDB_c = 0.0d0
    p%DDB_d = 0.0d0
    p%DDB_e = 0.0d0
    p%DDB_f = 0.0d0
    p%DDB_g = 0.0d0
    p%k_stripe = 0.0d0
    p%gap = 0

    ! Read parameters from the imput file
    line_number = 0
    do
       read(fd, '(a)', IOSTAT=io) str
       if (io.ne.0) exit
       line_number = line_number + 1
       read(str,*,IOSTAT=io) name   ! extract name of a parameter
       if (io.ne.0 .or. name(1:1).eq.'#') then
          call msg_ez(6,str)
          cycle
       end if

       select case(TRIM(name))
       case('method')
          read(str,*) dmy1, dmy2, p%method
       case('GPa')
          read(str,*) dmy1, dmy2, p%GPa
       case('kelvin')
          read(str,*) dmy1, dmy2, p%kelvin
          p%temperature_eV = p%kelvin / KELVIN_EV
       case('mass_amu')
          read(str,*) dmy1, dmy2, mass_amu  ! [amu]
          p%mass_dipo=mass_amu/9648.53377163899
       case('Q_Nose')
          read(str,*) dmy1, dmy2, p%Q_Nose
       case('bulk_or_film')
          read(str,*) dmy1, dmy2, p%bulk_or_film
          if (p%bulk_or_film.ne.'bulk' .and. p%bulk_or_film.ne.'film' .and. p%bulk_or_film.ne.'epit')  then
             write(6,'(a,a,i3,a,a)') trim(p%filename),':', line_number, ':', trim(str)
             stop ': Input error: bulk_or_film must be bulk, film or epit.'
          end if
       case('L')
          read(str,*) dmy1, dmy2, p%Lx, p%Ly, p%Lz
       case('gap')
          read(str,*) dmy1, dmy2, p%gap
       case('a0')
          read(str,*) dmy1, dmy2, p%a0
       case('epi_strain')
          read(str,*) dmy1, dmy2, p%epi_strain
       case('dt')
          read(str,*) dmy1, dmy2, p%dt
       case('n_thermalize')
          read(str,*) dmy1, dmy2, p%n_thermalize
       case('n_average'   )
          read(str,*) dmy1, dmy2, p%n_average
       case('n_coord_freq')
          read(str,*) dmy1, dmy2, p%n_coord_freq
       case('external_E_field')
          read(str,*) dmy1, dmy2, p%external_E_field(1), p%external_E_field(2), p%external_E_field(3)
       case('P_kappa2')
          read(str,*) dmy1, dmy2, p%P_kappa2
       case('P_alpha')
          read(str,*) dmy1, dmy2, p%P_alpha
       case('P_gamma')
          read(str,*) dmy1, dmy2, p%P_gamma
       case('P_k1')
          read(str,*) dmy1, dmy2, p%P_k1
       case('P_k2')
          read(str,*) dmy1, dmy2, p%P_k2
       case('P_k3')
          read(str,*) dmy1, dmy2, p%P_k3
       case('P_k4')
          read(str,*) dmy1, dmy2, p%P_k4
       case('j')
          read(str,*) dmy1, dmy2, p%j(1),p%j(2),p%j(3),p%j(4),p%j(5),p%j(6),p%j(7)
       case('B11')
          read(str,*) dmy1, dmy2, p%B11
       case('B12')
          read(str,*) dmy1, dmy2, p%B12
       case('B44')
          read(str,*) dmy1, dmy2, p%B44
       case('B1xx')
          read(str,*) dmy1, dmy2, p%B1xx
       case('B1yy')
          read(str,*) dmy1, dmy2, p%B1yy
       case('B4yz')
          read(str,*) dmy1, dmy2, p%B4yz
       case('random_seed_array')
          read(str,*) dmy1, dmy2, (p%random_seed_array(i),i=1,8)
       case('init_dipo_avg')
          read(str,*) dmy1, dmy2, (p%init_dipo_avg(i),i=1,3)
       case('init_dipo_dev')
          read(str,*) dmy1, dmy2, (p%init_dipo_dev(i),i=1,3)
       case('k_stripe')
          read(str,*) dmy1, dmy2, (p%k_stripe(i),i=1,3)
       case('Z_star')
          read(str,*) dmy1, dmy2, p%Z_star
       case('epsilon_inf')
          read(str,*) dmy1, dmy2, p%epsilon_inf
       case('kappa')
          read(str,*) dmy1, dmy2, p%kappa
       case('defect_position')
          read(str,*) dmy1, dmy2, p%defect_position(1), p%defect_position(2), p%defect_position(3)
       case('defect_u')
          read(str,*) dmy1, dmy2, p%defect_u(1), p%defect_u(2), p%defect_u(3)
       case('plot_dispersion')
          read(str,*) dmy1, dmy2, p%plot_dispersion
       case('DDB_a')
          read(str,*) dmy1, dmy2, p%DDB_a
       case('DDB_b')
          read(str,*) dmy1, dmy2, p%DDB_b
       case('DDB_c')
          read(str,*) dmy1, dmy2, p%DDB_c
       case('DDB_d')
          read(str,*) dmy1, dmy2, p%DDB_d
       case('DDB_e')
          read(str,*) dmy1, dmy2, p%DDB_e
       case('DDB_f')
          read(str,*) dmy1, dmy2, p%DDB_f
       case('DDB_g')
          read(str,*) dmy1, dmy2, p%DDB_g
       case default
          write(6,'(a,a,i3,a,a)') trim(p%filename),':', line_number, ':', trim(str)
          stop ': Input error: No such parameter'
       end select
       call msg_ez(6,str)
    end do

    close(fd)

    call msg(6, __FILE__, __LINE__, 'END', ':   read_Param().')
  end subroutine read_Param

  subroutine make_Param(p)
    implicit none
    type(Param_type),intent(inout) :: p
    call msg(6, __FILE__, __LINE__, 'BEGIN', ': make_Param().')

    p%film_thickness = p%Lz/2-p%gap
    p%N = p%Lx * p%Ly * p%Lz
    p%dt_2 = p%dt / 2
    p%n_freedom = 3 * p%N
    !  if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') then
    !   p%n_freedom = 3 * p%Lx * p%Ly * p%film_thickness * 2
    !else
    !   p%n_freedom = 3 * p%N
    !end if
    p%unit_cell_volume = p%a0 ** 3
    p%pNa03 = p%GPa *0.01d0 / ELEMENTARY_CHARGE * p%N * p%unit_cell_volume
    call msg(6, __FILE__, __LINE__, 'END',   ':   make_Param().')
  end subroutine make_Param

  subroutine write_Param(p)
    implicit none
    type(Param_type),intent(in) :: p
    character (len=100) :: fn
    character (len=300) :: str
    call msg(6, __FILE__, __LINE__, 'BEGIN', ': write_Param(), Parameters for convenience.')
    write(str,'(a,i7)')     'film_thickness            =', p%film_thickness
    call msg_ez(6,str)
    write(str,'(a,i7)')     'N = Lx * Ly * Lz          =', p%N
    call msg_ez(6,str)
    write(str,'(a,f11.7)')  'delta_t / 2               =', p%dt_2
    call msg_ez(6,str)
    write(str,'(a,i7)')     'N of degree of freedom    =', p%n_freedom
    call msg_ez(6,str)
    write(str,'(a,f11.7)')  'unit_cell_volume          =', p%unit_cell_volume
    call msg_ez(6,str)

    !=== BEGIN: write parameters for gnuplot ============================
    write(fn,'(a,a)') trim(p%filename),'.param'
    open(unit=UNIT_SYSTEM,file=fn)
    write(UNIT_SYSTEM,'(a,i5)')    'Lx          =', p%Lx,         &
                                   'Ly          =', p%Ly,         &
                                   'Lz          =', p%Lz
    write(UNIT_SYSTEM,'(a,f13.6)') 'mass_dipo   =', p%mass_dipo,  &
&                                  'a0          =', p%a0,         &
&                                  'kappa_short =',               &
&    p%P_kappa2+2*p%j(1)+p%j(2)+4*p%j(3)+2*p%j(4)+4*p%j(6),       &
&                                  'P_alpha     =', p%P_alpha,    &
&                                  'P_gamma     =', p%P_gamma,    &
&                                  'B11         =', p%B11,        &
&                                  'B12         =', p%B12,        &
&                                  'B44         =', p%B44,        &
&                                  'B1xx        =', p%B1xx,       &
&                                  'B1yy        =', p%B1yy,       &
&                                  'B4yz        =', p%B4yz,       &
&                                  'Z_star      =', p%Z_star,     &
&                                  'epsilon_inf =', p%epsilon_inf

    close(UNIT_SYSTEM)
    call msg(6, __FILE__, __LINE__, 'FILE: ', fn)
    !=== END: write parameters for gnuplot ==============================

    call msg(6, __FILE__, __LINE__, 'END',   ':   write_Param().')
  end subroutine write_Param
end module Param_module
