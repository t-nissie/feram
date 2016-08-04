#!/bin/sh
# heating.sh
# Time-stamp: <2016-08-04 16:15:50 takeshi>
# Author: Takeshi NISHIMATSU
##
rm -f heating.avg

n_thermalize=20000
n_average=20000
n_coord_freq=`expr $n_thermalize + $n_average`

i=0
for temperature in `seq  30  1 500`; do
    GPa=`perl -e "print -0.000 * $temperature"`
    i=`expr $i + 1`
    filename=heating`printf '%.3d' $i`-"$temperature"K
    cat > $filename.feram <<-EOF
	#--- Method, Temperature, and mass ---------------
	method = 'vs'
	GPa = $GPa
	kelvin = $temperature
	mass_amu = 40.9285
	acoustic_mass_amu = 41.67
	
	#--- System geometry -----------------------------
	bulk_or_film = 'bulk'
	L = 32 32 32
	
	#--- Elastic Constants ---------------------------
	modulation_constant = -0.279
	B11 = 129.0286059
	B12 =  39.00720516
	B44 =  45.26949109
	
	#--- From perovskite-optcell2-p.gp ---------------
	B1xx = -143.7185938
	B1yy = -1.375464746
	B4yz = -15.02208695
	P_k1 = -166.56247
	P_k2 = 157.2518592
	P_k3 = 515.9414896
	P_k4 = 390.6570497
	P_alpha = 50.68630712
	P_gamma = -72.18357441
	
	#--- Time step -----------------------------------
	dt = 0.002 [pico second]
	n_thermalize = $n_thermalize
	n_average    = $n_average
	n_coord_freq = $n_coord_freq
	distribution_directory = 'never'
	
	#--- From eigenvalues2j --------------------------
	P_kappa2 = 9.4250031
	
	j = -2.048250285  -1.472144446  0.6396521198  -0.5891190367  0.0 0.2576732039  0.0
	a0  =   3.9435    [Angstrom]
	Z_star      =  9.807238756
	epsilon_inf =  6.663371926
	
	#--- Initial dipole configrations ----------------
	init_dipo_avg = 0.11  0.11  0.11   [Angstrom]  # Average   of initial dipole displacements
	init_dipo_dev = 0.02  0.02  0.02   [Angstrom]  # Deviation of initial dipole displacements
EOF
    if [ -r "$prev_coord" ]; then
        ln -sf "$prev_coord" $filename.restart
    fi
    ln -sf modulation $filename.modulation
    ../../feram $filename.feram
    rm -f $prev_coord $filename.restart $filename.dipoRavg
    prev_coord=$filename.`printf '%.10d' $n_coord_freq`.coord
    cat $filename.avg >> heating.avg
done
