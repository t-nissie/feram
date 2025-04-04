#!/usr/bin/env gnuplot
# forward.gp: Plot results of forward.feram benchmark.
# Author: Takeshi Nishimatsu
# $Date: 2012-04-20 14:26:51 +0900 (金, 20  4 2012) $
# $Rev: 1201 $
# $Author: t-nissie $
##
set terminal postscript portrait enhanced color 24
set output "SR16000.eps"
set multiplot

f_SR11000(x) = t1_SR11000 * ((1-p_SR11000)+p_SR11000/x)
t1_SR11000 = 2091.783
p_SR11000  = 0.99   # initial guess
fit f_SR11000(x) 'forward.SR11000.r1111.dat' using 1:($4*60+$5) via t1_SR11000,p_SR11000

f_SR16000(x) = t1_SR16000 * ((1-p_SR16000)+p_SR16000/x)
t1_SR16000 = 2091.783
p_SR16000  = 0.99   # initial guess
fit f_SR16000(x) 'forward.SR16000.r1111.dat' using 1:($3*60+$4) via t1_SR16000,p_SR16000

f_X5650(x) = t1_X5650 * ((1-p_X5650)+p_X5650/x)
t1_X5650 = 1577.33
p_X5650  = 0.8   # initial guess
fit f_X5650(x) 'forward.X5650.r1200.dat' via t1_X5650,p_X5650

f_FX10(x) = t1_FX10 * ((1-p_FX10)+p_FX10/x)
t1_FX10 = 4000.0
p_FX10  = 0.8   # initial guess
fit f_FX10(x) 'forward.FX10.r1172.dat' via t1_FX10,p_FX10

set xrange [0:64]
set xtics 8
set lmargin 9

set origin 0.0,0.6
set size 1.0,0.4
set yrange [0:4500]
set ylabel '{/Times-Italic t} [s]'
plot 'forward.SR11000.r1111.dat' using 1:($4*60+$5) t 'SR11000'    w p lt 1 lw 2 ps 1,\
     f_SR11000(x)                                   t ''           w l lt 1 lw 1,\
     'forward.X5650.r1200.dat'                      t 'Xeon X5650' w p lt 2 lw 2 ps 1,\
     f_X5650(x)                                     t ''           w l lt 2 lw 1,\
     'forward.FX10.r1172.dat'                       t 'FX10'       w p lt 3 lw 2 ps 1,\
     f_FX10(x)                                      t ''           w l lt 3 lw 1,\
     'forward.SR16000.r1111.dat' using 1:($3*60+$4) t 'SR16000'    w p lt 4 lw 2 ps 1

set origin 0.0,0.0
#set size square
set size 1.0,0.64
set yrange [0:64]
set xlabel '{/Times-Italic N}_{core}'
set ylabel 'speed up'
set key left
tp_X5650=sprintf("{/Times-Italic p} = %.3f", p_X5650)
tp_FX10 =sprintf("{/Times-Italic p} = %.3f", p_FX10)
plot      x t 'ideal' w l lt 5 lw 2,\
          'forward.SR11000.r1111.dat' using ($1):(t1_SR11000/($4*60+$5))  t 'SR11000'    w lp lt 1 lw 2 ps 1,\
          'forward.X5650.r1200.dat'   using ($1):(t1_X5650/$2)            t 'Xeon X5650' w p  lt 2 lw 2 ps 1,\
          1.0 / ((1-p_X5650)+p_X5650/x)                                   t tp_X5650     w l  lt 2 lw 1,\
          'forward.FX10.r1172.dat'    using ($1):(t1_FX10/$2)             t 'FX10'       w p  lt 3 lw 2 ps 1,\
          1.0 / ((1-p_FX10)+p_FX10/x)                                     t tp_FX10      w l  lt 3 lw 1,\
          'forward.SR16000.r1111.dat' using ($1):(t1_SR16000/($3*60+$4))  t 'SR16000'    w lp lt 4 lw 2 ps 1

set nomultiplot
set output
!epstopdf.pl SR16000.eps

#Local variables:
#  compile-command: "gnuplot forward.gp"
#End:
