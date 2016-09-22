#!/bin/sh
# modulation_check.sh
# Time-stamp: <2016-06-22 12:02:39 takeshi>
# Author:     Takeshi NISHIMATSU
# Usage:      make check TESTS=modulation_check.sh
# Results:    zzzmodulation.0000000001-acouR-{x,y,z}.eps
##
cat > zzzmodulation.feram <<-EOF
	#!./feram
	verbose = 2
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
	n_thermalize =  1
	n_average    =  1
	n_coord_freq =  1
	distribution_directory = 'never'
	
	#--- On-site (Polynomial of order 4) -------------
	P_kappa2 =    5.502  [eV/Angstrom^2] # P_4(u) = kappa2*u^2 + alpha*u^4
	P_alpha  =  110.4    [eV/Angstrom^4] #  + gamma*(u_y*u_z+u_z*u_x+u_x*u_y),
	P_gamma  = -163.1    [eV/Angstrom^4] # where u^2 = u_x^2 + u_y^2 + u_z^2
	
	#--- Inter-site ----------------------------------
	j = -2.648 3.894 0.898 -0.789 0.562 0.358 0.179    j(i) [eV/Angstrom^2]
	
	#--- Elastic Constants ---------------------------
	modulation_constant = 6.3
	B11 = 126.
	B12 =  44.9
	B44 =  50.3  [eV]
	
	#--- Elastic Coupling ----------------------------
	B1xx = -211.   [eV/Angstrom^2]
	B1yy =  -19.3  [eV/Angstrom^2]
	B4yz =   -7.75 [eV/Angstrom^2]
	
	#--- Dipole --------------------------------------
	init_dipo_avg = 0.000 0.000 0.000   [Angstrom]  # Average   of initial dipole displacements
	init_dipo_dev = 0.000 0.000 0.000   [Angstrom]  # Deviation of initial dipole displacements
	Z_star        = 9.956
	epsilon_inf   = 5.24
EOF
cat > zzzmodulation.modulation <<-EOF
	0 0 0 -1.0
	8 8 8  1.0
EOF
./feram zzzmodulation.feram
ln -sf zzzmodulation.param.gp param.gp
$srcdir/feram_cross_section_acouR.sh zzzmodulation.0000000001.coord 30.0 8 z
$srcdir/feram_cross_section_acouR.sh zzzmodulation.0000000001.coord 30.0 8 y
$srcdir/feram_cross_section_acouR.sh zzzmodulation.0000000001.coord 30.0 8 x
rm -f param.gp
if [ `grep '  0\.234808E-01 ' zzzmodulation.0000000001.coord | wc -l` -ne 6 ]; then
    echo $0:$LINENO: The number of vectors should be 6.
    exit 1
fi
if [ `grep ' -0\.234808E-01 ' zzzmodulation.0000000001.coord | wc -l` -ne 6 ]; then
    echo $0:$LINENO: The number of vectors should be 6.
    exit 2
fi
if [ `grep 'inho_strain      *0\.000072004971' zzzmodulation.log | wc -l` -ne 3 ]; then
    echo $0:$LINENO: Wrong V_inho_strain value\(s\).
    exit 3
fi
if [ `grep 'inho_modulation *-0\.000144009942' zzzmodulation.log | wc -l` -ne 3 ]; then
    echo $0:$LINENO: Wrong V_inho_strain value\(s\).
    exit 4
fi
