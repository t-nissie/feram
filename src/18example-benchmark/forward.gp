#!/usr/bin/env gnuplot
# forward.gp: Plot results of forward.feram benchmark.
# Author: Takeshi Nishimatsu
# $Date$
# $Rev$
# $Author$
##
set terminal postscript portrait enhanced color 24
set output "forward.eps"
set multiplot

f_SR11000(x) = t1_SR11000 * ((1-p_SR11000)+p_SR11000/x)
t1_SR11000 = 2091.783
p_SR11000  = 0.99   # initial guess
fit f_SR11000(x) 'forward.SR11000.r1111.dat' using 1:($4*60+$5) via t1_SR11000,p_SR11000

f_X5690(x) = t1_X5690 * ((1-p_X5690)+p_X5690/x)
t1_X5690 = 1577.33
p_X5690  = 0.8   # initial guess
fit f_X5690(x) 'forward.X5690.r1111.dat' via t1_X5690,p_X5690

set xrange [0:16]
set xtics 4
set lmargin 9

set origin 0.0,0.6
set size 1.0,0.4
set yrange [0:3000]
set ylabel '{/Times-Italic t} [s]'
plot 'forward.SR11000.r1111.dat' using 1:($4*60+$5) t 'SR11000'    w p lt 1,\
     f_SR11000(x)          t ''           w l lt 1,\
     'forward.X5690.r1111.dat'   t 'Xeon X5690' w p lt 2,\
     f_X5690(x)            t ''           w l lt 2

set origin 0.0,0.0
#set size square
set size 1.0,0.64
set yrange [0:16]
set xlabel '{/Times-Italic N}_{core}'
set ylabel 'speed up'
set key left
tp=sprintf("{/Times-Italic p} = %.3f", p_X5690)
plot      x t 'ideal' w l lt 5,\
          'forward.SR11000.r1111.dat' using ($1):(t1_SR11000/($4*60+$5))  t 'SR11000' w lp lt 1,\
          'forward.X5690.r1111.dat'   using ($1):(t1_X5690/$2) t 'Xeon X5690' w lp lt 2,\
          1.0 / ((1-p_X5690)+p_X5690/x)                 t tp w l  lt 3

set nomultiplot
set output
!epstopdf.pl forward.eps
