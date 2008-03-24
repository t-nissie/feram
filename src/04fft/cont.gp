#!/usr/bin/env gnuplot
# 4x4dia.gp
# Time-stamp: <2008-03-24 18:35:37 takeshi>
# Author: Takeshi NISHIMATSU
##
L=40

set size 0.75,1.0
set terminal postscript portrait enhanced color dashed "Times-Roman" 20
set output 'cont.eps'
set notitle

set noztics
set nozlabel


set xtics 1
set ytics 1
set format x ''
set format y ''
set grid
#set cntrparam levels discrete 10000, 20000, 30000
set contour
set nosurface
set view 0,0,1
set origin 0.0,  0.0
set arrow 1 from -3,20,0 to 24,20,0
set arrow 2 from 0,-4,0 to 0,44,0
#set nokey
splot [0:20] [0:40] 'epit-40x40-L007-D1-5.0GPa-100K.0001000.fft' notitle w l

set nomultiplot
set output
