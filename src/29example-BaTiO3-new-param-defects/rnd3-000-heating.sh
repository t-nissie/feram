#!/bin/sh
# rnd3-000-heating.sh
# Time-stamp: <2014-05-13 20:46:15 t-nissie>
# Author: Takeshi NISHIMATSU
##
rm -f rnd3-000-heating.avg

temperature_start=250
temperature_goal=900
temperature_step=1

n_thermalize=20000
n_average=80000
n_coord_freq=`expr $n_thermalize + $n_average`

i=0
for temperature in `seq $temperature_start $temperature_step $temperature_goal`; do
    GPa=`perl -e "print -0.005 * $temperature"`
    i=`expr $i + 1`
    filename=rnd3-000-heating`printf '%.3d' $i`-"$temperature"K
    cat > $filename.feram <<-EOF
	#--- Method, Temperature, and mass ---------------
	method = 'vs'
	GPa = $GPa
	kelvin = $temperature
	mass_amu = 38.24
	acoustic_mass_amu = 46.44
	
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
	#(- 8.1460516421 (- (/  -3.812330 2) -1.51821042113588)) =>  8.53400622096412 new P_kappa2

	#--- Time step -----------------------------------
	dt = 0.002 [pico second]
	n_thermalize = $n_thermalize
	n_average    = $n_average
	n_coord_freq = $n_coord_freq
	external_E_field = 0.00 0.00 0.00000
	distribution_directory = 'never'
	
	#--- From eigenvalues2j --------------------------
	# original  P_kappa2 =    8.1460516421 [eV/Angstrom^2] =    0.0838298622 [Hartree/Bohr^2]
	P_kappa2 = 8.53400622096412
	j =  -2.08403 -1.12904  0.68946 -0.61134  0.00000  0.27690  0.00000    [eV/Angstrom^2]
	a0	  =   3.98597    [Angstrom]
	Z_star      =  10.33000
	epsilon_inf =   6.86915
	
	#--- Initial dipole configrations ----------------
	init_dipo_avg = 0.00  0.00  0.20   [Angstrom]  # Average   of initial dipole displacements
	init_dipo_dev = 0.02  0.02  0.02   [Angstrom]  # Deviation of initial dipole displacements
EOF
    if [ -r "$prev_coord" ]; then
       ln -sf "$prev_coord" $filename.restart
    fi
    ln -sf rnd3.defects $filename.defects
    ./feram $filename.feram
    rm -f $prev_coord $filename.restart
    prev_coord=$filename.`printf '%.10d' $n_coord_freq`.coord
    cat $filename.avg >> rnd3-000-heating.avg
done

rm rnd3-000-heating???-[2-8]??K.*
