#!/usr/bin/env gnuplot
# polarization.gp
# Time-stamp: <2016-02-22 10:47:14 t-nissie>
# Author: Takeshi NISHIMATSU
##
set encoding iso_8859_1  # for Angstrom
set terminal postscript port enhanced color dashed "Times-Roman" 22
set output 'polarization.eps'
set multiplot
set lmargin 8

set xtics 100
set xrange [0:600]
a0      =   3.98597
Z_star  =  10.33000
c=1.6e3*Z_star/a0**3

set origin 0.0,0.5
set size 1.0,0.5
set yrange [3.96:4.08]
set format y '%.2f'
set key right bottom
set ylabel 'lattice constant [\305]'
set label 1 at 50,4.066 '(a)'
plot 'heating.avg' using 1:(($5+1)*a0) t 'heating' w l lt 1 lw 2,\
     'heating.avg' using 1:(($6+1)*a0) t ''        w l lt 1 lw 2,\
     'heating.avg' using 1:(($7+1)*a0) t ''        w l lt 1 lw 2,\
     'cooling.avg' using 1:(($5+1)*a0) t 'cooling' w l lt 3 lw 2,\
     'cooling.avg' using 1:(($6+1)*a0) t ''        w l lt 3 lw 2,\
     'cooling.avg' using 1:(($7+1)*a0) t ''        w l lt 3 lw 2

# 1 2  3  4  5   6   7   8   9   10  11 12 13 14   15   16   17   18   19    20   21
# T Ex Ey Ez exx eyy ezz eyz ezx ezy ux uy uz uxux uyuy uzuz uyuz uzux uzuy
set origin 0.0,0.0
set size 1.0,0.535
set yrange [-5:45]
#set ytics 5
set format y '%.0f'
set ylabel '{/Times-Italic P}_{/Symbol a} [{/Symbol m}C cm^{-2}]'
set xlabel '{/Times-Italic T} [K]'
set key right top
set label 1 at 50,36 '(b)'
plot 'heating.avg' using 1:(c*$11) t 'heating' w l lt 1 lw 3,\
     'heating.avg' using 1:(c*$12) t ''        w l lt 1 lw 3,\
     'heating.avg' using 1:(c*$13) t ''        w l lt 1 lw 3,\
     'cooling.avg' using 1:(c*$11) t 'cooling' w l lt 3 lw 3,\
     'cooling.avg' using 1:(c*$12) t ''        w l lt 3 lw 3,\
     'cooling.avg' using 1:(c*$13) t ''        w l lt 3 lw 3
set nomultiplot
set output
!epstopdf.pl polarization.eps
#Local variables:
#  compile-command: "gnuplot polarization.gp"
#End:
