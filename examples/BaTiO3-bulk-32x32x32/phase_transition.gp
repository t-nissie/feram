#!/usr/bin/env gnuplot
# Time-stamp: <2007-05-03 11:16:00 t-nissie>
# Author: Takeshi NISHIMATSU
##
set grid
set xrange [100:400]
set xlabel 'temperature [K]'

set terminal postscript landscape enhanced color 'Times-Roman' 24
set output 'phase_transition.eps'
set format y '%.3f'
set yrange [0.007:0.022]
set ylabel 'strain'
plot '< grep avg%sorted_strain heating.avg' using 1:3 t 'heating' w l lt 1 lw 2,\
     '< grep avg%sorted_strain heating.avg' using 1:4 not         w l lt 1 lw 2,\
     '< grep avg%sorted_strain heating.avg' using 1:5 not         w l lt 1 lw 2,\
     '< grep avg%sorted_strain cooling.avg' using 1:3 t 'cooling' w l lt 3 lw 2,\
     '< grep avg%sorted_strain cooling.avg' using 1:4 not         w l lt 3 lw 2,\
     '< grep avg%sorted_strain cooling.avg' using 1:5 not         w l lt 3 lw 2
#Local variables:
#  compile-command: "gnuplot hysteresis.gp && kill -HUP `pgrep gv`"
#End:
