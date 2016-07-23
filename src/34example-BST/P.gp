#!/usr/bin/env gnuplot
# P.gp
# Time-stamp: <2016-07-23 18:30:14 takeshi>
# Author: Takeshi NISHIMATSU
##
set encoding iso_8859_1  # for Angstrom
set terminal postscript eps enhanced color dashed "Times-Roman" 15
set bmargin 3.5

a0      =   3.9435
c=1.6e3/a0**3

set output 'P.eps'
set size 0.5,0.5

set xlabel "(Ba_{/Times-Italic x}Sr_{1-{/Times-Italic x}})TiO_3"
set xrange [0:1]
set xtics 0.1
set format x '%.1f'

set yrange [0:50]
set format y '%.0f'

set ylabel '|{/Times-Italic P}| [{/Symbol m}C cm^{-2}]'
set key left top
set label 1 at 0.63,11 'M\351noret {/Times-Italic et al.}'

#    'PhysRevB.65.224104.BST.Fig6.dat' index 0 t ''                   w lp lt 3 pt  7 lw 2,\
#    ''                                index 1 t ''                   w lp lt 2 pt 13 lw 2,\
#    ''                                index 2 t ''                   w lp lt 1 pt  9 lw 2,\

plot 'P.dat' index 0 using 1:(c*sqrt($36**2+$37**2+$38**2)) t '<111>' w  p lt 3 pt  6 lw 2,\
     'P.dat' index 1 using 1:(c*sqrt($36**2+$37**2+$38**2)) t '<110>' w  p lt 2 pt 12 lw 2,\
     'P.dat' index 2 using 1:(c*sqrt($36**2+$37**2+$38**2)) t '<100>' w  p lt 1 pt  8 lw 2
set output
!epstopdf P.eps
#Local variables:
#  compile-command: "gnuplot P.gp"
#End:
