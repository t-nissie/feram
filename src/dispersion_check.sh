#!/bin/sh
# dispersion_check.sh
# Time-stamp: <2016-04-12 17:55:03 takeshi>
# Author: Takeshi NISHIMATSU
# Ref1: Takeshi Nishimatsu el al.: Phys. Rev. B 82, 134106 (2010),
#       http://dx.doi.org/10.1103/PhysRevB.82.134106 .
# Usage: make check TESTS=dispersion_check.sh
# Results: dispersion_32x32x32.long.interaction.eps and
#          dispersion_32x32x32.long+short.interaction.eps
#          be same as Fig.3(A) and (B) in Ref1.
##
cat > dispersion_axes.gp <<-EOF
	# dispersion_axes.gp created by dispersion_check.sh
	##
	set label 9991 'D' at 0.25                          ,\$0 center font      "Symbol,19"
	set label 9992 'Z' at 0.75                          ,\$0 center font "Times-Roman,19"
	set label 9993 'S' at 1.00+  sqrt(2.0)/4            ,\$0 center font      "Symbol,19"
	set label 9994 'L' at 1.00+  sqrt(2.0)/2+sqrt(3.0)/4,\$0 center font      "Symbol,19"
	set label 9995 'S' at 1.00+3*sqrt(2.0)/4+sqrt(3.0)/2,\$0 center font "Times-Roman,19"
	set label 9996 'S' at 1.00+5*sqrt(2.0)/4+sqrt(3.0)/2,\$0 center font "Times-Roman,19"
	set label 9997 'T' at 1.25+3*sqrt(2.0)/2+sqrt(3.0)/2,\$0 center font "Times-Roman,19"
EOF

for L1 in 4 8 16 32; do
    L2=`printf "%.2d" $L1`
    filename=dispersion_"$L2"x"$L2"x"$L2"
    cat > $filename.feram <<-EOF
	plot_dispersion = .true.
	verbose = 2
	#--- Method, Temperature, and mass ---------------
	method = 'md'
	GPa = -1.5
	kelvin = 300
	mass_amu = 38.24
	Q_Nose = 0.1
	
	#--- System geometry -----------------------------
	bulk_or_film = 'bulk'
	L = $L1 $L1 $L1
	
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
	a0          =   3.98597    [Angstrom]
	Z_star      =  10.33000
	epsilon_inf =   6.86915
	
	#--- Initial dipole configrations ----------------
	init_dipo_avg = 0.0   0.0   0.0    [Angstrom]  # Average   of initial dipole displacements
	init_dipo_dev = 0.03  0.03  0.03   [Angstrom]  # Deviation of initial dipole displacements
EOF
    cat > $filename.gp <<-EOF
	#!/usr/bin/env gnuplot
	# $filename.gp
	# Time-stamp: <2016-04-11 14:37:42 takeshi>
	# Author: Takeshi NISHIMATSU
	##
	set encoding iso_8859_1
	call '$filename.param.gp'
	c =                  14.399644 * Z_star**2 / epsilon_inf / a0**3
	omega_unit_m = sqrt( 14.399644 * Z_star**2 / epsilon_inf*4*pi / 3 / a0**3 )
	omega_unit = omega_unit_m / sqrt(mass_dipo)
	print "omega_unit = ", omega_unit, " x 10^12 [s^-1]"
	print "           = ", omega_unit/2/pi," [THz]"
	print "           = ", omega_unit/2/pi*100/2.9979," [cm^-1]"
	### Common settings
	#set title 'Phonon Dispersion of Simple Cubic Dipole Crystal'
	set ytics ( '2.0'  2.0,\\
	            '1.5'  1.5,\\
	            '1.0'  1.0,\\
	            '0.5'  0.5,\\
	            '0.0'  0.0,\\
	           '0.5i' -0.5,\\
	           '1.0i' -1.0,\\
	           '1.5i' -1.5)
	set grid
	set nokey
	set xlabel '{/Times-Italic k}'
	set xtics ('{/Symbol \\107}'   0.000000000,\\
	           'X'                0.500000000,\\
	           'M'                1.000000000,\\
	           '{/Symbol \\107}'   1.707106781,\\
	           'R'                2.573132185,\\
	           'X'                3.280238966,\\
	           'R'                3.987345747,\\
	           'M'                4.487345747)
	
	set yrange [-1.5:2]
	set ylabel '{/Symbol w} / sqrt( 4{/Symbol p}{/Times-Italic Z}^{*2} / 3{/Symbol e_\\245}{/Times-Italic M}^*{/Times-Italic a}_@0^3 )'
	call 'dispersion_axes.gp' '-1.63'
	
	set terminal postscript eps enhanced color "Times-Roman" 22
	set output "$filename.long.eps"
	set label 1 "Universal for any perovskite ferroelectrics" at 0.4,1.8 left font "Times-Roman,30" tc lt 1
	set label 2 "TO" at 0.1, -0.85 left font "Times-Roman,30" tc lt 2
	set label 3 "LO" at 0.1,  1.3  left font "Times-Roman,30" tc lt 4
	set label 4 "{/Symbol w}_@1^2+{/Symbol w}_@2^2+{/Symbol w}_@3^2=0"\\
	                               at 2.4, 1.1 left font "Times-Roman,30" tc lt 5
	plot 0,\\
	'$filename.long.dat' using 1:((\$5>0?sqrt(\$5):-sqrt(-\$5))/omega_unit_m) w l,\\
	'$filename.long.dat' using 1:((\$6>0?sqrt(\$6):-sqrt(-\$6))/omega_unit_m) w l,\\
	'$filename.long.dat' using 1:((\$7>0?sqrt(\$7):-sqrt(-\$7))/omega_unit_m) w l
	
	set terminal postscript eps enhanced color "Times-Roman" 22
	set output "$filename.short.eps"
	set nolabel 1
	set nolabel 2
	set nolabel 3
	set nolabel 4
	set nolabel 5
	plot 0,\\
	'$filename.short.dat' using 1:((\$5>0?sqrt(\$5):-sqrt(-\$5))/omega_unit_m) w l,\\
	'$filename.short.dat' using 1:((\$6>0?sqrt(\$6):-sqrt(-\$6))/omega_unit_m) w l,\\
	'$filename.short.dat' using 1:((\$7>0?sqrt(\$7):-sqrt(-\$7))/omega_unit_m) w l
	
	set terminal postscript eps enhanced color "Times-Roman" 22
	set output "$filename.long-long+short.eps"
	plot 0,\\
	'$filename.long.dat' using 1:((\$5>0?sqrt(\$5):-sqrt(-\$5))/omega_unit_m) w l,\\
	'$filename.long.dat' using 1:((\$6>0?sqrt(\$6):-sqrt(-\$6))/omega_unit_m) w l,\\
	'$filename.long.dat' using 1:((\$7>0?sqrt(\$7):-sqrt(-\$7))/omega_unit_m) w l,\\
	'$filename.long+short.dat' using 1:((\$5>0?sqrt(\$5):-sqrt(-\$5))/omega_unit_m) w l lt 11 lw 3,\\
	'$filename.long+short.dat' using 1:((\$6>0?sqrt(\$6):-sqrt(-\$6))/omega_unit_m) w l lt 12 lw 3,\\
	'$filename.long+short.dat' using 1:((\$7>0?sqrt(\$7):-sqrt(-\$7))/omega_unit_m) w l lt 13 lw 3
	
	set terminal postscript eps enhanced color "Times-Roman" 22
	set output "$filename.long+short.eps"
	set label 1 " BaTiO_3 optical phonon dispersion" at 0.6,-0.8 left font "Times-Roman,35" tc lt 1
	plot 0,\\
	'$filename.long+short.dat' using 1:((\$5>0?sqrt(\$5):-sqrt(-\$5))/omega_unit_m) w l lt 11,\\
	'$filename.long+short.dat' using 1:((\$6>0?sqrt(\$6):-sqrt(-\$6))/omega_unit_m) w l lt 12,\\
	'$filename.long+short.dat' using 1:((\$7>0?sqrt(\$7):-sqrt(-\$7))/omega_unit_m) w l lt 13
	
	set nolabel 1
	
	set yrange [-3:6]
	set ytics 1
	set format y "%.1f"
	set ylabel '(interaction energy per unit cell) / ( {/Times-Italic Z}^{*2} {/Times-Italic u}^2 / {/Symbol e_\\245}{/Times-Italic a}_@0^3 )'
	call 'dispersion_axes.gp' '-3.25'
	
	set terminal postscript eps enhanced color "Times-Roman" 22
	
	set output "$filename.long.interaction.eps"
	plot 0 w l lt 2,\\
	'$filename.long.dat' using 1:(\$5/c/2) w l lt 1 lw 3,\\
	'$filename.long.dat' using 1:(\$6/c/2) w l lt 3 lw 3,\\
	'$filename.long.dat' using 1:(\$7/c/2) w l lt 4 lw 3
	
	set output "$filename.long+short.interaction.eps"
	plot 0 w l lt 2,\\
	'$filename.long+short.dat' using 1:(\$5/c/2) w l lt 1 lw 3,\\
	'$filename.long+short.dat' using 1:(\$6/c/2) w l lt 3 lw 3,\\
	'$filename.long+short.dat' using 1:(\$7/c/2) w l lt 4 lw 3
	
	set yrange [-15:30]
	set ytics -5
	#set format y "%.3f"
	set ylabel 'Eigenvalues of {/Symbol F}({/Times-Italic k})/2 [eV \\305^{-2} unit-cell^{-1}]'
	call 'dispersion_axes.gp' '-16.3'
	
	set terminal postscript eps enhanced color "Times-Roman" 22
	set output "$filename.long.energy.eps"
	plot 0,\\
	'$filename.long.dat' using 1:(\$5/2) w l lw 3,\\
	'$filename.long.dat' using 1:(\$6/2) w l lw 3,\\
	'$filename.long.dat' using 1:(\$7/2) w l lw 3
	
	set terminal postscript eps enhanced color "Times-Roman" 22
	set output "$filename.short.energy.eps"
	plot 0,\\
	'$filename.short.dat' using 1:(\$5/2) w l lw 3,\\
	'$filename.short.dat' using 1:(\$6/2) w l lw 3,\\
	'$filename.short.dat' using 1:(\$7/2) w l lw 3
	
	set terminal postscript eps enhanced color "Times-Roman" 22
	set output "$filename.long+short.energy.eps"
	plot 0,\\
	'$filename.long+short.dat' using 1:(\$5/2) w l lw 3,\\
	'$filename.long+short.dat' using 1:(\$6/2) w l lw 3,\\
	'$filename.long+short.dat' using 1:(\$7/2) w l lw 3
	
	#Local variables:
	#  compile-command: "gnuplot $filename.gp"
	#End:
EOF
    ./feram $filename.feram
    gnuplot $filename.gp
    echo ""
done
test `grep 147957140871498 dispersion_*.long.dat     | wc -l` -eq 8
test `grep 764711401122410 dispersion_*.inhomo-K.dat | wc -l` -eq 4
