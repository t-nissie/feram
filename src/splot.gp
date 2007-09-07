#!/usr/bin/env gnuplot
Lx = 16
Ly = 16
Lz_periodic = 16
set terminal postscript portrait enhanced color 22
set output

set xtics 0.5,1.0
set ytics 0.5,1.0
set format x ""
set format y ""
set grid
set nokey

set title 'dayomon'
set xrange [-0.5:Lx-0.5]
set yrange [-0.5:Ly-0.5]
set zrange [-0.5:Lz_periodic-0.5]
splot  '0000000.dat' u ($1-$4/2):($2-$5/2):($3-$6/2):4:5:6 w vec
