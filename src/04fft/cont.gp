#!/usr/bin/env gnuplot
# 4x4dia.gp
# Time-stamp: <2008-02-25 09:21:47 takeshi>
# Author: Takeshi NISHIMATSU
##
set size 0.75,1.0
set terminal postscript portrait enhanced color dashed "Times-Roman" 20
set output 'cont.eps'
set notitle

#set multiplot

#set view 82,64

# set origin 0,0.43
# set size 1,0.7
# set xlabel "direction1\n[rad]"
# set ylabel "direction2\n[rad]"
# set zlabel "v"
# splot 'square/4x4dia-1.8693735707.xy' notitle w l

set noztics
set nozlabel


set xtics 1
set ytics 1
set format x ''
set format y ''
set grid
set cntrparam levels discrete 10000, 20000, 30000
set contour
set nosurface
set view 0,0,1
set origin 0.0,  0.0
#set nokey
splot [0:16] [0:32] 'feram.in.fft' notitle w l

set nomultiplot
set output
