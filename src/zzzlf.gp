#!/usr/bin/env gnuplot
# Time-stamp: <2013-05-21 19:13:49 takeshi>
# Author: Takeshi NISHIMATSU
# Purpose: Check energy conservation
##
set terminal postscript landscape enhanced solid color 'Times-Roman' 16
set output 'zzzlf.eps'
set key outside
set yrange [-0.14:0.08]
set ytics 0.02
plot '< grep acou_kinetic  zzzlf.log' using 0:2 t 'acou kinetic'  w l lt  1 lw 3,\
     '< grep dipo_kinetic  zzzlf.log' using 0:2 t 'dipo kinetic'  w l lt  2 lw 3,\
     '< grep dipole_dipole zzzlf.log' using 0:2 t 'dipole dipole' w l lt  3 lw 3,\
     '< grep "unharmonic " zzzlf.log' using 0:2 t 'unharmonic'    w l lt  4 lw 3,\
     '< grep homo_strain   zzzlf.log' using 0:2 t 'homo strain'   w l lt  5 lw 3,\
     '< grep homo_coupling zzzlf.log' using 0:2 t 'homo coupling' w l lt  9 lw 3,\
     '< grep inho_strain   zzzlf.log' using 0:2 t 'inho strain'   w l lt  7 lw 3,\
     '< grep inho_coupling zzzlf.log' using 0:2 t 'inho coupling' w l lt  8 lw 3,\
     '< grep total_energy  zzzlf.log' using 0:2 t 'total energy'  w l lt  6 lw 5
