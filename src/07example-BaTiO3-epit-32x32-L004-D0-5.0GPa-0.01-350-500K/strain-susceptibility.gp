#!/usr/bin/env gnuplot
# strain-susceptibility.gp
# Time-stamp: <2008-07-14 17:43:41 takeshi>
# Author: Takeshi NISHIMATSU
##
set terminal postscript port enhanced color dashed "Times-Roman" 20
set output 'strain-susceptibility.eps'

set multiplot
set lmargin 10

set size 1.0,0.33

set origin 0.0,0.66

set xrange [350:500]
set xtics 25

set label 1 at 475, 0.044 'strain'
set format y '%.3f'
set format x ''
set key right bottom
set yrange [-0.02:0.05]
set ylabel 'strain'

# 0 t '' w l lt 9
plot 'heating/heating.avg' using 1:7 t 'heating {/Times-Italic e_{zz}}        ' w lp lt 1 pt 1 lw 2,\
     'heating/heating.avg' using 1:5 t 'heating {/Times-Italic e_{xx}=e_{yy}}'  w lp lt 4 pt 2 lw 2,\
     'cooling/cooling.avg' using 1:7 t 'cooling {/Times-Italic e_{zz}}        ' w lp lt 3 pt 4 lw 2,\
     'cooling/cooling.avg' using 1:5 t 'cooling {/Times-Italic e_{xx}=e_{yy}}'  w lp lt 5 pt 6 lw 2

set format y '%.0f'


N                = 32 * 32 * 4
                                         # unit
k_B              = 1.3806503e-23         # J/K
epsilon_0        = 8.854e-12             # F/m
a_0              = 3.94*1.0e-10          # m
unit_cell_volume = a_0**3                # m^-3
Z_star           = 9.956*1.60217733e-19  # Coulomb
C = Z_star**2 * 1.0e-10**2 / epsilon_0 / unit_cell_volume / k_B
# print C

set key left top
set ylabel '{/Symbol e}_r'
set key left
set autoscale y
set yrange [0:25000]

# 1 2  3  4  5   6   7   8   9   10  11 12 13 14   15   16   17   18   19    20   21
# T Ex Ey Ez exx eyy ezz eyz ezx ezy ux uy uz uxux uyuy uzuz uyuz uzux uzuy

set origin 0,0.36
set label 1 at 470, 4500 'heating'
plot 'heating/heating.avg' using 1:(C*($16-N*$13**2)/$1) title '{/Symbol e}_{/Times-Italic zz}'                                w lp lt 1 pt 1 lw 2, \
     'heating/heating.avg' using 1:(C*($14-N*$11**2)/$1) title '{/Symbol e}_{/Times-Italic xx}={/Symbol e}_{/Times-Italic yy}' w lp lt 4 pt 2 lw 2

set xlabel '{/Times-Italic T} [K]'
set format x '%.0f'
     
set size 1.0,0.383
set origin 0,0.005
set label 1 at 470, 4500 'cooling'
plot 'cooling/cooling.avg' using 1:(C*($16-N*$13**2)/$1) title '{/Symbol e}_{/Times-Italic zz}'                                w lp lt 3 pt 4 lw 2, \
     'cooling/cooling.avg' using 1:(C*($14-N*$11**2)/$1) title '{/Symbol e}_{/Times-Italic xx}={/Symbol e}_{/Times-Italic yy}' w lp lt 5 pt 6 lw 2

set nomultiplot
set output
!ps2pdf -sPAPERSIZE=a4 strain-susceptibility.eps > strain-susceptibility.pdf

#Local variables:
#  compile-cqommand: "gnuplot strain-susceptibility.gp && kill -HUP `pgrep gv`"
#End:qq
