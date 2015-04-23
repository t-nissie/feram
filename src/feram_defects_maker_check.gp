#!/usr/bin/env gnuplot
# defects_maker_check.gp
# Time-stamp: <2014-05-19 14:40:56 takeshi>
# Author: Takeshi NISHIMATSU
# Usage: gnuplot -e 'basename="defects_maker_check"; binwidth=0.1' defects_maker_check.gp
##
set terminal postscript landscape color dashed "Times-Roman" 24
defects_file = basename.".defects"
set output basename.".eps"
set title "histogram of ".basename.".defects"
set ylabel 'count'
set key bottom right
bin(x,width)=width*floor(x/width)+width/2
plot defects_file using (bin($4,binwidth)):(1.0) smooth freq t 'x' with linespoints lw 3,\
     defects_file using (bin($5,binwidth)):(1.0) smooth freq t 'y' with linespoints lw 3,\
     defects_file using (bin($6,binwidth)):(1.0) smooth freq t 'z' with linespoints lw 3
set output
