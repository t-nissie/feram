#!/bin/sh
# generator.sh for thermal conductivity in BaTiO3
# Time-stamp: <2015-05-20 18:52:00 t-nissie>
# Author: Takeshi NISHIMATSU
##
n_thermalize_1vs=30000
n_average_1vs=20000
n_thermalize_2lf=100000
n_average_2lf=400000
for temperature in `seq 200 5 600`; do
    GPa=`perl -e "print -0.005 * $temperature"`
    cat > $temperature.1vs.feram <<-EOF
	#verbose = 2
	#--- Method, Temperature, and mass ---------------
	method = 'vs'
	GPa = $GPa
	kelvin = $temperature
	mass_amu = 38.24
	acoustic_mass_amu = 46.44
	
	#--- System geometry -----------------------------
	bulk_or_film = 'bulk'
	L = 48 48 480
	
	#--- Elastic Constants ---------------------------
	B11 = 126.731671475652
	B12 =  41.7582963902598
	B44 =  49.2408864348646
	
	#--- From perovskite-optcell2-p.gp ---------------
	B1xx = -185.347187551195 [eV/Angstrom^2]
	B1yy = -3.28092949275457 [eV/Angstrom^2]
	B4yz = -14.5501738943852 [eV/Angstrom^2]
	P_k1 = -267.98013991724 [eV/Angstrom^6]
	P_k2 = 197.500718362573 [eV/Angstrom^6]
	P_k3 = 830.199979293529 [eV/Angstrom^6]
	P_k4 = 641.968099408642 [eV/Angstrom^8]
	P_alpha = 78.9866142426818 [eV/Angstrom^4]
	P_gamma = -115.484148812672 [eV/Angstrom^4]
	#kappa = -1.51821042113588 [eV/Angstrom^2]
	#(- 8.1460516421 (- (/  -3.812330 2) -1.51821042113588)) =>  8.53400622096412 new P_kappa2

	#--- Time step -----------------------------------
	dt = 0.002 [pico second]
	n_thermalize =    $n_thermalize_1vs
	n_average    =    $n_average_1vs
	n_coord_freq =    9999999
	n_hl_freq    =       50
	distribution_directory = 'never'
	coord_directory = 'never'
	
	#--- From eigenvalues2j --------------------------
	# original  P_kappa2 =    8.1460516421 [eV/Angstrom^2] =    0.0838298622 [Hartree/Bohr^2]
	P_kappa2 = 8.53400622096412
	j =  -2.08403 -1.12904  0.68946 -0.61134  0.00000  0.27690  0.00000    [eV/Angstrom^2]
	a0	  =   3.98597    [Angstrom]
	Z_star      =  10.33000
	epsilon_inf =   6.86915
	
	#--- Initial dipole configrations ----------------
	init_dipo_avg = 0.00  0.14  0.00   [Angstrom]  # Average   of initial dipole displacements
	init_dipo_dev = 0.06  0.06  0.06   [Angstrom]  # Deviation of initial dipole displacements
EOF
    sed -e "s/'vs'/'lf'/" \
        -e "s/$n_thermalize_1vs/$n_thermalize_2lf/" \
        -e "s/$n_average_1vs/$n_average_2lf/" \
                 $temperature.1vs.feram > $temperature.2lf.feram
    echo 'continue = .true.'           >> $temperature.2lf.feram
    echo 'delta_e      = 0.00002 [eV/u.c.]' >> $temperature.2lf.feram
    echo 'delta_e_acou = 0.00002 [eV/u.c.]' >> $temperature.2lf.feram

    cat > $temperature.csh <<-EOF
	#!/bin/csh
	# For IBM XL Fortran
	setenv MALLOCMULTIHEAP true
	if (! \${?XLSMPOPTS}) then
	    setenv XLSMPOPTS "spins=0:yields=0"
	endif
	./feram $temperature.1vs.feram $temperature.2lf.feram
EOF
    chmod 755 $temperature.csh
done
