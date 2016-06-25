#!/usr/bin/env gnuplot
# Time-stamp: <2016-06-25 18:00:24 takeshi>
# Author: Takeshi NISHIMATSU
# Purpose: Check energy conservation
##
#--- Common settings ------------------------------------------------
set terminal postscript eps enhanced solid color 'Times-Roman' 16
set encoding iso_8859_1
set grid
set xlabel 'time step'
set format y '%.2f'
set key outside Left reverse spacing 1.3
set rmargin 20
set lmargin  9

set output 'plot.eps'
set yrange [-0.20:0.20]
set ylabel 'energy [eV/unitcell]'
plot '< grep " dipo_kinetic    " zzznp.log' using 0:2 title '{/Times-Italic E}_{dipole-kinetic}' w l lt 2,\
     '< grep " short_range     " zzznp.log' using 0:2 title '{/Times-Italic E}_{short-range}'    w l lt 3,\
     '< grep " long_range      " zzznp.log' using 0:2 title '{/Times-Italic E}_{long-range}'     w l lt 4,\
     '< grep " unharmonic      " zzznp.log' using 0:2 title '{/Times-Italic E}_{unharmonic}'     w l lt 5,\
     '< grep " homo_strain     " zzznp.log' using 0:2 title '{/Times-Italic E}_{homo-strain}'    w l lt 7,\
     '< grep " homo_coupling   " zzznp.log' using 0:2 title '{/Times-Italic E}_{homo-coupling}'  w l lt 8,\
     '< grep " inho_strain     " zzznp.log' using 0:2 title '{/Times-Italic E}_{inho-strain}'    w l lt 9,\
     '< grep " inho_coupling   " zzznp.log' using 0:2 title '{/Times-Italic E}_{inho-coupling}'  w l lt 2,\
     '< grep " total_energy    " zzznp.log' using 0:2 title '{/Times-Italic E}_{total}'          w l lt 1,\
     '< grep " H_Nose_Poincare " zzznp.log' using 0:2 title '{/Times-Italic H}_{N-P}'            w l lt 6

set output 'plot.Nose.eps'
set yrange [-0.5:1.5]
set ylabel ''
plot '< grep  "s_Nose"           zzznp.log' using 0:2 title '{/Times-Italic s}_{Nose}'           w l lt 4,\
     '< grep "pi_Nose"           zzznp.log' using 0:4 title       '{/Symbol p}_{Nose}'           w l lt 5

set output
#Local variables:
#  compile-command: "gnuplot plot.gp"
#End:
