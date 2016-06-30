#!/bin/sh
# heating.sh
# Time-stamp: <2016-06-30 22:38:38 takeshi>
# Author: Takeshi NISHIMATSU
##
rm -f heating.avg

n_thermalize=40000
n_average=20000
n_coord_freq=`expr $n_thermalize + $n_average`

i=0
for temperature in `seq  30  2 800`; do
    GPa=`perl -e "print -0.001 * $temperature"`
    i=`expr $i + 1`
    filename=heating`printf '%.3d' $i`-"$temperature"K
    cat > $filename.feram <<-EOF
	#--- Method, Temperature, and mass ---------------
	method = 'md'
	GPa = $GPa
	kelvin = $temperature
	mass_amu = 68.25
	Q_Nose = 0.01
	
	#--- System geometry -----------------------------
	bulk_or_film = 'bulk'
	L = 16 16 16
	
	#--- Elastic Constants ---------------------------
	B11 = 164.56407139412
	B12 =  27.9612831141443
	B44 =  36.1255633920307
	
	#--- From perovskite-optcell2-p.gp ---------------
	B1xx = -220.537577127088 [eV/Angstrom^2]
	B1yy = 34.0565716866381 [eV/Angstrom^2]
	B4yz = -7.66610564649724 [eV/Angstrom^2]
	P_k1 = -333.17838722887 [eV/Angstrom^6]
	P_k2 = 126.285330208685 [eV/Angstrom^6]
	P_k3 = 513.793632976991 [eV/Angstrom^6]
	P_k4 = 744.578404817517 [eV/Angstrom^8]
	P_alpha = 95.7608710590633 [eV/Angstrom^4]
	P_gamma = -135.117399456386 [eV/Angstrom^4]
	#kappa = -2.67634990507792 [eV/Angstrom^2]
	#(- 10.4499144792 (- (/  -7.297692 2) -2.67634990507792)) =>  11.42241057412208 new P_kappa2
	
	#--- Time step -----------------------------------
	dt = 0.002 [pico second]
	n_thermalize = $n_thermalize
	n_average    = $n_average
	n_coord_freq = $n_coord_freq
	distribution_directory = 'never'
	
	#--- From eigenvalues2j --------------------------
	# original  P_kappa2 =   10.4499144792 [eV/Angstrom^2] =    0.1075385879 [Hartree/Bohr^2]
	P_kappa2 = 11.42241057412208
	j =  -3.27266 -1.15363  1.10401 -0.66206  0.00000  0.30358  0.00000    [eV/Angstrom^2]
	a0          =   4.01688    [Angstrom]
	Z_star      =  12.69000
	epsilon_inf =   6.99900
	
	#--- Initial dipole configrations ----------------
	init_dipo_avg = 0.11  0.11  0.11   [Angstrom]  # Average   of initial dipole displacements
	init_dipo_dev = 0.02  0.02  0.02   [Angstrom]  # Deviation of initial dipole displacements
EOF
    if [ -r "$prev_coord" ]; then
        ln -sf "$prev_coord" $filename.restart
    fi
    ../feram $filename.feram
    rm -f $prev_coord $filename.restart $filename.dipoRavg
    prev_coord=$filename.`printf '%.10d' $n_coord_freq`.coord
    cat $filename.avg >> heating.avg
done
echo '#' `head -1 $filename.log | sed 's/.*START: //'` `hostname` >> heating.avg
