#!/usr/bin/env gnuplot
# Time-stamp: <2013-05-21 20:51:49 takeshi>
# Author: Takeshi NISHIMATSU
# Purpose: Check energy conservation
##
set terminal postscript portrait enhanced solid color 'Times-Roman' 16
set output 'zzzlf.eps'
set multiplot
#set key outside
set lmargin 8

set origin 0,0.3
set size 1.0,0.7
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

set origin 0,0.0
set size 1.0,0.33
set yrange [0.0152:0.016]
set ytics auto
plot '< grep total_energy  zzzlf.log' using 0:2 t 'total energy'  w l lt  6 lw 1

set nomultiplot
set output
