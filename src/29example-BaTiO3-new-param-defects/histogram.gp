#!/usr/bin/env gnuplot
# histogram.gp
# Time-stamp: <2014-07-04 15:58:06 takeshi>
# Author: Takeshi NISHIMATSU
# Gist: https://gist.github.com/t-nissie/24cc524481474bb497c5
##
set terminal postscript portrait color dashed "Times-Roman" 20
set output "histogram.eps"
set ylabel 'count'
bin(x,width)=width*floor(x/width)+width/2
set multiplot
set xtics 0.1
set ytics 5
binwidth = 0.02

set label 1 at -0.15,23 "(a) rnd4.defects with a\n bug in feram-0.22.03"
set size   1.0, 0.55
set origin 0.0, 0.45
set yrange [0:25]
plot "rnd4.defects-0.22.03" using (bin($4,binwidth)):(1.0) smooth freq t 'x' with linespoints lw 3,\
     "rnd4.defects-0.22.03" using (bin($5,binwidth)):(1.0) smooth freq t 'y' with linespoints lw 3,\
     "rnd4.defects-0.22.03" using (bin($6,binwidth)):(1.0) smooth freq t 'z' with linespoints lw 3

set label 1 at -0.15,2 "(b) bug-fixed rnd4.defects"
set size   1.0, 0.46
set origin 0.0, 0.00
set yrange [0:20]
set key maxrow 2
plot "rnd4.defects"         using (bin($4,binwidth)):(1.0) smooth freq t 'x' with linespoints lw 3,\
     "rnd4.defects"         using (bin($5,binwidth)):(1.0) smooth freq t 'y' with linespoints lw 3,\
     "rnd4.defects"         using (bin($6,binwidth)):(1.0) smooth freq t 'z' with linespoints lw 3,\
     8.4                                                               t 'average: 8.4' with lines lw 2

set nomultiplot
set output
!epstopdf.pl histogram.eps

#Local variables:
#  compile-command: "gnuplot histogram.gp"
#End:
