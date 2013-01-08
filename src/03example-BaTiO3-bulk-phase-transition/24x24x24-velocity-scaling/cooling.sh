#!/bin/sh
# cooling.sh
# Time-stamp: <2013-01-08 20:32:23 t-nissie>
# Author: Takeshi NISHIMATSU
##
rm -f cooling.avg

n_thermalize=20000
n_average=200000
n_coord_freq=`expr $n_thermalize + $n_average`

i=0
for temperature in `jot - 350 170 -5` ; do
    i=`expr $i + 1`
    filename=cooling`printf '%.3d' $i`-"$temperature"K
    cat > $filename.feram <<-EOF
	#verbose = 2
	#--- Method, Temperature, and mass ---------------
	method = 'vs'
	GPa = -5.0
	kelvin = $temperature
	mass_amu = 39.0
	Q_Nose = 0.1
	
	#--- System geometry -----------------------------
	bulk_or_film = 'bulk'
	L = 24 24 24
	a0 =  3.94         latice constant a0 [Angstrom]
	#--- Time step -----------------------------------
	dt = 0.002 [pico second]
	n_thermalize = $n_thermalize
	n_average    = $n_average
	n_coord_freq = $n_coord_freq
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
	seed = 1242914819 1957271599
	init_dipo_avg = 0.0   0.0   0.0    [Angstrom]  # Average   of initial dipole displacements
	init_dipo_dev = 0.03  0.03  0.03   [Angstrom]  # Deviation of initial dipole displacements
	Z_star        = 9.956
	epsilon_inf   = 5.24
EOF
    if [ -r "$prev_coord" ]; then
        ln -sf "$prev_coord" $filename.restart
    fi
    ../../feram $filename.feram
    # rm -f $prev_coord $filename.restart
    prev_coord=$filename.`printf '%.10d' $n_coord_freq`.coord
    cat $filename.avg >> cooling.avg
done
