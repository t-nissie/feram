#!/usr/bin/env gnuplot
# strain-susceptibility.gp
# Time-stamp: <2008-07-03 09:52:58 t-nissie>
# Author: Takeshi NISHIMATSU
##
set terminal postscript port enhanced color dashed "Times-Roman" 20
set output 'strain-susceptibility.eps'

set multiplot
set lmargin 10

set size 1.0,0.33

set origin 0.0,0.66

set xtics 20

set label 1 at 320, 0.02 'strain'
set format y '%.3f'
set format x ''
set key left
set yrange [0.008:0.022]
set ylabel 'strain'
plot 'heating24x24x24-20000-200000/heating.avg' using 1:5 t 'heating' w l lt 1 lw 2,\
     'heating24x24x24-20000-200000/heating.avg' using 1:6 t ''        w l lt 1 lw 2,\
     'heating24x24x24-20000-200000/heating.avg' using 1:7 t ''        w l lt 1 lw 2,\
     'cooling24x24x24-20000-200000/cooling.avg' using 1:5 t 'cooling' w l lt 3 lw 2,\
     'cooling24x24x24-20000-200000/cooling.avg' using 1:6 t ''        w l lt 3 lw 2,\
     'cooling24x24x24-20000-200000/cooling.avg' using 1:7 t ''        w l lt 3 lw 2

set format y '%.0f'


N                = 24 * 24 * 24          # unit
k_B              = 1.3806503e-23         # J/K
epsilon_0        = 8.854e-12             # F/m
a_0              = 3.94*1.0e-10          # m
unit_cell_volume = a_0**3                # m^-3
Z_star           = 9.956*1.60217733e-19  # Coulomb
C = Z_star**2 * 1.0e-10**2 / epsilon_0 / unit_cell_volume / k_B
# print C

set ylabel '{/Symbol e}_r'
set key left
set xrange [160:360]
set yrange [0:20000]

# 1 2  3  4  5   6   7   8   9   10  11 12 13 14   15   16   17   18   19    20   21
# T Ex Ey Ez exx eyy ezz eyz ezx ezy ux uy uz uxux uyuy uzuz uyuz uzux uzuy

set origin 0,0.36
set label 1 at 320, 17000 'heating'
plot 'heating24x24x24-20000-200000/heating.avg' using 1:(C*($14-N*$11**2)/$1) title '{/Symbol e}_{xx}' with l, \
     'heating24x24x24-20000-200000/heating.avg' using 1:(C*($15-N*$12**2)/$1) title '{/Symbol e}_{yy}' with l, \
     'heating24x24x24-20000-200000/heating.avg' using 1:(C*($16-N*$13**2)/$1) title '{/Symbol e}_{zz}' with l

set xlabel '{/Times-Italic T} [K]'
set format x '%.0f'
     
set size 1.0,0.383
set origin 0,0.005
set label 1 at 320, 17000 'cooling'
plot 'cooling24x24x24-20000-200000/cooling.avg' using 1:(C*($14-N*$11**2)/$1) title '{/Symbol e}_{xx}' with l, \
     'cooling24x24x24-20000-200000/cooling.avg' using 1:(C*($15-N*$12**2)/$1) title '{/Symbol e}_{yy}' with l, \
     'cooling24x24x24-20000-200000/cooling.avg' using 1:(C*($16-N*$13**2)/$1) title '{/Symbol e}_{zz}' with l

set nomultiplot
set output
!ps2pdf -sPAPERSIZE=letter strain-susceptibility.eps > strain-susceptibility.pdf

#Local variables:
#  compile-command: "gnuplot strain-susceptibility.gp && kill -HUP `pgrep gv`"
#End:
