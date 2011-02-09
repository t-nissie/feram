#!/usr/bin/env gnuplot
# hysteresis_d2.gp
# Time-stamp: <2011-02-09 19:01:00 t-nissie>
# Author: Takeshi NISHIMATSU
##
#set encoding iso_8859_1
set grid
set terminal postscript portrait enhanced solid color 'Times-Roman' 16
set output 'hysteresis_d2.eps'
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

set title 'hysteresis loop'
plot 0 title '' w l lt 9,\
     vertical_line title '' w l lt 9,\
     'hysteresis.hl'    using ( $5*100000.0):( $14*c) title 'd0' w l lt 1,\
     'hysteresis.hl'    using (-$5*100000.0):(-$14*c) notitle    w l lt 1,\
     'hysteresis_d1.hl' using ( $5*100000.0):( $14*c) title 'd1' w l lt 2,\
     'hysteresis_d1.hl' using (-$5*100000.0):(-$14*c) notitle    w l lt 2,\
     'hysteresis_d2.hl' using ( $5*100000.0):( $14*c) title 'd2' w l lt 3,\
     'hysteresis_d2.hl' using (-$5*100000.0):(-$14*c) notitle    w l lt 3

set output
!ps2pdf -sPAPERSIZE=a4 hysteresis_d2.eps

#Local variables:
#  compile-command: "gnuplot hysteresis_d2.gp"
#End:
