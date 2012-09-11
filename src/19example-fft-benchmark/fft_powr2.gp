#!/usr/bin/env gnuplot
# fft_check.gp
# Author: Takeshi Nishimatsu
# $Date: 2012-07-06 21:27:09 +0900 (金, 06  7 2012) $
# $Rev: 1340 $
# $Author: t-nissie $
##
set terminal postscript portrait enhanced color solid  "Times-Roman,10"

set yrange [0:160]
set ylabel 'GFLOPS'
set bmargin 8
set lmargin 8
set key left

set xrange [-1:16]
set xtics ("32x32x32" 0,\
"64x64x64"            1,\
"256x64x32"           2,\
"16x1024x64"          3,\
"128x128x128"         4,\
"256x256x256"         5,\
"128x256x1024"        6,\
"256x256x512"         7,\
"256x512x512"         8,\
"512x256x512"         9,\
"512x512x512"        10,\
"256x512x1024"       11,\
"1024x512x256"       12,\
"512x512x1024"       13,\
"512x1024x1024"      14,\
"1024x1024x1024"     15) rotate

#set size 1.0,1.0   #-----------------------------------------------------------------------------
set output "fft_powr2.eps"
set multiplot

set size 0.6,0.34

set label 1 at -4.1,190 '(a)' font "Times-Roman,15"
set title "double-precision complex, 3d transforms, 1 node\nnon-powers of two, in-place"
set origin 0.0,0.67
plot 'fft_check_powr2_stride2.SR16000.r1492.dat'               using 0:9  t 'SR16000'  w lp lw 2,\
     '< grep "  16   " fft_check_powr2.E5-2680.r1455.FFTW.dat' using 0:9  t 'E5-2680'  w lp lw 2,\
     'fft_check_powr2.X5650.r1455.dat'                         using 0:9  t 'X5650'    w lp lw 2

set label 1 '(b)'
set title "double-precision real, 3d transforms, 1 node\nnon-powers of two, in-place"
set origin 0.0,0.34
plot 'fft_check_powr2_stride2.SR16000.r1492.dat'               using 0:12 t 'SR16000'  w lp lw 2,\
     '< grep "  16   " fft_check_powr2.E5-2680.r1455.FFTW.dat' using 0:12 t 'E5-2680'  w lp lw 2,\
     'fft_check_powr2.X5650.r1455.dat'                         using 0:12 t 'X5650'    w lp lw 2

set label 1 '(c)'
set title "double-precision real, 3d transforms, 1 node\nnon-powers of two, out-of-place"
set origin 0.0,0.01
plot 'fft_check_powr2_stride2.SR16000.r1492.dat'               using 0:15 t 'SR16000'  w lp lw 2,\
     '< grep "  16   " fft_check_powr2.E5-2680.r1455.FFTW.dat' using 0:15 t 'E5-2680'  w lp lw 2,\
     'fft_check_powr2.X5650.r1455.dat'                         using 0:15 t 'X5650'    w lp lw 2

set nomultiplot
set output
!epstopdf.pl fft_powr2.eps

#Local variables:
#  compile-command: "gnuplot fft_powr2.gp"
#End:
