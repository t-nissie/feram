#!/usr/bin/env gnuplot
# Time-stamp: <2005-10-17 18:05:44 t-nissie>
# Author: Takeshi NISHIMATSU
# Purpose: Check energy conservation
##

set terminal postscript portrait enhanced color 'Times-Roman' 16
set output 'epit.ps'
set lmargin 10
set grid
set xrange [0:800]
set xtics 100
set xlabel 'temperature [K]'
set multiplot
set size 1.0,0.5

set origin 0,0.5
set title   'total energy (16x16, l=15, d=1, e_{xx}=e_{yy}=-0.01, p=-5GPa)'
set ylabel '[eV/unitcell]'
set key t l
set yrange [-0.04:0.20]
set ytics 0.04
set format y "%.2f"
plot '< grep "avg%total" heating.out' using 1:3 title 'heating' w l lt 1,\
     '< grep "avg%total" cooling.out' using 1:3 title 'cooling' w l lt 3

set origin 0,0.0
set title 'z displacement (16x16, l=15, d=1, e_{xx}=e_{yy}=-0.01, p=-5GPa)'
set ylabel '[Angstrom]'
set key t r
set yrange [-0.025:0.20]
set ytics 0.025
set format y "%.3f"
plot '< grep "avg%polar" heating.out' using 1:5 title 'heating' w l lt 1,\
     '< grep "avg%polar" cooling.out' using 1:5 title 'cooling' w l lt 3

#Local variables:
#  compile-command: "gnuplot epit.gp && kill -HUP `pgrep gv`"
#End:
