#!/usr/bin/env gnuplot
##
set terminal postscript portrait enhanced mono 24
set output "forward.eps"

f_SR11000(x) = t1_SR11000 * ((1-p_SR11000)+p_SR11000/x)

t1_SR11000 = 3091.783
p_SR11000  = 0.99   # initial guess
fit f_SR11000(x) 'forward.SR11000.dat' via t1_SR11000,p_SR11000

set xlabel '{/Times-Italic N}_{core}'
set ylabel '{/Times-Italic t} [s]'
set xrange [0:20]
set yrange [0:3500]


plot 'forward.SR11000.dat' t 'SR11000', f_SR11000(x) t '{/Times-Italic t} = {/Times-Italic t}_1((1-{/Times-Italic p})+{/Times-Italic p}/{/Times-Italic N}_{core})'
