#!/usr/bin/env gnuplot
# defects_maker_check.gp
# Time-stamp: <2014-05-19 13:24:32 takeshi>
# Author: Takeshi NISHIMATSU
##
set encoding iso_8859_1
set terminal postscript portrait enhanced color dashed "Times-Roman" 13
#set output "| sed 's/50 50 554 770/50 50 330 460/'> T1.eps
set output "rndplot.eps"


binwidth=5
bin(x,width)=width*floor(x/width)

plot 'datafile' using (bin($1,binwidth)):(1.0) smooth freq with boxes
