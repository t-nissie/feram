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
fit f_FX10(x) 'forward.FX10.r1258.fftw3.3.dat' via t1_FX10,p_FX10

f_SR16k(x) = t1_SR16k * ((1-p_SR16k)+p_SR16k/x)
t1_SR16k = 1800
p_SR16k  = 0.96
fit f_SR16k(x) 'forward.SR16000.r1253.dat' using 1:2 via t1_SR16k,p_SR16k

f_E5_2670(x) = t1_E5_2670 * ((1-p_E5_2670)+p_E5_2670/x)
t1_E5_2670 = 1500
p_E5_2670  = 0.9
fit f_E5_2670(x) 'forward.E5-2670.r1258.dat' using 1:2 via t1_E5_2670,p_E5_2670

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
set yrange [0:2000]
set ytics 250
set ylabel '{/Times-Italic t} [s]'

plot 'forward.FX10.r1258.fftw3.3.dat' t "FX10 (1.85 GHz)\n1 node, 1 CPU\nfftw-3.3"\
                                                                 w p lt 1 pt 7,\
     0.9<x && x<16.1 ? f_FX10(x) : 1/0   t " "                   w l lt 1 lw 3,\
     'forward.SR16000.r1253.dat' t "SR16000 (3.83 GHz)\n1/2 node, 2 CPU, SMT off\n3D FFT in MATRIX/MPP"\
                                                                 w p lt 3 pt 4,\
     0.9<x && x<16.1 ? f_SR16k(x)  : 1/0   t " "                 w l lt 3 lw 3,\
     'forward.E5-2670.r1258.dat' t "Xeon E5-2670 (2.60 GHz)\n1 node, 2 CPU, HT off\nifort-12.1, MKL"\
                                                                 w p lt 2 pt 2,\
     0.9<x && x<16.1 ? f_E5_2670(x) : 1/0  t " "                 w l lt 2 lw 3,\
    'forward.E5-2670.r1258.gcc-4.4.6.fftw-3.3.2.dat' t "gcc-4.4.6, fftw-3.3.2"\
                                                                 w p lt 8 pt 6

set origin 0.0,0.0
set size 0.915,0.6

#set nologscale y
set yrange [0:17]
set ytics (1,2,4,6,8,10,12,14,16)
set xlabel '{/Times-Italic N}_{thread}'
set ylabel 'speed up'
set key left
set nogrid

tp_FX10  = sprintf(      "FX10: %.1f\%", p_FX10 *100)
tp_SR16k = sprintf(   "SR16000: %.1f\%", p_SR16k*100)
tp_E5_2670 = sprintf("Xeon E5-2670: %.1f\%", p_E5_2670*100)

plot      x t 'ideal' w l lt 5 lw 3,\
          'forward.FX10.r1258.fftw3.3.dat'  using ($1):(t1_FX10/$2)     t ''        w p  lt 1 pt 7,\
          0.9<x && x<16.1 ? 1.0 / ((1-p_FX10)+p_FX10/x): 1/0    t tp_FX10   w l  lt 1 lw 3,\
          'forward.SR16000.r1253.dat' using ($1):(t1_SR16k/$2)  t ''        w p  lt 3 pt 4,\
          0.9<x && x<16.1 ? 1.0 / ((1-p_SR16k)+p_SR16k/x) : 1/0 t tp_SR16k  w l  lt 3 lw 3,\
          'forward.E5-2670.r1258.dat' using ($1):(t1_E5_2670/$2)    t ''        w p  lt 2 pt 2,\
          0.9<x && x<16.1 ? 1.0 / ((1-p_E5_2670)+p_E5_2670/x) : 1/0 t tp_E5_2670  w l  lt 2 lw 3


set nomultiplot
set output

!epstopdf.pl zzzHearing.eps

#Local variables:
#  compile-command: "gnuplot zzzHearing.gp"
#End:
