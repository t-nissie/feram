#!/usr/bin/env gnuplot
# zzzHearing.gp
# Author: Takeshi Nishimatsu
# $Date: 2012-05-07 11:15:33 +0900 (月, 07  5 2012) $
# $Rev: 1242 $
# $Author: t-nissie $
##
set terminal postscript portrait enhanced color solid  "Times-Roman,15"
set output "zzzHearing.eps"
set multiplot

f_FX10(x) = t1_FX10 * ((1-p_FX10)+p_FX10/x)
t1_FX10 = 3000.0
p_FX10  = 0.8   # initial guess
fit f_FX10(x) 'forward.FX10.r1243.dat' via t1_FX10,p_FX10

f_min(x) = t1_min * ((1-p_min)+p_min/x)
t1_min = 1800
p_min  = 0.96
fit f_min(x) 'timingSC20.min' using 1:2 via t1_min,p_min

f_X5690(x) = t1_X5690 * ((1-p_X5690)+p_X5690/x)
t1_X5690 = 1500
p_X5690  = 0.9
fit f_X5690(x) 'forward.X5690.r1224.dat' using 1:2 via t1_X5690,p_X5690

set lmargin  9
#set rmargin 15
set tics front
set key spacing 1.7
set grid
set samples 400

set xrange [0:17]
set xtics (1,2,4,6,8,10,12,14,16)

set origin 0.0,0.575
set size 0.915,0.43

#set logscale y
#set yrange [100:10000]
set yrange [0:2250]
set ytics 250
set ylabel '{/Times-Italic t} [s]'

plot 'forward.FX10.r1243.dat' t "FX10 (1.85 GHz)\n1 node, 1 CPU\nFFT in SSL2"\
                                                                 w p lt 1 pt 7,\
     0.9<x && x<16.1 ? f_FX10(x) : 1/0   t " "                   w l lt 1 lw 3,\
     'timingSC20.dat' t "SR16000 (3.83 GHz)\n1/4 node, 1 CPU, SMT on\nFFT in MATRIX/MPP"\
                                                                 w p lt 3 pt 4,\
     0.9<x && x<8.1  ? f_min(x)   : 1/0  t " "                   w l lt 3 lw 3,\
     'forward.X5690.r1224.dat' t "Xeon X5690 (3.47 GHz)\n1 node, 2 CPU, HT off\ngfortran-4.4, fftw-3.3"\
                                                                 w p lt 2 pt 2,\
     0.9<x && x<12.1 ? f_X5690(x) : 1/0  t " "                   w l lt 2 lw 3

set origin 0.0,0.0
set size 0.915,0.6

#set nologscale y
set yrange [0:17]
set ytics (1,2,4,6,8,10,12,14,16)
set xlabel '{/Times-Italic N}_{thread}'
set ylabel 'speed up'
set key left
set nogrid

tp_FX10  = sprintf(         "FX10: %.1f\%", p_FX10 *100)
tp_min   = sprintf("SR16000^{min}: %.1f\%", p_min  *100)
tp_X5690 = sprintf(   "Xeon X5690: %.1f\%", p_X5690*100)

plot      x t 'ideal' w l lt 5 lw 3,\
          'forward.FX10.r1243.dat'  using ($1):(t1_FX10/$2)     t ''        w p  lt 1 pt 7,\
          1.0 / ((1-p_FX10)+p_FX10/x)                           t tp_FX10   w l  lt 1 lw 3,\
          'timingSC20.min'          using ($1):(t1_min/$2)      t ''        w p  lt 3 pt 4,\
          0.9<x && x<8.1  ? 1.0 / ((1-p_min)+p_min/x) : 1/0     t tp_min    w l  lt 3 lw 3,\
          'forward.X5690.r1224.dat' using ($1):(t1_X5690/$2)    t ''        w p  lt 2 pt 2,\
          0.9<x && x<12.1 ? 1.0 / ((1-p_X5690)+p_X5690/x) : 1/0 t tp_X5690  w l  lt 2 lw 3


set nomultiplot
set output

!epstopdf.pl zzzHearing.eps

#Local variables:
#  compile-command: "gnuplot zzzHearing.gp"
#End:
