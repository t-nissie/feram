#!/usr/bin/env gnuplot
# gfortran-vs-ifort.gp: Plot results of forward.feram benchmark.
# Author: Takeshi Nishimatsu
# $Date$
# $Rev$
# $Author$
##
set terminal postscript portrait enhanced color 24
set output "gfortran-vs-ifort.eps"

set tics front

set xrange [0:13]
set xtics (1,2,4,6,8,10,12)
set xlabel '{/Times-Italic N}_{thread}'

set yrange [0:2100]
set ytics 300
set ylabel '{/Times-Italic t} [s]'

plot 'g/data1' t   'gfortran-4.4.6 1' w lp lt 1 pt 1,\
     'g/data2' t                  '2' w lp lt 1 pt 2,\
     'g/data3' t                  '3' w lp lt 1 pt 3,\
     'i/data1' t 'ifort-12.1.0.233 1' w lp lt 2 pt 4,\
     'i/data2' t                  '2' w lp lt 2 pt 6,\
     'i/data3' t                  '3' w lp lt 2 pt 8

set output
!epstopdf.pl gfortran-vs-ifort.eps
     
#Local variables:
#  compile-command: "gnuplot gfortran-vs-ifort.gp"
#End:
