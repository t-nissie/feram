#!/usr/bin/env gnuplot
# Time-stamp: <2009-03-27 00:44:57 takeshi>
# Author: Takeshi NISHIMATSU
##
set encoding iso_8859_1

set xrange [0:0.3]
set yrange [-0.1:0.15]
set xlabel '{/Times-Italic u} = sqrt({/Times-Italic u_@x}^2+{/Times-Italic u_@y}^2+{/Times-Italic u_@z}^2) [\305]'
#set xtics 100

set terminal postscript portrait enhanced color 'Times-Roman' 20
set output 'compare-potential-surface.eps'
set size 1.0,0.5

set key 0.19,0.14
#set title 'p=-5.0 [GPa],  Q_{Nose}=0.05 [eV ps^2],   n_{thermalize}=40,000,   n_{average}=10,000'
set format y '%.2f'
set ylabel '{/Times-Italic E}_{tot}-{/Times-Italic E}_0 [eV]'

# y_min=-0.005
# y_max= 0.03
# set yrange [y_min:y_max]
# set ylabel 'strain'
# set arrow 1 from 408,y_min to 408,y_max nohead lt 2
# set arrow 2 from 273,y_min to 273,y_max nohead lt 2
# set arrow 3 from 183,y_min to 183,y_max nohead lt 2

set origin 0.0,0.5
plot 'kappa5.5/potential-surface-001.dat' using 1:3            title '{/Symbol k}_2 = 5.5, [001]' w lp lt 4 pt 1 lw 2 ps 1,\
     'kappa5.5/potential-surface-110.dat' using ($1*sqrt(2)):3 title '{/Symbol k}_2 = 5.5, [110]' w lp lt 4 pt 2 lw 2 ps 1,\
     'kappa5.5/potential-surface-111.dat' using ($1*sqrt(3)):3 title '{/Symbol k}_2 = 5.5, [111]' w lp lt 4 pt 3 lw 2 ps 1,\
     'kappa4.0/potential-surface-001.dat' using 1:3            title '{/Symbol k}_2 = 4.0, [001]' w lp lt 3 pt 1 lw 2 ps 1,\
     'kappa4.0/potential-surface-110.dat' using ($1*sqrt(2)):3 title '{/Symbol k}_2 = 4.0, [110]' w lp lt 3 pt 2 lw 2 ps 1,\
     'kappa4.0/potential-surface-111.dat' using ($1*sqrt(3)):3 title '{/Symbol k}_2 = 4.0, [111]' w lp lt 3 pt 3 lw 2 ps 1

#set output
#!gs -q -sDEVICE=ppm -sPAPERSIZE=a4 -r90x90 -dSAFER -dNOPAUSE -dBATCH -sOutputFile=- -q compare-potential-surface.eps | cjpeg -quality 90 > compare-potential-surface.jpg

#Local variables:
#  compile-command: "gnuplot compare-potential-surface.gp && kill -HUP `pgrep gv`"
#End:
