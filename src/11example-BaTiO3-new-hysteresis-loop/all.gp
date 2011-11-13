#!/usr/bin/env gnuplot
# all.gp
# Time-stamp: <2011-11-13 11:08:19 t-nissie>
# Author: Takeshi NISHIMATSU
##
#set encoding iso_8859_1
set grid
set terminal postscript portrait enhanced solid color 'Times-Roman' 16
set output 'all.eps'
set xrang [-3000:3000]
set key bottom right
maxy=60.0
#set yrang [-maxy:maxy]
set xlabel '{/Times-Italic E} [kV/cm]'
set ylabel '{/Times-Italic P_z} [{/Symbol m}C / cm^{2}]'
#set format y "%.2f"
set xtics 1000
c=1.6e3*9.956/3.94**3
vertical_line=sprintf("< (echo 0 %.2f; echo 0 %.2f)", -maxy, maxy)

set title 'hysteresis loop, {/Times-Italic T} = 150 K'
plot 0 title '' w l lt 9,\
     vertical_line title '' w l lt 9,\
     'hysteresis_d0.hl' using ( $5*100000.0):( $14*c)\
     title 'epit 16{/Symbol \264}16{/Symbol \264}({/Times-Italic l}=40, gap\_id=0)' w l lt 1,\
     'hysteresis_d0.hl' using (-$5*100000.0):(-$14*c) notitle w l lt 1,\
     'hysteresis_d1_forward.hl' using ( $5*100000.0):( $14*c)\
     title 'epit 16{/Symbol \264}16{/Symbol \264}({/Times-Italic l}=40.5, gap\_id=1)' w l lt 2,\
     'hysteresis_d1_backwrd.hl' using ( $5*100000.0):( $14*c) notitle w l lt 2,\
     'hysteresis_d2.hl' using ( $5*100000.0):( $14*c)\
     title 'epit 16{/Symbol \264}16{/Symbol \264}({/Times-Italic l}=45, gap\_id=2)' w l lt 3,\
     'hysteresis_d2.hl' using (-$5*100000.0):(-$14*c) notitle w l lt 3

set output
#!ps2pdf -sPAPERSIZE=a4 all.eps > all.pdf

#Local variables:
#  compile-command: "gnuplot all.gp"
#End:
