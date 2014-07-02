#!/bin/sh
# coolflm.sh
# Time-stamp: <2014-07-02 10:30:55 takeshi>
# Author: Takeshi NISHIMATSU
##
rm -f coolflm.avg

n_thermalize=20000
n_average=20000
n_coord_freq=`expr $n_thermalize + $n_average`

i=0
for temperature in `jot - 1000 300 -1`; do
    i=`expr $i + 1`
    filename=coolflm`printf '%.3d' $i`-"$temperature"K
    cat > $filename.feram <<-EOF
	#--- Method, Temperature, and mass ---------------
	method = 'md'
	kelvin = $temperature
	mass_amu = 100.0
	Q_Nose = 3.0

	#--- System geometry -----------------------------
	bulk_or_film = 'film'
	L = 32 32 64
	a0 =  3.96883      latice constant a0 [Angstrom]
	#--- Time step -----------------------------------
	dt = 0.002 [pico second]
	n_thermalize = $n_thermalize
	n_average    = $n_average
	n_coord_freq = $n_coord_freq
	distribution_directory = 'never'

	#--- On-site (Polynomial of order 8) -------------
	P_kappa2 =    1.17004 [eV/Angstrom2] # P_4(u) = kappa2*u2 +alpha*u4
	P_alpha  =  27.8341  [eV/Angstrom4] #  +gamma*(u_y*u_z+u_z*u_x+u_x*u_y),
	P_gamma  = -34.4762  [eV/Angstrom4] # where u2 = u_x2 + u_y2 +u_z2
	P_k1  = -42.4238
	P_k2  = 0.0
	P_k3  = 0.0
	P_k4  = 156.432

	#--- Inter-site ----------------------------------
	j = -1.354782  4.98616  0.2216286  -0.01820766  0.3982454 -0.083301867 -0.20356880

	#--- Elastic Constants ---------------------------
	B11 = 117.9
	B12 =  51.6
	B44 = 137.0  [eV]

	#--- Elastic Coupling ----------------------------
	B1xx = -114.02   [eV/Angstrom2]
	B1yy =  -13.6748 [eV/Angstrom2]
	B4yz =  -22.67   [eV/Angstrom2]

	#--- Dipole --------------------------------------
	seed = 1242914819 1957271599
	init_dipo_avg = 0.000 0.000 0.330   [Angstrom]  # Averaged of initial dipole displacements
	init_dipo_dev = 0.045 0.045 0.021   [Angstrom]  # Deviation of initial dipole displacements
	Z_star        = 10.0181
	epsilon_inf   = 8.24
EOF
    if [ -r "$prev_coord" ]; then
        ln -sf "$prev_coord" $filename.restart
    fi
    ../feram $filename.feram
    rm -f "$prev_coord" "$filename.restart"
    prev_coord=$filename.`printf '%.10d' $n_coord_freq`.coord
    cat $filename.avg >> coolflm.avg
done
