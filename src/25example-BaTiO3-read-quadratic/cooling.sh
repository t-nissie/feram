#!/bin/sh
# cooling.sh
# Time-stamp: <2013-04-23 19:36:39 takeshi>
# Author: Takeshi NISHIMATSU
##
rm -f cooling.avg

temperature_start=600
temperature_goal=30
temperature_step=-2

n_thermalize=40000
n_average=20000
n_coord_freq=`expr $n_thermalize + $n_average`

i=0
temperature=$temperature_start
while [ `perl -e "print $temperature >= $temperature_goal || 0"` = "1" ] ; do
    GPa=`perl -e "print -0.005 * $temperature"`
    i=`expr $i + 1`
    filename=cooling`printf '%.3d' $i`-"$temperature"K
    cat > $filename.feram <<-EOF
	#--- Method, Temperature, and mass ---------------
	method = 'md'
	GPa = $GPa
	kelvin = $temperature
	mass_amu = 38.24
	Q_Nose = 0.1
	
	#--- System geometry -----------------------------
	bulk_or_film = 'bulk'
	L = 16 16 16
	
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
	#        -1.51821042113588 + 4.074269676/2 = 0.51892441686412 = P_kappa2

	#--- Time step -----------------------------------
	dt = 0.002 [pico second]
	n_thermalize = $n_thermalize
	n_average    = $n_average
	n_coord_freq = $n_coord_freq
	distribution_directory = 'never'
	
	#--- From eigenvalues2j --------------------------
	P_kappa2 = 0.51892441686412
	j =  0 0 0 0 0 0 0
	a0	  =   3.98597    [Angstrom]
	Z_star      =  10.33000
	epsilon_inf =   6.86915
	
	#--- Initial dipole configrations ----------------
	init_dipo_avg = 0.0   0.0   0.0    [Angstrom]  # Average   of initial dipole displacements
	init_dipo_dev = 0.03  0.03  0.03   [Angstrom]  # Deviation of initial dipole displacements
EOF
    if [ -r "$prev_coord" ]; then
        ln -sf "$prev_coord" $filename.restart
    fi
    ln -s zzzquadratic.quadratic $filename.quadratic
    ../feram $filename.feram
    rm -f $prev_coord $filename.restart
    prev_coord=$filename.`printf '%.10d' $n_coord_freq`.coord
    cat $filename.avg >> cooling.avg
    temperature=`perl -e "print $temperature + $temperature_step"`
done
