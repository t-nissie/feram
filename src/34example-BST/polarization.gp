#!/usr/bin/env gnuplot
# polarization.gp
# Time-stamp: <2016-07-04 18:03:58 takeshi>
# Author: Takeshi NISHIMATSU
##
set encoding iso_8859_1  # for Angstrom
set terminal postscript eps enhanced color dashed "Times-Roman" 32

set lmargin 8
set xtics 100
set xrange [0:500]
a0      =   3.9435
c=1.6e3/a0**3
set yrange [3.92:4.02]
set format y '%.2f'
set key left top
set ylabel 'lattice constant [\305]'

set output 'polarization_a.eps'
set title "`pwd | sed -e 's/.*-b/{\/Times-Italic b}=/' -e 's/-SR16000.*//'`, `basename $PWD | sed -e 's/x/{\/Times-Italic x}=/'`"
plot 'heating.avg' using 1:(($5+1)*a0) t 'heating' w l lt 1 lw 3,\
     'heating.avg' using 1:(($6+1)*a0) t ''        w l lt 1 lw 3,\
     'heating.avg' using 1:(($7+1)*a0) t ''        w l lt 1 lw 3,\
     'cooling.avg' using 1:(($5+1)*a0) t 'cooling' w l lt 3 lw 3,\
     'cooling.avg' using 1:(($6+1)*a0) t ''        w l lt 3 lw 3,\
     'cooling.avg' using 1:(($7+1)*a0) t ''        w l lt 3 lw 3

set notitle
set output 'polarization.eps'
set size 1.0,2.0
set multiplot
set origin 0.0,1.0
set size 1.0,1.0
set label 1 at 50,4.066 '(a)'
replot

# 1 2  3  4  5   6   7   8   9   10  11 12 13 14   15   16   17   18   19    20   21
# T Ex Ey Ez exx eyy ezz eyz ezx ezy ux uy uz uxux uyuy uzuz uyuz uzux uzuy
set origin 0.0,0.0
set size 1.0,1.08
set xlabel '{/Times-Italic T} [K]'
set yrange [-10:40]
#set ytics 5
set format y '%.0f'
set ylabel '{/Times-Italic P}_{/Symbol a} [{/Symbol m}C cm^{-2}]'
set key right top
set label 1 at 50,36 '(b)'
call 'polarization-local.gp'
plot 'heating.avg' using 1:(c*$35) t 'heating' w l lt 1 lw 3,\
     'heating.avg' using 1:(c*$36) t ''        w l lt 1 lw 3,\
     'heating.avg' using 1:(c*$37) t ''        w l lt 1 lw 3,\
     'cooling.avg' using 1:(signx*c*$35) t 'cooling' w l lt 3 lw 3,\
     'cooling.avg' using 1:(signy*c*$36) t ''       w l lt 3 lw 3,\
     'cooling.avg' using 1:(signz*c*$37) t ''        w l lt 3 lw 3
set nomultiplot
set output
!epstopdf.pl polarization.eps
#Local variables:
#  compile-command: "gnuplot polarization.gp"
#End:
