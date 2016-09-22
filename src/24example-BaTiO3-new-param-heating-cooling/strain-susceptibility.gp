#!/usr/bin/env gnuplot
# strain-susceptibility.gp
# Time-stamp: <2016-06-17 14:31:46 t-nissie>
# Author: Takeshi NISHIMATSU
##
set terminal postscript eps enhanced color dashed "Times-Roman" 30
set output 'strain-susceptibility.eps'

set size 1.0,3.0
set multiplot
set lmargin 11
set size 1.0,1.0
set origin 0.0,2.0

set xtics 100

set label 1 at 320, 0.02 'strain'
set format y '%.3f'
set key left
set xrange [0:800]
set yrange [-0.005:0.025]
set ylabel 'strain'
plot 'heating.avg' using 1:5 t 'heating' w l lt 1 lw 2,\
     'heating.avg' using 1:6 t ''        w l lt 1 lw 2,\
     'heating.avg' using 1:7 t ''        w l lt 1 lw 2,\
     'cooling.avg' using 1:5 t 'cooling' w l lt 3 lw 2,\
     'cooling.avg' using 1:6 t ''        w l lt 3 lw 2,\
     'cooling.avg' using 1:7 t ''        w l lt 3 lw 2

set tmargin 0
set format y '%.0f'

N                = 16 ** 3               # unit
k_B              = 1.3806503e-23         # J/K
epsilon_0        = 8.854e-12             # F/m
a_0              = 3.98597*1.0e-10       # m
unit_cell_volume = a_0**3                # m^-3
elem_charge      = 1.60217733e-19        # Coulomb
C = elem_charge**2 * 1.0e-10**2 / epsilon_0 / unit_cell_volume / k_B
# print C

set ylabel '{/Symbol e}_r'
set key left
set yrange [0:20000]

set origin 0.0,1.0
set label 1 at 320, 17000 'heating'
plot 'heating.avg' using 1:(C*($38-N*$35**2)/$1) title '{/Symbol e}_{xx}' with l, \
     'heating.avg' using 1:(C*($39-N*$36**2)/$1) title '{/Symbol e}_{yy}' with l, \
     'heating.avg' using 1:(C*($40-N*$37**2)/$1) title '{/Symbol e}_{zz}' with l

set xlabel '{/Times-Italic T} [K]'
set format x '%.0f'
     
set origin 0,0.0
set label 1 at 320, 17000 'cooling'
plot 'cooling.avg' using 1:(C*($38-N*$35**2)/$1) title '{/Symbol e}_{xx}' with l, \
     'cooling.avg' using 1:(C*($39-N*$36**2)/$1) title '{/Symbol e}_{yy}' with l, \
     'cooling.avg' using 1:(C*($40-N*$37**2)/$1) title '{/Symbol e}_{zz}' with l

set nomultiplot
set output
!epstopdf strain-susceptibility.eps

#Local variables:
#  compile-command: "gnuplot strain-susceptibility.gp"
#End:
