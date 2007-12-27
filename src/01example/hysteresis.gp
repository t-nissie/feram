#!/usr/bin/env gnuplot
# hysteresis.gp
# Time-stamp: <2007-12-27 18:10:37 takeshi>
# Author: Takeshi NISHIMATSU
##
#set encoding iso_8859_1
set terminal postscript portrait enhanced solid color 'Times-Roman' 16
set output 'hysteresis.ps'
set xrang [-4500:4500]
set key bottom right
maxy=60.0
set yrang [-maxy:maxy]
set xlabel '{/Times-Italic E} [kV/cm]'
set ylabel '{/Times-Italic P_z} [{/Symbol m}C / cm^{-2}]'
#set format y "%.2f"
#set ytics 0.05
c=1.6e3*9.956/3.94**3
vertical_line=sprintf("< (echo 0 %.2f; echo 0 %.2f)", -maxy, maxy)

set title 'hysteresis loop'
plot 0 title '' w l lt 9,\
     vertical_line title '' w l lt 9,\
     '< grep avg%polarization externalE.avg' using ( $4*100000.0):( $8*c)\
     title 'epit 16{/Symbol \264}16{/Symbol \264}({/Times-Italic l}=15, {/Times-Italic d}=1), {/Times-Italic T} = 100 K'\
     w l lt 2 ,\
     '< grep avg%polarization externalE.avg' using (-$4*100000.0):(-$8*c) title ''\
     w l lt 2

set output
!ps2pdf -sPAPERSIZE=letter hysteresis.ps > hysteresis.pdf

#Local variables:
#  compile-command: "gnuplot hysteresis.gp && kill -HUP `pgrep gv`"
#End:
