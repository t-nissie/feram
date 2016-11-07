#!/usr/bin/env gnuplot
# feram_fft_contour.gp
##
set terminal postscript eps enhanced color dashed "Times-Roman,12"
set encoding iso_8859_1
set size 0.39,1.0
filename='epit.0008000000.fft'
set output "| sed 's/50 50 190 302/85 105 167 247/' >".filename.'.eps'

set contour
set view 0,0
unset surface

set xrange [-1.5:33.5]
set xtics 16

set yrange [-1.5:65.5]
set ytics ("-32" 0, "-16" 16, "0" 32, "16" 48, "32" 64)

set grid
unset key
splot filename w l lw 3
