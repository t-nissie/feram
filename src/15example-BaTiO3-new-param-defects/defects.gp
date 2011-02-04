#!/usr/bin/env gnuplot
# defects.gp
# Time-stamp: <2011-02-04 21:27:43 takeshi>
# Author: Takeshi NISHIMATSU
##
#set encoding iso_8859_1
set nogrid
set terminal postscript enhanced portrait 'Times-Roman' 18
set output 'defects.eps'
set size 1.0,0.5
set xrang [-10000:10000]
set key bottom right
maxy=100.0
set yrang [-maxy:maxy]
#set title "`basename $PWD`"
set xlabel '{/Times-Italic E} [kV/cm]'
set ylabel '{/Times-Italic P_z} [{/Symbol m}C / cm^{2}]'
#set format y "%.2f"
set xtics 5000
c=1.6e3*9.956/3.94**3
vertical_line=sprintf("< (echo 0 %.2f; echo 0 %.2f)", -maxy, maxy)

plot 0 title '' w l lt 9,\
     vertical_line title '' w l lt 9,\
     'nodefects.hl' using ( $5*100000.0):( $14*c) notitle                         w l lt 1,\
     'nodefects.hl' using (-$5*100000.0):(-$14*c) title 'non-polarized interface' w l lt 1,\
     'forward.hl'   using ( $5*100000.0):( $14*c) notitle                         w l lt 3 lw 2,\
     'backward.hl'  using ( $5*100000.0):( $14*c) title 'polarized defects'       w l lt 3 lw 2

set output
!ps2pdf -sPAPERSIZE=a4 defects.eps > defects.pdf

#Local variables:
#  compile-command: "gnuplot defects.gp"
#End:
