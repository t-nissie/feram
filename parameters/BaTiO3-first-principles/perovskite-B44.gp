#!/usr/bin/env gnuplot
##
HARTREE_IN_EV = 27.21138386

set encoding iso_8859_1
set terminal postscript portrait enhanced "Times-Roman" color 24
set output "perovskite-B44.eps"

Etot(x) = 3.0/2*B44 * x**2 + Emin
# initial values
B44     =    30.0   # [eV]
Emin    = -3587.0   # [eV]
fit Etot(x) 'perovskite-B44.dat' using ($1):($3*HARTREE_IN_EV) via B44, Emin

set format y "%.3f"
set ylabel "{/Times-Italic E}_{tot}-{/Times-Italic E}_0 [eV]"

#set origin 0.0,0.0
#set yrange [-0.005:0.020]
set xlabel "{/Symbol d}"
set xtics 0.01
set ytics 0.005
plot 'perovskite-B44.dat' using  ($1):($3*HARTREE_IN_EV-Emin) t 'calculated data' w p lt 3 pt 3 ps 2 lw 3,\
     3.0/2*B44 * x**2 t 'quadratic fitting' w l lt 3 lw 3

print 'B44 = ', B44, ' [eV]'

#Local variables:
#  compile-command: "gnuplot perovskite-B44.gp"
#End:
