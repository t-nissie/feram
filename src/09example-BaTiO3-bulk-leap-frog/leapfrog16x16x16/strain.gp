#!/usr/bin/env gnuplot
# Time-stamp: <2011-02-21 11:08:45 takeshi>
# Author: Takeshi NISHIMATSU
##
#set grid
set xrange [150:400]
#set xtics 1
set xlabel 'temperature [K]'

set terminal postscript portrait enhanced color 'Times-Roman' 24
set output 'strain.eps'
set size 1.0,0.5
#set key at 255,0.0215
set title 'colorful leap frog'
set format y '%.3f'
set yrange [0.006:0.022]
set ylabel 'strain'
plot 'leapfrog.avg' using 1:5 t '' w l lt 1 lw 2,\
     'leapfrog.avg' using 1:6 t '' w l lt 2 lw 2,\
     'leapfrog.avg' using 1:7 t '' w l lt 3 lw 2

#Local variables:
#  compile-command: "gnuplot strain.gp && kill -HUP `pgrep gv`"
#End:
