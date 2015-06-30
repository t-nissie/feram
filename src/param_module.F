! param_module.F -*-f90-*-
! Time-stamp: <2015-06-30 12:36:10 takeshi>
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
     logical continue
     character(len=30) :: method ! 'md' Nose-Poincare, 'vs' velocity-scaling, 'lf' leapfrog, 'hl' hysteresis loop
     real*8 GPa(3)       ! [GPa]
     real*8 kelvin       ! [K]
     real*8 target_kinetic_energy
     real*8 mass_dipo    ! [eV Angstrom^-2 ps^2]
     real*8 mass_acou    ! [eV Angstrom^-2 ps^2]
     real*8 mass_acou_inv
     real*8 Q_Nose       ! [eV ps^2]
     !--- System geometry -----------------------------
     character(len=4) :: bulk_or_film
     integer Lx, Ly, Lz ! Integer
     integer gap_id     ! 0, 1, 2
     integer padding_y
     real*8  gap_dipole_u(3)
     real*8 a0          ! lattice constant [Angstrom]
     real*8 epi_strain
     !--- Time step -----------------------------------
     real*8 dt          ! Time step width delta t [pico second]
     integer n_thermalize
     integer n_average
     integer n_E_wave_period
     integer n_coord_freq  ! frequency for writing out the coordinates
     integer n_hl_freq     ! frequency for writing to .hl file
     integer n_hysteresis_loop_continue
     character (len=FILE_NAME_LEN) coord_directory
     character (len=FILE_NAME_LEN) distribution_directory
     !!--- External electric field ---------------------
     real*8    external_E_field(3)  ! External electric field [V/Angstrom]
     character(len=30) :: E_wave_type    ! 'triangular_sin', 'triangular_cos'  !Not yet: 'sin', 'cos'
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
     integer seed(2)
     real*8  init_dipo_avg(3) ! Average   of initial dipole displacements
     real*8  init_dipo_dev(3) ! Deviation of initial dipole displacements
     real*8  k_stripe(3)      ! wave number of striped domain structure in 2*pi/a_0 unit
     real*8 Z_star        ! Born effective charge
     real*8 epsilon_inf   ! relative dielectric constant of core ions
     real*8 kappa         ! arbitrary kappa for dipole-dipole-long-range.F
     logical plot_dispersion
     !--- Thermal conductivity ------------------------
     real*8 delta_e      ! [eV/unitcell]
     real*8 delta_e_acou ! [eV/unitcell]
     !--- Verboseness of .log file --------------------
     integer verbose
     !--- DDB2short -----------------------------------
     real*8 DDB_a
     real*8 DDB_b
     real*8 DDB_c
     real*8 DDB_d
     real*8 DDB_e
     real*8 DDB_f
     real*8 DDB_g
     !=== Parameters to be calculated from above =========================
     integer N
     real*8 Ninv
     real*8 dt_2
     integer n_freedom
     real*8 unit_cell_volume
     real*8 pNa03(3) ![eV]
     real*8 temperature_eV
     logical E_field_always_zero 
     !=== etc ============================================================
     character(len=FILE_NAME_LEN) :: filename
  end type Param_type

