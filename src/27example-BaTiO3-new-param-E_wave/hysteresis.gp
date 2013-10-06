#!/usr/bin/env gnuplot
# hysteresis.gp
# Time-stamp: <2013-10-06 22:51:01 takeshi>
# Author: Takeshi NISHIMATSU
##
#set encoding iso_8859_1
set grid
set terminal postscript portrait enhanced solid color 'Times-Roman' 20
set output 'hysteresis.eps'
set xrang [-400:400]
set key bottom right
maxy=60.0
#set yrang [-maxy:maxy]
set xlabel '{/Times-Italic E} [kV/cm]'
set ylabel '{/Times-Italic P_z} [{/Symbol m}C / cm^{2}]'
#set format y "%.2f"
set xtics 100
c=1.6e3*9.956/3.94**3
vertical_line=sprintf("< (echo 0 %.2f; echo 0 %.2f)", -maxy, maxy)

set title 'hysteresis loop'
plot vertical_line title '' w l lt 9,\
     '360sin.hl' using ( $5*100000.0):( $14*c)\
     title 'bulk 32{/Symbol \264}32{/Symbol \264}32, {/Times-Italic T} = 360 K, sin' w l lt 1,\
     '360cos.hl' using ( $5*100000.0):( $14*c)\
     title 'bulk 32{/Symbol \264}32{/Symbol \264}32, {/Times-Italic T} = 360 K, cos' w l lt 2,\
     0 title '' w l lt 9

set output
!epstopdf.pl hysteresis.eps

#Local variables:
#  compile-command: "gnuplot hysteresis.gp"
#End:
