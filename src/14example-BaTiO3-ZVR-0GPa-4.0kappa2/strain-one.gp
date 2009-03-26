#!/usr/bin/env gnuplot
# Time-stamp: <2009-03-26 22:58:36 takeshi>
# Author: Takeshi NISHIMATSU
##
#set grid
set xrange [0:500]
set xlabel 'temperature [K]'
set xtics 100

set terminal postscript portrait enhanced color 'Times-Roman' 24
set output 'strain-one.eps'
set size 1.0,0.5

#set key left
#set title 'p=-5.0 [GPa],  Q_{Nose}=0.05 [eV ps^2],   n_{thermalize}=40,000,   n_{average}=10,000'
set format y '%.3f'

y_min=-0.005
y_max= 0.03
set yrange [y_min:y_max]
set ylabel 'strain'
set arrow 1 from 408,y_min to 408,y_max nohead lt 2
set arrow 2 from 273,y_min to 273,y_max nohead lt 2
set arrow 3 from 183,y_min to 183,y_max nohead lt 2

set origin 0.0,0.5
plot '0GPa.avg'    using 1:2 notitle     w l lt 4 lw 2,\
     '0GPa.avg'    using 1:3 notitle     w l lt 4 lw 2,\
     '0GPa.avg'    using 1:4 notitle     w l lt 4 lw 2,\
     'cooling.avg' using 1:5 t ''        w l lt 3 lw 2,\
     'cooling.avg' using 1:6 t ''        w l lt 3 lw 2,\
     'cooling.avg' using 1:7 t ''        w l lt 3 lw 2

set output
!gs -q -sDEVICE=ppm -sPAPERSIZE=a4 -r90x90 -dSAFER -dNOPAUSE -dBATCH -sOutputFile=- -q strain-one.eps | cjpeg -quality 90 > strain-one.jpg

#Local variables:
#  compile-command: "gnuplot strain-one.gp && kill -HUP `pgrep gv`"
#End:
