#!/usr/bin/env gnuplot
##
set terminal postscript portrait enhanced color 24
set output "forward.eps"
set multiplot

f_SR11000(x) = t1_SR11000 * ((1-p_SR11000)+p_SR11000/x)

t1_SR11000 = 3091.783
p_SR11000  = 0.99   # initial guess
fit f_SR11000(x) 'forward.SR11000.dat' via t1_SR11000,p_SR11000

set xrange [0:16]
set xtics 4
set lmargin 9

set origin 0.0,0.6
set size 1.0,0.4
set yrange [0:3500]
set ylabel '{/Times-Italic t} [s]'
plot 'forward.SR11000.dat' t 'SR11000',\
     f_SR11000(x) t '{/Times-Italic t} = {/Times-Italic t}_1((1-{/Times-Italic p})+{/Times-Italic p}/{/Times-Italic N}_{core})' w l lt 1

set origin 0.0,0.0
#set size square
set size 1.0,0.64
set yrange [0:16]
set xlabel '{/Times-Italic N}_{core}'
set ylabel 'speed up'
set key left
plot 'forward.SR11000.dat' using ($1):(t1_SR11000/$2) t 'SR11000' w lp,\
     x t 'ideal'
