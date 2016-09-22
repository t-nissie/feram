#!/usr/bin/env gnuplot
# feram_defects_maker_check.gp
# Time-stamp: <2016-08-06 09:44:28 takeshi>
# Author: Takeshi NISHIMATSU
# Usage: gnuplot -e 'basename="feram_defects_maker_check"; binwidth=0.1' feram_defects_maker_check.gp
##
set encoding iso_8859_1
set terminal postscript eps color dashed "Times-Roman" 24
defects_file = basename.".defects"
set output basename.".eps"
set title "histogram of ".basename.".defects"
set ylabel 'count'
set key bottom right
set format x '%0.1f'
bin(x,width)=width*floor(x/width)+width/2
plot defects_file using (bin($4,binwidth)):(1.0) smooth freq t 'x' with linespoints lw 3,\
     defects_file using (bin($5,binwidth)):(1.0) smooth freq t 'y' with linespoints lw 3,\
     defects_file using (bin($6,binwidth)):(1.0) smooth freq t 'z' with linespoints lw 3
set output
#!epstopdf feram_defects_maker_check.eps
#Local variables:
#  compile-command: "./feram_defects_maker_check.gp"
#End:
