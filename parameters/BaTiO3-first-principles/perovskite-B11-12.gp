#!/usr/bin/env gnuplot
##
HARTREE_IN_EV = 27.21138386

set encoding iso_8859_1
set terminal postscript portrait enhanced "Times-Roman" color 24
set output "perovskite-B11-12.eps"
set size 1.0,0.5

Etot(x) = 3.0/4*B11_12 * x**2 + Emin
# initial values
B11_12     =    30.0   # [eV]
Emin       = -3587.0   # [eV]
fit Etot(x) 'perovskite-B11-12.dat' using ($1):($3*HARTREE_IN_EV) via B11_12, Emin

set format y "%.3f"
set ylabel "{/Times-Italic E}_{tot}-{/Times-Italic E}_0 [eV]"

#set origin 0.0,0.0
#set yrange [-0.005:0.020]
set xlabel "{/Symbol d}"
set xtics 0.01
set ytics 0.005
plot 'perovskite-B11-12.dat' using  ($1):($3*HARTREE_IN_EV-Emin) t 'calculated data' w p lt 2 pt 2 ps 2 lw 3,\
     3.0/4*B11_12 * x**2 t 'quadratic fitting' w l lt 2 lw 3

print 'B11-B12 = ', B11_12, ' [eV]'

#set output
#!gs -q -sDEVICE=ppm -sPAPERSIZE=a4 -r90x90 -dSAFER -dNOPAUSE -dBATCH -sOutputFile=- -q perovskite-B11-12.eps | \
#                                                  pnmcrop -white | cjpeg -quality 90 > perovskite-B11-12.jpg

#Local variables:
#  compile-command: "gnuplot perovskite-B11-12.gp"
#End:
