#!/bin/sh
# potential_surface_check.sh
# Time-stamp: <2016-05-23 11:08:11 takeshi>
# Author: Takeshi NISHIMATSU
##
for alpha in 1 2 3; do
    data_file=potential_surface_$alpha.dat
    rm -f $data_file
    for u in `seq -w 0.00 0.02 0.47`; do
        printf "%s" $u >> $data_file
        uu=`perl -e "print $u/sqrt($alpha)"`
        case "$alpha" in
            1)
                init_dipo_avg="0.0 0.0 $uu" ;;
            2)
                init_dipo_avg="$uu $uu 0.0" ;;
            3)
                init_dipo_avg="$uu $uu $uu" ;;
        esac
        cat > potential_surface_input.feram <<-EOF
	#--- Method, Temperature, and mass ---------------
	method = 'md'
	kelvin = 300
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
	#(- 8.1460516421 (- (/  -3.812330 2) -1.51821042113588)) =>  8.53400622096412 new P_kappa2
	
	#--- Time step -----------------------------------
	dt = 0.002 [pico second]
	n_thermalize = 1
	n_average    = 1
	n_coord_freq = 3
	coord_directory = 'never'
	distribution_directory = 'never'
	
	#--- From eigenvalues2j --------------------------
	# original  P_kappa2 =    8.1460516421 [eV/Angstrom^2] =    0.0838298622 [Hartree/Bohr^2]
	P_kappa2 = 8.53400622096412
	j =  -2.08403 -1.12904  0.68946 -0.61134  0.00000  0.27690  0.00000    [eV/Angstrom^2]
	a0  =   3.98597    [Angstrom]
	Z_star      =  10.33000
	epsilon_inf =   6.86915
	
	#--- Initial dipole configrations ----------------
	init_dipo_avg = $init_dipo_avg
	init_dipo_dev = 0.00  0.00  0.00   [Angstrom]  # Deviation of initial dipole displacements
EOF
        ./feram potential_surface_input.feram
        grep total_energy potential_surface_input.log | head -1 >> $data_file
    done
done
cat > potential_surface_check.gp <<-EOF
	set encoding iso_8859_1
	set terminal postscript eps enhanced color "Times-Roman" 22
	set output "potential_surface_check.eps"
	set key bottom
	set xrange [0:1]
	set yrange [-0.10:0.15]
	plot 'potential_surface_1.dat' u 1:3 t "[001]" w l lw 3,\\
	     'potential_surface_2.dat' u 1:3 t "[110]" w l lw 3,\\
	     'potential_surface_3.dat' u 1:3 t "[111]" w l lw 3
	set output
EOF
gnuplot  potential_surface_check.gp
epstopdf potential_surface_check.eps
#Local variables:
#  compile-command: "./potential_surface_check.sh && head potential_surface_?.dat"
#End:
