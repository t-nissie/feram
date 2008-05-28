#!/bin/sh
# externalE.sh
# Time-stamp: <2008-05-28 18:31:26 t-nissie>
# Author: Takeshi NISHIMATSU
##
rm -f externalE.avg

temperature=175

externalE_start=-0.02
externalE_goal=0.02
externalE_step=0.002

n_thermalize=40000
n_average=60000
n_coord_freq=`expr $n_thermalize + $n_average`

dt=0.002

frequency=`perl -e "print $externalE_step/(4.0e-6*$dt*$n_coord_freq*$externalE_goal)"`
printf "# dt = %.6f [pico second]\n"                       $dt             >> externalE.avg
printf "# n_steps = %d\n"                                  $n_coord_freq   >> externalE.avg
printf "# E_0 = %.5f [V/Angstrom]\n"                       $externalE_goal >> externalE.avg
printf "# dE  = %.5f [V/Angstrom]\n"                       $externalE_step >> externalE.avg
printf "# frequency = dE/(4 dt n_steps E_0)= %.6f [MHz]\n" $frequency      >> externalE.avg

i=0
externalE=$externalE_start
while [ `perl -e "print $externalE <= $externalE_goal || 0"` = "1" ] ; do
    i=`expr $i + 1`
    filename=externalE"$temperature"K`printf '%.3d%+.5f' $i $externalE`
    cat > $filename <<-EOF
	#--- Method, Temperature, and mass ---------------
	method = 'md'
	GPa = -5.0
	kelvin = $temperature
	mass_amu = 39.0
	Q_Nose = 0.05
	
	#--- System geometry -----------------------------
	bulk_or_film = 'epit'
	L = 16 16 8
	gap = 0
	a0 =  3.94         latice constant a0 [Angstrom]
	epi_strain = -0.01
	#--- Time step -----------------------------------
	dt = $dt [pico second]
	n_thermalize = $n_thermalize
	n_average    = $n_average
	n_coord_freq = $n_coord_freq
	
	#--- External electric field ---------------------
	external_E_field = 0.00 0.00 $externalE
	
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
	init_dipo_avg = 0.00  0.00 -0.10   [Angstrom]  # Average   of initial dipole displacements
	init_dipo_dev = 0.02  0.02  0.02   [Angstrom]  # Deviation of initial dipole displacements
	Z_star        = 9.956
	epsilon_inf   = 5.24
EOF
    echo 1 > FILES
    echo $filename >> FILES
    ../feram $filename
    # OMP_NUM_THREADS=6 ./feram $filename > /dev/null
    ln -sf $filename.`printf '%.7d' $n_coord_freq`.coord restart.coord
    cat $filename.avg >> externalE.avg
    externalE=`perl -e "print $externalE + $externalE_step"`
done
