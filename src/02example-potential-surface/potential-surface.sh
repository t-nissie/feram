#!/bin/sh
# potential-surface.sh
# Time-stamp: <07/12/29 10:10:54 takeshi>
# Author: Takeshi NISHIMATSU
##

for bulk_or_film in epit film ; do

    gap=0
    for Lz in 32 32 64 128 256 ; do
	thickness=`expr $Lz / 2 - $gap`

	init_dipo_stripe_lambda_2=0
	while [ $init_dipo_stripe_lambda_2 -le 16 ] ; do
	    lambda=`expr $init_dipo_stripe_lambda_2 \* 2`
	    dat=$bulk_or_film-L`printf '%.3d' $thickness`-D$gap-lambda`printf '%.3d' $lambda`.dat
	    rm -f $dat

	    u_z=0.0
	    while [ `perl -e "print $u_z <= 0.2 || 0"` = "1" ] ; do
		cat > feram.in <<EOF
#--- Method, Temperature, and mass ---------------
method = 'md'
GPa = -5.0
kelvin = 100
mass_amu = 39.0
Q_Nose = 0.05

#--- System geometry -----------------------------
bulk_or_film = '$bulk_or_film'
L = 32 32 $Lz
gap = $gap
a0 =  3.94         latice constant a0 [Angstrom]
epi_strain = -0.01
#--- Time step -----------------------------------
dt = 0.002
n_thermalize = 0
n_average    = 1
n_coord_freq = 10

#--- External electric field ---------------------
external_E_field = 0.00 0.00 0.00

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
init_dipo_avg = 0.00  0.00  $u_z   [Angstrom]  # Average   of initial dipole displacements
init_dipo_dev = 0.00  0.00  0.00   [Angstrom]  # Deviation of initial dipole displacements
init_dipo_stripe_lambda_2 = $init_dipo_stripe_lambda_2
Z_star        = 9.956
epsilon_inf   = 5.24
EOF
		printf '%.3f' $u_z >> $dat
		../feram feram.in | grep total_energy | head -1 >> $dat
		u_z=`perl -e "print $u_z + 0.01"`
	    done

	    init_dipo_stripe_lambda_2=`expr $init_dipo_stripe_lambda_2 \* 2`
	    if [ $init_dipo_stripe_lambda_2 -eq 0 ] ; then
		init_dipo_stripe_lambda_2=1
	    fi
	done

	gap=1
    done

done
