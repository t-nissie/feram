#!/bin/sh
# cooling.sh
# Time-stamp: <2011-08-20 22:51:42 takeshi>
# Author: Takeshi NISHIMATSU
##
rm -f cooling.avg

temperature_start=400
temperature_goal=170
temperature_step=-5

n_thermalize=10000
n_average=5000
n_coord_freq=`expr $n_thermalize + $n_average`

i=0
temperature=$temperature_start
while [ `perl -e "print $temperature >= $temperature_goal || 0"` = "1" ] ; do
    i=`expr $i + 1`
    filename=cooling`printf '%.3d' $i`-"$temperature"K
    cat > $filename <<-EOF
	#--- Method, Temperature, and mass ---------------
	method = 'md'
	GPa = 0.0
	kelvin = $temperature
	mass_amu = 39.0
	Q_Nose = 0.1
	
	#--- System geometry -----------------------------
	bulk_or_film = 'bulk'
	L = 16 16 16
	a0 =  3.94         latice constant a0 [Angstrom]
	#--- Time step -----------------------------------
	dt = 0.002 [pico second]
	n_thermalize = $n_thermalize
	n_average    = $n_average
	n_coord_freq = $n_coord_freq
	
	#--- On-site (Polynomial of order 4) -------------
	P_kappa2 =    4.0    [eV/Angstrom^2] # P_4(u) = kappa2*u^2 + alpha*u^4
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
	init_dipo_avg = 0.0   0.0   0.0    [Angstrom]  # Average   of initial dipole displacements
	init_dipo_dev = 0.03  0.03  0.03   [Angstrom]  # Deviation of initial dipole displacements
	Z_star        = 9.956
	epsilon_inf   = 5.24
EOF
    echo 1 > FILES
    echo $filename >> FILES
    OMP_NUM_THREADS=3 ../feram $filename
    ln -sf $filename.`printf '%.7d' $n_coord_freq`.coord restart.coord
    cat $filename.avg >> cooling.avg
    temperature=`perl -e "print $temperature + $temperature_step"`
done
