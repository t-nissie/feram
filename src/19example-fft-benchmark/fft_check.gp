#!/usr/bin/env gnuplot
# fft_check.gp
# Author: Takeshi Nishimatsu
# $Date$
# $Rev$
# $Author$
##
set terminal postscript portrait enhanced color solid  "Times-Roman,15"
set output "fft_check.eps"
set multiplot

set xrange [0:21]
set yrange [0:100]

set bmargin 8

set ylabel 'GFLOPS'

set xtics ("4x4x4" 1,\
"8x8x8"            2,\
"4x8x16"  	   3,\
"16x16x16" 	   4,\
"32x32x32" 	   5,\
"64x64x64" 	   6,\
"256x64x32" 	   7,\
"16x1024x64" 	   8,\
"128x128x128" 	   9,\
"256x256x256" 	  10,\
"128x256x1024" 	  11,\
"256x256x512" 	  12,\
"256x512x512" 	  13,\
"512x256x512" 	  14,\
"512x512x512" 	  15,\
"256x512x1024" 	  16,\
"1024x512x256" 	  17,\
"512x512x1024" 	  18,\
"512x1024x1024"   19,\
"1024x1024x1024"  20) rotate


set title "double-precision complex, 3d transforms"
set origin 0.0,0.5
set size 1.0,0.52
plot 'fft_check.FX10.r1292.thread16.dat'         using 1:11  t            'FX10 FFTW 16t' w lp lt 1 lw 2 pt 7,\
     'fft_check.E5-2670.r1292.thread16.MKL.dat'  using 1:11  t          'E5-2670 MKL 16t' w lp lt 2 lw 2 pt 2,\
     'fft_check.E5-2670.r1292.thread16.FFTW.dat' using 1:11  t         'E5-2670 FFTW 16t' w lp lt 2 lw 2 pt 6,\
     'fft_check.SR16000.r1292.thread32.dat'      using 1:11  t   'SR16000 MATRIX/MPP 32t' w lp lt 3 lw 2 pt 4

set title "double-precision real-data, 3d transforms"
set origin 0.0,0.0
set size 1.0,0.52
plot 'fft_check.FX10.r1292.thread16.dat'         using 1:12  t            'FX10 FFTW 16t' w lp lt 1 lw 2 pt 7,\
     'fft_check.E5-2670.r1292.thread16.MKL.dat'  using 1:12  t          'E5-2670 MKL 16t' w lp lt 2 lw 2 pt 2,\
     'fft_check.E5-2670.r1292.thread16.FFTW.dat' using 1:12  t         'E5-2670 FFTW 16t' w lp lt 2 lw 2 pt 6,\
     'fft_check.SR16000.r1292.thread32.dat'      using 1:12  t   'SR16000 MATRIX/MPP 32t' w lp lt 3 lw 2 pt 4

!epstopdf.pl fft_check.eps

#Local variables:
#  compile-command: "gnuplot fft_check.gp"
#End:
