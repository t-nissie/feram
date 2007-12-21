#!/bin/sh
# externalE.sh
# Time-stamp: <2007-12-21 15:45:34 takeshi>
# Author: Takeshi NISHIMATSU
##
rm -f externalE.avg

temperature=100

externalE_start=-0.04
externalE_goal=0.04
externalE_step=0.001

n_thermalize=40000
n_average=10000
n_coord_freq=`expr $n_thermalize + $n_average`

i=0
externalE=$externalE_start
while [ `echo "$externalE <= $externalE_goal" | bc` = "1" ] ; do
i=`expr $i + 1`
filename=externalE"$temperature"K`printf '%.3d%+.5f' $i $externalE`
cat > $filename <<EOF
#--- Method, Temperature, and mass ---------------
method = 'md'
GPa = -5.0
kelvin = $temperature
mass_amu = 39.0
Q_Nose = 0.05

#--- System geometry -----------------------------
bulk_or_film = 'epit'
L = 16 16 32
gap = 1
a0 =  3.94         latice constant a0 [Angstrom]
epi_strain = -0.01
#--- Time step -----------------------------------
dt = 0.002
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
../feram $filename
ln -sf $filename.`printf '%.7d' $n_coord_freq`.coord restart.coord
cat $filename.avg >> externalE.avg
externalE=`echo "$externalE + $externalE_step" | bc`
done
