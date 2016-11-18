#!/usr/bin/env gnuplot
# together.gp
# Time-stamp: <2016-11-18 16:46:52 takeshi>
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
set xlabel '{/Times-Italic T} [K]'
set ylabel 'lattice constant [\305]'

set label 4 at 70,3.987 '{/Times-Italic x} = 1.0'
set label 3 at 30,3.958 '{/Times-Italic x} = 0.5'
set label 2 at 40,3.942                     '0.2'
set label 1 at 20,3.930                     '0.0'

set output 'together.eps'
set notitle
plot 'x0.0/heating.avg' using 1:(($5+1)*a0) t 'heating' w l lt 1 lw 3,\
     'x0.0/heating.avg' using 1:(($6+1)*a0) t ''        w l lt 1 lw 3,\
     'x0.0/heating.avg' using 1:(($7+1)*a0) t ''        w l lt 1 lw 3,\
     'x0.0/cooling.avg' using 1:(($5+1)*a0) t 'cooling' w l lt 3 lw 3,\
     'x0.0/cooling.avg' using 1:(($6+1)*a0) t ''        w l lt 3 lw 3,\
     'x0.0/cooling.avg' using 1:(($7+1)*a0) t ''        w l lt 3 lw 3,\
     'x0.2/heating.avg' using 1:(($5+1)*a0) t ''        w l lt 1 lw 3,\
     'x0.2/heating.avg' using 1:(($6+1)*a0) t ''        w l lt 1 lw 3,\
     'x0.2/heating.avg' using 1:(($7+1)*a0) t ''        w l lt 1 lw 3,\
     'x0.2/cooling.avg' using 1:(($5+1)*a0) t ''        w l lt 3 lw 3,\
     'x0.2/cooling.avg' using 1:(($6+1)*a0) t ''        w l lt 3 lw 3,\
     'x0.2/cooling.avg' using 1:(($7+1)*a0) t ''        w l lt 3 lw 3,\
     'x0.5/heating.avg' using 1:(($5+1)*a0) t ''        w l lt 1 lw 3,\
     'x0.5/heating.avg' using 1:(($6+1)*a0) t ''        w l lt 1 lw 3,\
     'x0.5/heating.avg' using 1:(($7+1)*a0) t ''        w l lt 1 lw 3,\
     'x0.5/cooling.avg' using 1:(($5+1)*a0) t ''        w l lt 3 lw 3,\
     'x0.5/cooling.avg' using 1:(($6+1)*a0) t ''        w l lt 3 lw 3,\
     'x0.5/cooling.avg' using 1:(($7+1)*a0) t ''        w l lt 3 lw 3,\
     'x1.0/heating.avg' using 1:(($5+1)*a0) t ''        w l lt 1 lw 3,\
     'x1.0/heating.avg' using 1:(($6+1)*a0) t ''        w l lt 1 lw 3,\
     'x1.0/heating.avg' using 1:(($7+1)*a0) t ''        w l lt 1 lw 3,\
     'x1.0/cooling.avg' using 1:(($5+1)*a0) t ''        w l lt 3 lw 3,\
     'x1.0/cooling.avg' using 1:(($6+1)*a0) t ''        w l lt 3 lw 3,\
     'x1.0/cooling.avg' using 1:(($7+1)*a0) t ''        w l lt 3 lw 3

set output
!epstopdf.pl together.eps
#Local variables:
#  compile-command: "gnuplot together.gp"
#End:
