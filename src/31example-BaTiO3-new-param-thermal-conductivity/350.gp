#!/usr/bin/env gnuplot
# Time-stamp: <2015-06-29 20:49:27 takeshi>
# Author: Takeshi NISHIMATSU
##
set terminal postscript portrait enhanced color dashed "Times-Roman" 20
set output '350.eps'
set size 1.0,0.5
#set grid
set xrange [0:480]
set yrange [330:370]
set xtics 120
#set key spacing 1.2
set ylabel '{/Times-Italic T} [K]'
set xlabel '{/Times-Italic z} [unit cell]'
#set title "{/Times-Italic P_z}:  {/Symbol D}{/Times-Italic e}_{dipole}=0.00002,  {/Symbol D}{/Times-Italic e}_{acoustic}=0.00000\n(directory: `basename $PWD`)" font "Times-Roman,16"
plot '350.2lf.T_layer' u 1:2 t '{/Times-Italic MD-acoustic}: {/Times-Italic u}' w l lw 2, '350.2lf.T_layer' u 1:3 t '{/Times-Italic MD-acoustic}: {/Times-Italic w}' w l lt 7 lw 4,\
     '../BTOtc-33-05K-0.00004-Py-48x48x480-200-600-average400k-wout-SC/350.2lf.T_layer' t '{/Times-Italic optimized-acoustic}: {/Times-Italic u}' w l lc 8
set output
!epstopdf.pl '350.eps'
