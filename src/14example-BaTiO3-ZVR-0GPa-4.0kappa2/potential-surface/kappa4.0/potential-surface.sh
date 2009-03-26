#!/bin/sh
# potential-surface.sh
# Time-stamp: <2009-03-26 23:58:33 takeshi>
# Author: Takeshi NISHIMATSU
##

for direction in 001 110 111; do
dat_file=potential-surface-$direction.dat
rm -f $dat_file
u_z=0.0
while [ `perl -e "print $u_z <= 0.3 || 0"` = "1" ] ; do
    case $direction in
	001) init_dipo_avg="0.00  0.00  $u_z"
	     ;;
	110) init_dipo_avg="$u_z  $u_z  0.00"
	     ;;
	111) init_dipo_avg="$u_z  $u_z  $u_z"
	     ;;
    esac
    cat > feram.in <<-EOF
	#--- Method, Temperature, and mass ---------------
	method = 'md'
	GPa = 0.0
	kelvin = 300
	mass_amu = 39.0
	Q_Nose = 0.1
	
	#--- System geometry -----------------------------
	bulk_or_film = 'bulk'
	L = 16 16 16
	a0 =  3.94         latice constant a0 [Angstrom]
	#--- Time step -----------------------------------
	dt = 0.002 [pico second]
	n_thermalize = 0
	n_average    = 1
	n_coord_freq = 3
	
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
	init_dipo_avg = $init_dipo_avg     [Angstrom]  # Average   of initial dipole displacements
	init_dipo_dev = 0.00  0.00  0.00   [Angstrom]  # Deviation of initial dipole displacements
	Z_star        = 9.956
	epsilon_inf   = 5.24
EOF
    printf '%.3f' $u_z >> $dat_file
    ../../feram feram.in | grep total_energy | head -1 >> $dat_file
    u_z=`perl -e "print $u_z + 0.01"`
done
done