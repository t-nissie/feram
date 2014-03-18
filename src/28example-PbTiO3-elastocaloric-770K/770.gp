#!/usr/bin/env gnuplot
# 770.gp
# Time-stamp: <2014-03-18 18:06:38 t-nissie>
# Author: Takeshi NISHIMATSU
##
set terminal postscript portrait enhanced color dashed "Times-Roman" 20
set output '770.eps'
set key top right

set format y '%.3f'
set ylabel 'kinetic energy [eV/u.c.]'
set yrange [0.086:0.1]
#set ytics 0.005

set xlabel '{/Symbol \264}10^6 MD step'
set xrange  [0:6000000]
set xtics ("1" 1000000,\
           "2" 2000000,\
           "3" 3000000,\
           "4" 4000000,\
           "5" 5000000,\
           "6" 6000000)

# Add "-m 100000" option for grep to see the details of velocity scaling (vs) simulation.

set title "`echo $PWD`" font "Times-Roman, 12"
plot '< grep acou_kinetic 770.vs.log 770.lf.log' using 0:3 t 'acoustic' w l,\
     '< grep dipo_kinetic 770.vs.log 770.lf.log' using 0:3 t 'dipole'   w l

set output
!epstopdf.pl '770.eps'