contains
  subroutine read_Param(p,fn)
    implicit none
    type(Param_type),intent(inout) :: p
    character(len=*),intent(in)    :: fn
    character (len=300) str
    character (len=40)  name, dmy1, dmy2
    integer io, iosGPa, line_number, i
    real*8 mass_amu
    real*8 acoustic_mass_amu

    call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'read_Param().')
    open(UNIT_INPUT, FILE=fn, STATUS='OLD')
    call msg(UNIT_LOG, __FILE__, __LINE__, 'INPUT_FILENAME', trim(fn))

    ! Default parameters
    p%method = 'md'
    p%GPa(1:3) = 0.0d0
    p%kelvin = 0.0d0
    p%target_kinetic_energy = 0.0d0
    p%mass_dipo = 100.0d0 / 9648.53377163899d0
    p%mass_acou = -100.0d0
    p%mass_acou_inv = 1.0d0
    p%Q_Nose = 0.1d0
    p%bulk_or_film = 'bulk'
    p%Lx = 32
    p%Ly = 32
    p%Lz = 32
    p%gap_id = 0
    p%padding_y = 1
    p%gap_dipole_u(:) = 0.0d0
    p%a0 = 4.0d0
    p%epi_strain = 0.0d0

    p%n_thermalize =  10000
    p%n_average    = 100000
    p%n_E_wave_period = 0
    p%n_coord_freq = huge(1)   ! Maximum integer. Do not write system by default.
    p%n_hl_freq    =  10000
    p%n_hysteresis_loop_continue = 1
    p%coord_directory = ''
    p%distribution_directory = ''

    p%external_E_field(:) = 0.0d0
    p%E_wave_type = ''
    p%P_kappa2 = 0.0d0
    p%P_alpha  = 0.0d0
    p%P_gamma  = 0.0d0
    p%j(:)     = 0.0d0
    p%P_k1     = 0.0d0
    p%P_k2     = 0.0d0
    p%P_k3     = 0.0d0
    p%P_k4     = 0.0d0
    p%seed(1) = 123456789
    p%seed(2) = 987654321
    p%init_dipo_avg(:) = 0.00d0
    p%init_dipo_dev(:) = 0.05d0
    p%kappa = 0.0d0
    p%continue = .false.
    p%plot_dispersion = .false.
    p%delta_e      = 0.0d0
    p%delta_e_acou = 0.0d0
    p%verbose = 1
    p%DDB_a = 0.0d0
    p%DDB_b = 0.0d0
    p%DDB_c = 0.0d0
    p%DDB_d = 0.0d0
    p%DDB_e = 0.0d0
    p%DDB_f = 0.0d0
    p%DDB_g = 0.0d0
    p%k_stripe = 0.0d0
    p%temperature_eV = 0.0d0
    p%E_field_always_zero = .true.

    ! Read parameters from the imput file
    line_number = 0
    do
       read(UNIT_INPUT, '(a)', IOSTAT=io) str
       if (io.ne.0) exit
       line_number = line_number + 1
       read(str,*,IOSTAT=io) name   ! extract name of a parameter
       if (io.ne.0 .or. name(1:1).eq.'#') then
          call msg_ez(UNIT_LOG,str)
          cycle
       end if

       select case(name)
       case('method')
          read(str,*) dmy1, dmy2, p%method
          if (p%method.eq.'hl') p%E_field_always_zero = .false.
       case('E_wave_type')
          read(str,*) dmy1, dmy2, p%E_wave_type
          p%E_field_always_zero = .false.
       case('GPa')
          read(str,*,IOSTAT=iosGPa) dmy1, dmy2, p%GPa(1), p%GPa(2), p%GPa(3)
          if (iosGPa.ne.0) then
             write(0,'(a,a,i3,a,a)') trim(fn), ':', line_number,': ', trim(str)
             write(0,'(a,a,i3,a)')   __FILE__, ':', __LINE__ ,  ': Hydrostatic pressure is applied.'
             read(str,*) dmy1, dmy2, p%GPa(1)
             p%GPa(2) = p%GPa(1)
             p%GPa(3) = p%GPa(1)
          end if
       case('kelvin')
          read(str,*) dmy1, dmy2, p%kelvin
          p%temperature_eV = p%kelvin / KELVIN_EV
       case('mass_amu')
          read(str,*) dmy1, dmy2, mass_amu  ! [amu]
          p%mass_dipo =          mass_amu / 9648.53377163899d0
       case('acoustic_mass_amu')
          if (p%method.eq.'md') then
             write(0,'(a,a,i3,a,a)') trim(fn),':', line_number, ':', trim(str)
             stop ": You cannot use method = 'md' togeter with acoustic_mass_amu."
          end if
          read(str,*) dmy1, dmy2, acoustic_mass_amu  ! [amu]
          p%mass_acou = acoustic_mass_amu / 9648.53377163899d0
          p%mass_acou_inv = 1.0d0 / p%mass_acou
       case('Q_Nose')
          read(str,*) dmy1, dmy2, p%Q_Nose
       case('bulk_or_film')
          read(str,*) dmy1, dmy2, p%bulk_or_film
          if (p%bulk_or_film.ne.'bulk' .and. p%bulk_or_film.ne.'film' .and. p%bulk_or_film.ne.'epit')  then
             write(0,'(a,a,i3,a,a)') trim(fn),':', line_number, ':', trim(str)
             stop ': Input error: bulk_or_film must be bulk, film or epit.'
          end if
       case('L')
          read(str,*) dmy1, dmy2, p%Lx, p%Ly, p%Lz
       case('padding_y')
          read(str,*) dmy1, dmy2, p%padding_y
       case('gap_id')
          read(str,*) dmy1, dmy2, p%gap_id
       case('gap_dipole_u')
          read(str,*) dmy1, dmy2, p%gap_dipole_u
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
       case('n_E_wave_period')
          read(str,*) dmy1, dmy2, p%n_E_wave_period
          if (mod(p%n_E_wave_period,4).ne.0) then
             write(0,'(a,a,i3,a,a)') trim(fn),':', line_number, ':', trim(str)
             stop ': Input error: n_E_wave_period must be divided by 4.'
          end if
       case('n_coord_freq')
          read(str,*) dmy1, dmy2, p%n_coord_freq
       case('n_hl_freq')
          read(str,*) dmy1, dmy2, p%n_hl_freq
       case('external_E_field')
          read(str,*) dmy1, dmy2, p%external_E_field(1), p%external_E_field(2), p%external_E_field(3)
          if ( p%external_E_field(1).ne.0.0d0 .or. &
               p%external_E_field(2).ne.0.0d0 .or. &
               p%external_E_field(3).ne.0.0d0 ) then
             p%E_field_always_zero = .false.   ! See initialize_E_field.F also.
          end if
       case('n_hysteresis_loop_continue')
          read(str,*) dmy1, dmy2, p%n_hysteresis_loop_continue
       case('coord_directory')
          read(str,*) dmy1, dmy2, p%coord_directory
       case('distribution_directory')
          read(str,*) dmy1, dmy2, p%distribution_directory
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
       case('seed')
          read(str,*) dmy1, dmy2, p%seed(1), p%seed(2)
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
       case('continue')
          read(str,*) dmy1, dmy2, p%continue
       case('plot_dispersion')
          read(str,*) dmy1, dmy2, p%plot_dispersion
       case('delta_e')
          read(str,*) dmy1, dmy2, p%delta_e
       case('delta_e_acou')
          read(str,*) dmy1, dmy2, p%delta_e_acou
       case('verbose')
          read(str,*) dmy1, dmy2, p%verbose
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
          write(0,'(a,a,i3,a,a)') trim(fn),':', line_number, ':', trim(str)
          stop ': Input error: No such parameter'
       end select
       call msg_ez(UNIT_LOG,str)
    end do
    close(UNIT_INPUT)

    call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '  read_Param().')
  end subroutine read_Param

  subroutine make_Param(p)
    implicit none
    type(Param_type),intent(inout) :: p
    call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'make_Param().')

    p%N = p%Lx * p%Ly * p%Lz
    p%Ninv = 1.0d0 / p%N
    p%dt_2 = p%dt / 2
    p%n_freedom = 3 * p%N
    if (p%kappa<=0.0d0) then
       p%kappa = sqrt(M_PI) / p%a0 / (dble(p%N))**(1.0d0/6)
    end if
    p%unit_cell_volume = p%a0 ** 3
    p%pNa03(1:3) = p%GPa(1:3) * 0.01d0 / ELEMENTARY_CHARGE * p%N * p%unit_cell_volume   ! [eV/supercell]

    p%target_kinetic_energy = p%kelvin * 1.5d0 * p%N / KELVIN_EV

    if (p%bulk_or_film.eq.'bulk') then
       if (p%gap_id.ne.0) then
          stop ': In the case of bulk calculation, gap_id must be 0.'
       end if
    else
       if (mod(p%Lz,2).ne.mod(p%gap_id,2)) then
          stop ': In the case of film or epit calculation, it must be mod(Lz,2)==mod(gap_id,2).'
       end if
    end if
    call msg(UNIT_LOG, __FILE__, __LINE__, 'END',   '  make_Param().')
  end subroutine make_Param

  subroutine write_Param(p)
    implicit none
    type(Param_type),intent(in) :: p
    character (len=100) :: fn
    character (len=300) :: str
    call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'write_Param(), Parameters for convenience.')
    write(str,'(a,i11)')    'N = Lx * Ly * Lz          =', p%N
    call msg_ez(UNIT_LOG,str)
    write(str,'(a,i11)')    'padding_y                 =', p%padding_y
    call msg_ez(UNIT_LOG,str)
    write(str,'(a,e15.7)')  'Ninv = 1/N                =', p%Ninv
    call msg_ez(UNIT_LOG,str)
    write(str,'(a,f11.7)')  'delta_t / 2               =', p%dt_2
    call msg_ez(UNIT_LOG,str)
    write(str,'(a,i11)')    'N of degree of freedom    =', p%n_freedom
    call msg_ez(UNIT_LOG,str)
    write(str,'(a,f11.7)')  'unit_cell_volume          =', p%unit_cell_volume
    call msg_ez(UNIT_LOG,str)
    write(str,'(a,f10.4)')  'kappa for Ewald sum = ', p%kappa
    call msg_ez(UNIT_LOG,str)

    !=== BEGIN: write parameters for gnuplot ============================
    fn = trim(p%filename) // '.param.gp'
    call msg(UNIT_LOG, __FILE__, __LINE__, 'FILE', fn)
    open(unit=UNIT_SYSTEM,file=fn)
    write(UNIT_SYSTEM,'(a,i5)')    'Lx          =', p%Lx,         &
                                   'Ly          =', p%Ly,         &
                                   'Lz          =', p%Lz
    write(UNIT_SYSTEM,'(a,f13.6)') 'mass_dipo   =', p%mass_dipo,  &
&                                  'mass_acou   =', p%mass_acou,  &
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
    !=== END: write parameters for gnuplot ==============================

    call msg(UNIT_LOG, __FILE__, __LINE__, 'END',   '  write_Param().')
  end subroutine write_Param
end module Param_module
