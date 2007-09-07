#!/usr/bin/env gnuplot
# Time-stamp: <2005-10-18 10:27:45 t-nissie>
# Author: Takeshi NISHIMATSU
##
set grid
set xrange [100:400]
set xlabel 'temperature [K]'

set terminal postscript landscape enhanced color 'Times-Roman' 24
set output 'strain.heating-cooling.ps'
#set title 'p=-5.0 [GPa],  Q_{Nose}=0.1 [eV ps^2],   n_{thermalize}=40,000,   n_{average}=10,000'
set format y '%.3f'
set yrange [0.007:0.022]
set ylabel 'strain'
plot 'heating.strain.dat' using 1:3 t 'heating' w l lt 1 lw 2,\
     'heating.strain.dat' using 1:4 t ''        w l lt 1 lw 2,\
     'heating.strain.dat' using 1:5 t ''        w l lt 1 lw 2,\
     'cooling.strain.dat' using 1:3 t 'cooling' w l lt 3 lw 2,\
     'cooling.strain.dat' using 1:4 t ''        w l lt 3 lw 2,\
     'cooling.strain.dat' using 1:5 t ''        w l lt 3 lw 2

#Local variables:
#  compile-command: "gnuplot strain.heating-cooling.gp && kill -HUP `pgrep gv`"
#End:
