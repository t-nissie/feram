#!/usr/bin/env gnuplot
# hysteresis.gp
# Time-stamp: <2008-10-15 12:30:15 takeshi>
# Author: Takeshi NISHIMATSU
##
#set encoding iso_8859_1
set grid
set terminal postscript portrait enhanced solid color 'Times-Roman' 16
set output 'hysteresis.eps'
set xrang [-2500:2500]
set key bottom right
maxy=60.0
#set yrang [-maxy:maxy]
set xlabel '{/Times-Italic E} [kV/cm]'
set ylabel '{/Times-Italic P_z} [{/Symbol m}C / cm^{2}]'
#set format y "%.2f"
set xtics 500
c=1.6e3*9.956/3.94**3
vertical_line=sprintf("< (echo 0 %.2f; echo 0 %.2f)", -maxy, maxy)

set title 'hysteresis loop'
plot 0 title '' w l lt 9,\
     vertical_line title '' w l lt 9,\
     'hysteresis.hl' using ( $4*100000.0):( $13*c)\
     title 'epit 16{/Symbol \264}16{/Symbol \264}({/Times-Italic l}=4, {/Times-Italic d}=0), {/Times-Italic T} = 175 K' w l lt 2,\
     'hysteresis.hl' using (-$4*100000.0):(-$13*c) notitle w l lt 2 

set output
!ps2pdf -sPAPERSIZE=letter hysteresis.eps > hysteresis.pdf

#Local variables:
#  compile-command: "gnuplot hysteresis.gp && kill -HUP `pgrep gv`"
#End:
