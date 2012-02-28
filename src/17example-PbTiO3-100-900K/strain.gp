#!/usr/bin/env gnuplot
# strain.gp
# Time-stamp: <2011-11-18 13:35:13 t-nissie>
# Author: Takeshi NISHIMATSU
##
set terminal postscript port enhanced color dashed "Times-Roman" 20
set encoding iso_8859_1
set output 'strain.eps'

#set multiplot
set lmargin 10

set size 1.0,0.5

#set title "`basename $PWD`"

set xrange [0:1000]
set xtics 200

a0=3.96883

set label 1 at 750, 4.010 'cubic'           font 'Times-Roman'  textcolor lt 1
set label 2 at 300, 3.918 'a'               font 'Times-Italic' textcolor lt 1
set label 3 at 300, 4.205 'c'               font 'Times-Italic' textcolor lt 1
set label 4 at 500, 3.957 'b{/Symbol \242}' font 'Times-Italic' textcolor lt 3
set label 5 at 500, 4.003 'a{/Symbol \242}' font 'Times-Italic' textcolor lt 3
set label 6 at 500, 4.070 'c{/Symbol \242}' font 'Times-Italic' textcolor lt 3
set label 7 at  70, 4.180 'tetragonal'      font 'Times-Roman'  textcolor lt 1
set format y '%.2f'
set key right
#set yrange [-0.02:0.08]
#set ytics 0.02
set xlabel '{/Times-Italic T} [K]'
set ylabel 'lattice constants [\305]'
plot \
     'cooling.avg' using 1:(a0*(1+$5)) t 'cooling' w l lt 3 lw 2,\
     'cooling.avg' using 1:(a0*(1+$6)) t ''        w l lt 3 lw 2,\
     'cooling.avg' using 1:(a0*(1+$7)) t ''        w l lt 3 lw 2,\
     'heating.avg' using 1:(a0*(1+$5)) t 'heating' w l lt 1 lw 2,\
     'heating.avg' using 1:(a0*(1+$6)) t ''        w l lt 1 lw 2,\
     'heating.avg' using 1:(a0*(1+$7)) t ''        w l lt 1 lw 2

set output
#!ps2pdf -sPAPERSIZE=letter strain.eps > strain.pdf

#Local variables:
#  compile-command: "gnuplot strain.gp"
#End:
