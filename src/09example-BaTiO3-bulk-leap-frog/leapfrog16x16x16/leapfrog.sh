#!/bin/sh
# leapfrog.sh
# Time-stamp: <2016-10-20 12:21:29 takeshi>
# Author: Takeshi NISHIMATSU
##
n_thermalize=40000
n_average=10000
n_coord_freq=`expr $n_thermalize + $n_average`

for i in `seq 40`; do
    dev=`printf '%.3d' $i`
    filename=leapfrog"$dev"
    cat > $filename.feram <<-EOF
	#--- Method, Temperature, and mass ---------------
	method = 'lf'
	GPa = -5.0
	mass_amu = 39.0
	# acoustic_mass_amu = 46.44
	
	#--- System geometry -----------------------------
	bulk_or_film = 'bulk'
	L = 16 16 16
	a0 =  3.94         latice constant a0 [Angstrom]
	#--- Time step -----------------------------------
	dt = 0.002 [pico second]
	n_thermalize = $n_thermalize
	n_average    = $n_average
	n_coord_freq = $n_coord_freq
	coord_directory = 'never'
	slice_directory = 'never'
	distribution_directory = 'never'
	
	#--- On-site (Polynomial of order 4) -------------
	P_kappa2 =    5.502  [eV/Angstrom^2] # P_4(u) = kappa2*u^2 + alpha*u^4
	P_alpha  =  110.4    [eV/Angstrom^4] #  + gamma*(u_y*u_z+u_z*u_x+u_x*u_y),
	P_gamma  = -163.1    [eV/Angstrom^4] # where u^2 = u_x^2 + u_y^2 + u_z^2
	
	#--- Inter-site ----------------------------------
	j = -2.648 3.894 0.898 -0.789 0.562 0.358 0.179    j(i) [eV/Angstrom^2]
	
	#--- Elastic Constants ---------------------------
	B11 = 126.
	B12 =  44.9
	B44 =  50.3  [eV]
	
	#--- Elastic Coupling ----------------------------
	B1xx = -211.   [eV/Angstrom^2]
	B1yy =  -19.3  [eV/Angstrom^2]
	B4yz =   -7.75 [eV/Angstrom^2]
	
	#--- Dipole --------------------------------------
	init_dipo_avg = 0.143 0.143 0.143   [Angstrom]  # Average   of initial dipole displacements
	init_dipo_dev = 0.$dev 0.$dev 0.$dev  [Angstrom]  # Deviation of initial dipole displacements
	Z_star        = 9.956
	epsilon_inf   = 5.24
EOF
    ../../feram $filename.feram
    cat $filename.avg >> leapfrog.avg
done
