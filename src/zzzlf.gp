#!/usr/bin/env gnuplot
# Time-stamp: <2016-10-20 16:08:45 takeshi>
# Author: Takeshi NISHIMATSU
# Purpose: Check energy conservation
##
set terminal postscript eps enhanced solid color 'Times-Roman' 24
set encoding iso_8859_1
set output 'zzzlf.eps'
set size 1.1,2.0
set multiplot
set lmargin 10
set size 1.1,1.0
set format y '%.3f'
set ylabel 'energy [eV/f.u.]'

set origin 0,1.0
set yrange [-0.3:0.3]
set tmargin 6
set key outside above
plot '< grep " acou_kinetic  " zzzlf.log' using 0:2 t 'acou kinetic'  w l lt  2 lw 2,\
     '< grep " dipo_kinetic  " zzzlf.log' using 0:2 t 'dipo kinetic'  w l lt  3 lw 2,\
     '< grep " short_range   " zzzlf.log' using 0:2 t 'short range'   w l lt  1 lw 2,\
     '< grep " long_range    " zzzlf.log' using 0:2 t 'long range'    w l lt  4 lw 2,\
     '< grep " unharmonic    " zzzlf.log' using 0:2 t 'unharmonic'    w l lt  5 lw 2,\
     '< grep " homo_strain   " zzzlf.log' using 0:2 t 'homo strain'   w l lt  6 lw 2,\
     '< grep " homo_coupling " zzzlf.log' using 0:2 t 'homo coupling' w l lt  7 lw 2,\
     '< grep " inho_strain   " zzzlf.log' using 0:2 t 'inho strain'   w l lt  8 lw 2,\
     '< grep " inho_coupling " zzzlf.log' using 0:2 t 'inho coupling' w l lt  9 lw 2,\
     '< grep " total_energy  " zzzlf.log' using 0:2 t 'total'         w l lt 10 lw 2

set origin 0,0.0
set yrange [0.021:0.025]
set ytics   0.001
set tmargin 0
set nokey
plot '< grep acou_kinetic  zzzlf.log' using 0:2 w l lt  2,\
     '< grep dipo_kinetic  zzzlf.log' using 0:2 w l lt  3,\
     '< grep inho_strain   zzzlf.log' using 0:2 w l lt  8,\
     '< grep total_energy  zzzlf.log' using 0:2 w l lt 10

set nomultiplot
set output
#!epstopdf zzzlf.eps   ! It takes time.

#Local variables:
#  compile-command: "./zzzlf.gp"
#End:
