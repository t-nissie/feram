#!/usr/bin/env gnuplot
# histogram.gp
# Time-stamp: <2008-01-29 00:25:36 takeshi>
# Author: Takeshi NISHIMATSU
##
filename='cooling010-305K.0050000.coord'
histogram=sprintf("< ruby histogram.rb %s", filename)
ps=sprintf("%s.histogram.ps", filename)

set encoding iso_8859_1
set terminal postscript portrait enhanced solid color 'Times-Roman' 16
set output ps
set xrang [-0.25:0.25]
set yrang [0:400]
#set key bottom right
set xlabel 'displacement [\305]'
set ylabel 'counts'


set title filename
plot histogram using 1:2 title '{/Times-Italic u_x}' w l,\
     histogram using 1:3 title '{/Times-Italic u_y}' w l,\
     histogram using 1:4 title '{/Times-Italic u_z}' w l

#Local variables:
#  compile-command: "gnuplot histogram.gp && kill -HUP `pgrep gv`"
#End:
