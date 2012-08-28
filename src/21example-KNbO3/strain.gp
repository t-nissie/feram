#!/usr/bin/env gnuplot
# Time-stamp: <2012-08-28 10:02:51 takeshi>
# Author: Takeshi NISHIMATSU
##
a0=4.01688

set terminal postscript landscape enhanced solid color 'Times-Roman' 22
set encoding iso_8859_1
set xlabel 'Temperature [K]'
set ylabel 'lattice parameters [\305]'
set output 'strain.eps'
set key left
set grid

set title "Wu and Cohen's GGA, {/Times-Italic p}=-0.001{/Times-Italic T} GPa"
set xrange [0:800]
set yrange [3.95:4.15]
set format y "%.2f"

plot 'heating.avg' using 1:(a0*(1+$5)) t 'heating' w l lt 1,\
     'heating.avg' using 1:(a0*(1+$6)) t ''        w l lt 1,\
     'heating.avg' using 1:(a0*(1+$7)) t ''        w l lt 1,\
     'cooling.avg' using 1:(a0*(1+$5)) t 'cooling' w l lt 3,\
     'cooling.avg' using 1:(a0*(1+$6)) t ''        w l lt 3,\
     'cooling.avg' using 1:(a0*(1+$7)) t ''        w l lt 3

set output

!epstopdf.pl strain.eps
#Local variables:
#  compile-command: "gnuplot strain.gp"
#End:
