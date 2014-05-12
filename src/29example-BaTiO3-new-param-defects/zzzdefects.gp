#!/usr/bin/env gnuplot
# zzzdefects.gp
# Time-stamp: <2014-05-12 10:28:12 takeshi>
# Author: Takeshi NISHIMATSU
##
set encoding iso_8859_1
set terminal postscript portrait enhanced color dashed "Times-Roman" 13
#set output "| sed 's/50 50 554 770/50 50 330 460/'> T1.eps
set output "zzzdefects.eps"
set multiplot
set lmargin 10
set ylabel '<{/Times-Italic u_z}> [\305]'
set ytics 0.05
set format y "%.2f"
set grid

set yrange [-0.01:0.16]
set size 1.0, 0.25
set origin 0,0.75
plot 'idel-000-heating.avg' using 1:13     t        'ideal: heating in 0 kV/cm' w l lt 1 lw 3,\
     'idel-000-cooling.avg' using 1:12     t        'ideal: cooling in 0 kV/cm' w l lt 3 lw 3,\
     'idel-100-heating.avg' using 1:13     t                 'ideal: 100 kV/cm' w l lt 2 lw 3,\
     'zero-000-heating.avg' using 1:13     t 'zero defects: heating in 0 kV/cm' w l lt 4 lw 3,\
     'zero-000-cooling.avg' using 1:(-$12) t 'zero defects: cooling in 0 kV/cm' w l lt 5 lw 3,\
     'zero-100-heating.avg' using 1:13     t          'zero defects: 100 kV/cm' w l lt 9 lw 3

set yrange [-0.16:0.16]
set size 1.0, 0.42
set origin 0,0.35
set key bottom
set arrow 1 from 490,-0.065 to 490,0.065 heads lt 6 lw 3
set label 1 at   495,-0.025 "symmetric" textcolor lt 6
set label 2 at   316, 0.085 right "meta-stable\nstate" textcolor lt 4
plot 'para-000-heating.avg' using 1:13 t 'parallel defects:     0 kV/cm'       w l lt 1 lw 3,\
     'para-100-heating.avg' using 1:13 t 'parallel defects: 100 kV/cm'         w l lt 2 lw 3,\
     'anti-000-cooling.avg' using 1:13 t 'anti-parallel defects:     0 kV/cm'  w l lt 6 lw 3,\
     'anti-100-heating.avg' using 1:13 t 'anti-parallel defects: heating in 100 kV/cm' w l lt 8 lw 3,\
     'anti-100-cooling.avg' using 1:13 t 'anti-parallel defects: heating in 100 kV/cm' w l lt 7 lw 3,\
     'anti-070-heating.avg' using 1:13 t 'anti-parallel defects: heating in 70 kV/cm'  w l lt 4 lw 3,\
     'anti-070-cooling.avg' using 1:13 t 'anti-parallel defects: heating in 70 kV/cm'  w l lt 5 lw 3



set yrange [-0.01:0.16]
set size 1.0, 0.27
set origin 0,0.1
set key top
set xlabel '{/Times-Italic T} [K]'
set noarrow 1
set nolabel 1
set nolabel 2
plot  'rnd1-000-heating.avg' using 1:13 t 'random defects: heating in 0 kV/cm'  w l lt 1 lw 3,\
      'rnd1-000-cooling.avg' using 1:13 t 'random defects: cooling in 0 kV/cm'  w l lt 3 lw 3,\
      'rnd1-100-heating.avg' using 1:13 t 'random defects: 100 kV/cm'           w l lt 2 lw 3,\
      'sixd-000-heating.avg' using 1:13 t 'six-d. defects: heating in 0 kV/cm'  w l lt 4 lw 3,\
      'sixd-000-cooling.avg' using 1:11 t 'six-d. defects: cooling in 0 kV/cm'  w l lt 5 lw 3,\
      'sixd-100-heating.avg' using 1:13 t 'six-d. defects: 100 kV/cm'           w l lt 9 lw 3

set nomultiplot
set output
!epstopdf.pl zzzdefects.eps
