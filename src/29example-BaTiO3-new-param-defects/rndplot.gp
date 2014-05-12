#!/usr/bin/env gnuplot
# rndplot.gp
# Time-stamp: <2014-05-12 10:25:12 takeshi>
# Author: Takeshi NISHIMATSU
##
set encoding iso_8859_1
set terminal postscript portrait enhanced color dashed "Times-Roman" 13
#set output "| sed 's/50 50 554 770/50 50 330 460/'> T1.eps
set output "rndplot.eps"
set multiplot
set lmargin 10
set ylabel '<{/Times-Italic u_z}> [\305]'
set ytics 0.05
set format y "%.2f"
set grid

set yrange [-0.15:0.15]
set xrange [250:500]
set size 1.0, 0.262

set origin 0,0.75
plot 'rnd1-000-heating.avg' using 1:11     t        '{/Times-Italic P_x}, 1%, heating, 0 kV/cm' w l lt 1 lw 2,\
     'rnd1-000-heating.avg' using 1:12     t        '{/Times-Italic P_y}, 1%, heating, 0 kV/cm' w l lt 4 lw 2,\
     'rnd1-000-heating.avg' using 1:13     t        '{/Times-Italic P_z}, 1%, heating, 0 kV/cm' w l lt 8 lw 2,\
     'rnd1-000-cooling.avg' using 1:11     t        '{/Times-Italic P_x}, 1%, cooling, 0 kV/cm' w l lt 3 lw 2,\
     'rnd1-000-cooling.avg' using 1:12     t        '{/Times-Italic P_y}, 1%, cooling, 0 kV/cm' w l lt 5 lw 2,\
     'rnd1-000-cooling.avg' using 1:13     t        '{/Times-Italic P_z}, 1%, cooling, 0 kV/cm' w l lt 9 lw 2

set origin 0,0.5
plot 'rnd2-000-heating.avg' using 1:11     t        '{/Times-Italic P_x}, 2%, heating, 0 kV/cm' w l lt 1 lw 2,\
     'rnd2-000-heating.avg' using 1:12     t        '{/Times-Italic P_y}, 2%, heating, 0 kV/cm' w l lt 4 lw 2,\
     'rnd2-000-heating.avg' using 1:13     t        '{/Times-Italic P_z}, 2%, heating, 0 kV/cm' w l lt 8 lw 2,\
     'rnd2-000-cooling.avg' using 1:11     t        '{/Times-Italic P_x}, 2%, cooling, 0 kV/cm' w l lt 3 lw 2,\
     'rnd2-000-cooling.avg' using 1:12     t        '{/Times-Italic P_y}, 2%, cooling, 0 kV/cm' w l lt 5 lw 2,\
     'rnd2-000-cooling.avg' using 1:13     t        '{/Times-Italic P_z}, 2%, cooling, 0 kV/cm' w l lt 9 lw 2

set origin 0,0.25
plot 'rnd3-000-heating.avg' using 1:11     t        '{/Times-Italic P_x}, 3%, heating, 0 kV/cm' w l lt 1 lw 2,\
     'rnd3-000-heating.avg' using 1:12     t        '{/Times-Italic P_y}, 3%, heating, 0 kV/cm' w l lt 4 lw 2,\
     'rnd3-000-heating.avg' using 1:13     t        '{/Times-Italic P_z}, 3%, heating, 0 kV/cm' w l lt 8 lw 2,\
     'rnd3-000-cooling.avg' using 1:11     t        '{/Times-Italic P_x}, 3%, cooling, 0 kV/cm' w l lt 3 lw 2,\
     'rnd3-000-cooling.avg' using 1:12     t        '{/Times-Italic P_y}, 3%, cooling, 0 kV/cm' w l lt 5 lw 2,\
     'rnd3-000-cooling.avg' using 1:13     t        '{/Times-Italic P_z}, 3%, cooling, 0 kV/cm' w l lt 9 lw 2

set origin 0,0.0
plot 'rnd4-000-heating.avg' using 1:11     t        '{/Times-Italic P_x}, 4%, heating, 0 kV/cm' w l lt 1 lw 2,\
     'rnd4-000-heating.avg' using 1:12     t        '{/Times-Italic P_y}, 4%, heating, 0 kV/cm' w l lt 4 lw 2,\
     'rnd4-000-heating.avg' using 1:13     t        '{/Times-Italic P_z}, 4%, heating, 0 kV/cm' w l lt 8 lw 2,\
     'rnd4-000-cooling.avg' using 1:11     t        '{/Times-Italic P_x}, 4%, cooling, 0 kV/cm' w l lt 3 lw 2,\
     'rnd4-000-cooling.avg' using 1:12     t        '{/Times-Italic P_y}, 4%, cooling, 0 kV/cm' w l lt 5 lw 2,\
     'rnd4-000-cooling.avg' using 1:13     t        '{/Times-Italic P_z}, 4%, cooling, 0 kV/cm' w l lt 9 lw 2


set nomultiplot
set output
!epstopdf.pl rndplot.eps
