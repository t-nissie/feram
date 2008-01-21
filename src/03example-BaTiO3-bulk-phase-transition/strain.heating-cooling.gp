#!/usr/bin/env gnuplot
# Time-stamp: <2008-01-21 15:10:19 takeshi>
# Author: Takeshi NISHIMATSU
##
#set grid
set xrange [150:350]
set xlabel 'temperature [K]'

set terminal postscript portrait enhanced color 'Times-Roman' 24
set output 'strain.heating-cooling.ps'
set size 1.0,0.5
set key 255,0.0215
#set title 'p=-5.0 [GPa],  Q_{Nose}=0.05 [eV ps^2],   n_{thermalize}=40,000,   n_{average}=10,000'
set format y '%.3f'
set yrange [0.008:0.022]
set ylabel 'strain'
plot '< grep avg%strain heating.avg' using 1:6 t 'heating' w l lt 1 lw 2,\
     '< grep avg%strain heating.avg' using 1:7 t ''        w l lt 1 lw 2,\
     '< grep avg%strain heating.avg' using 1:8 t ''        w l lt 1 lw 2,\
     '< grep avg%strain cooling.avg' using 1:6 t 'cooling' w l lt 3 lw 2,\
     '< grep avg%strain cooling.avg' using 1:7 t ''        w l lt 3 lw 2,\
     '< grep avg%strain cooling.avg' using 1:8 t ''        w l lt 3 lw 2

#Local variables:
#  compile-command: "gnuplot strain.heating-cooling.gp && kill -HUP `pgrep gv`"
#End:
