#!/bin/sh
# Usage: for period in `seq 900000 -100000 300000` `seq 200000 -1000 1000`; do f=`printf "%.6d\n" $period`; submit SC general -exec $f.csh -J $f; done
##
for period in `seq 900000 -100000 300000` `seq 200000 -1000 1000`; do
  f=`printf "%.6d\n" $period`
  cat > $f.feram <<-EOF
	#verbose = 2
	#--- Method, Temperature, and mass ---------------
	method = 'lf'
	GPa = -2.3
	kelvin = 460.0
	mass_amu = 38.24
	acoustic_mass_amu = 46.44
	
	#--- System geometry -----------------------------
	bulk_or_film = 'bulk'
	L = 128 128 128
	
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
	n_thermalize    = `expr 20000 + $period`
	n_E_wave_period =  $period
	n_average       = 20000
	external_E_field = 0.00 0.00 0.000500000
	coord_directory = 'never'
	slice_directory = 'never'
	distribution_directory = 'never'
	E_wave_type = 'ramping_off'
	
	#--- From eigenvalues2j --------------------------
	# original  P_kappa2 =    8.1460516421 [eV/Angstrom^2] =    0.0838298622 [Hartree/Bohr^2]
	P_kappa2 = 8.53400622096412
	j =  -2.08403 -1.12904  0.68946 -0.61134  0.00000  0.27690  0.00000    [eV/Angstrom^2]
	a0	  =   3.98597    [Angstrom]
	Z_star      =  10.33000
	epsilon_inf =   6.86915
	
	#--- Initial dipole configrations ----------------
	init_dipo_avg = 0.00  0.00  0.14   [Angstrom]  # Average   of initial dipole displacements
	init_dipo_dev = 0.06  0.06  0.04   [Angstrom]  # Deviation of initial dipole displacements
	EOF
  cat > $f.csh <<-EOF
	#!/bin/csh
	# Usage: submit SC general -exec $f.csh -J $f
	##
	# For IBM XL Fortran
	setenv MALLOCMULTIHEAP true
	setenv XLSMPOPTS "spins=0:yields=0"
	ln -sf vs.0000040000.coord $f.restart
	../feram                $f.feram
	EOF
  chmod 755 $f.csh
done
