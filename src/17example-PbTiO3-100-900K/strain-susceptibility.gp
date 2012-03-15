#!/usr/bin/env gnuplot
# strain-susceptibility.gp
# Time-stamp: <2012-03-15 10:22:33 takeshi>
# Author: Takeshi NISHIMATSU
##
set terminal postscript port enhanced color dashed "Times-Roman" 20
set encoding iso_8859_1
set output 'strain-susceptibility.eps'

set multiplot
set lmargin 10

set size 1.0,0.33

set origin 0.0,0.66

set xtics 100

set xrange [100:900]


set label 1 at 320, 0.02 'strain'
a0=3.96883

set label 1 at 750, 4.020 'cubic'           font 'Times-Roman'  textcolor lt 1
set label 2 at 300, 3.918 'a'               font 'Times-Italic' textcolor lt 1
set label 3 at 300, 4.205 'c'               font 'Times-Italic' textcolor lt 1
set label 4 at 500, 3.957 'b{/Symbol \242}' font 'Times-Italic' textcolor lt 3
set label 5 at 500, 4.003 'a{/Symbol \242}' font 'Times-Italic' textcolor lt 3
set label 6 at 500, 4.070 'c{/Symbol \242}' font 'Times-Italic' textcolor lt 3
set label 7 at  70, 4.180 'tetragonal'      font 'Times-Roman'  textcolor lt 1
set format y '%.2f'
set key right

set ylabel 'lattice constants [\305]'
plot \
     'cooling.avg' using 1:(a0*(1+$5)) t 'cooling' w l lt 3 lw 2,\
     'cooling.avg' using 1:(a0*(1+$6)) t ''        w l lt 3 lw 2,\
     'cooling.avg' using 1:(a0*(1+$7)) t ''        w l lt 3 lw 2,\
     'heating.avg' using 1:(a0*(1+$5)) t 'heating' w l lt 1 lw 2,\
     'heating.avg' using 1:(a0*(1+$6)) t ''        w l lt 1 lw 2,\
     'heating.avg' using 1:(a0*(1+$7)) t ''        w l lt 1 lw 2

set nolabel 1
set nolabel 2
set nolabel 3
set nolabel 4
set nolabel 5
set nolabel 6
set nolabel 7     

set format y '%.0f'


N                = 32 * 32 * 32          # unit
k_B              = 1.3806503e-23         # J/K
epsilon_0        = 8.854e-12             # F/m
a_0              = 3.96883*1.0e-10       # m
unit_cell_volume = a_0**3                # m^-3
Z_star           = 10.0181*1.60217733e-19  # Coulomb
C = Z_star**2 * 1.0e-10**2 / epsilon_0 / unit_cell_volume / k_B
# print C

set ylabel '{/Symbol e}_r'
set key left
set yrange [0:16000]

# 1 2  3  4  5   6   7   8   9   10  11 12 13 14   15   16   17   18   19    20   21
# T Ex Ey Ez exx eyy ezz eyz ezx ezy ux uy uz uxux uyuy uzuz uyuz uzux uzuy

set origin 0,0.36
set label 1 at 320, 10000 'heating'
plot 'heating.avg' using 1:(C*($14-N*$11**2)/$1) title '{/Symbol e}_{xx}' with l, \
     'heating.avg' using 1:(C*($15-N*$12**2)/$1) title '{/Symbol e}_{yy}' with l, \
     'heating.avg' using 1:(C*($16-N*$13**2)/$1) title '{/Symbol e}_{zz}' with l

set xlabel '{/Times-Italic T} [K]'
set format x '%.0f'
     
set size 1.0,0.383
set origin 0,0.005
set label 1 at 320, 10000 'cooling'
plot 'cooling.avg' using 1:(C*($14-N*$11**2)/$1) title '{/Symbol e}_{xx}' with l, \
     'cooling.avg' using 1:(C*($15-N*$12**2)/$1) title '{/Symbol e}_{yy}' with l, \
     'cooling.avg' using 1:(C*($16-N*$13**2)/$1) title '{/Symbol e}_{zz}' with l

set nomultiplot
set output
!ps2pdf -sPAPERSIZE=letter strain-susceptibility.eps > strain-susceptibility.pdf

#Local variables:
#  compile-command: "gnuplot strain-susceptibility.gp"
#End:
