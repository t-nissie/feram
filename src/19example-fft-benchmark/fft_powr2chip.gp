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
set key outside Left reverse

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
set output "fft_powr2chip.eps"
set multiplot

set size 0.9,0.34

set label 1 at -3.6,190 '(a)' font "Times-Roman,15"
set title "double-precision complex, 3d transforms, 1 chip\npowers of two, in-place"
set origin 0.0,0.67
plot 'fft_check_powr2.SR16000.r1981.FFTW.chip.dat'             using 0:9  t 'SR16000'   w lp lw 2 lt 1 pt 1,\
     'fft_check_powr2.E5-2680.r1975.FFTW.chip.dat'             using 0:9  t 'E5-2680'   w lp lw 2 lt 2 pt 2,\
     'fft_check_powr2.FX10.r1454.FFTW_MEASURE.dat'             using 0:9  t 'FX10'      w lp lw 2 lt 4 pt 4

set label 1 '(b)'
set title "double-precision real, 3d transforms, 1 chip\npowers of two, in-place"
set origin 0.0,0.34
plot 'fft_check_powr2.SR16000.r1981.FFTW.chip.dat'             using 0:12 t 'SR16000'     w lp lw 2 lt 1 pt 1,\
     'fft_check_powr2.E5-2680.r1975.FFTW.chip.dat'             using 0:12 t 'E5-2680'     w lp lw 2 lt 2 pt 2,\
     'fft_check_powr2.FX10.r1454.FFTW_MEASURE.dat'             using 0:12 t 'FX10'        w lp lw 2 lt 4 pt 4,\
   'cufft_check_powr2.K20X.r2028.dat'                          using 0:7 t  'K20X'        w lp lw 2 lt 7 pt 7,\
   'cufft_check_powr2.M2090.r2030.dat'                         using 0:7 t  'M2090'       w lp lw 2 lt 5 pt 6

set label 1 '(c)'
set title "double-precision real, 3d transforms, 1 chip\npowers of two, out-of-place"
set origin 0.0,0.01
plot 'fft_check_powr2.SR16000.r1981.FFTW.chip.dat'             using 0:15 t 'SR16000'   w lp lw 2 lt 1 pt 1,\
     'fft_check_powr2.E5-2680.r1975.FFTW.chip.dat'             using 0:15 t 'E5-2680'   w lp lw 2 lt 2 pt 2,\
     'fft_check_powr2.FX10.r1454.FFTW_MEASURE.dat'             using 0:15 t 'FX10'      w lp lw 2 lt 4 pt 4

set nomultiplot
set output
!epstopdf.pl fft_powr2chip.eps

#Local variables:
#  compile-command: "gnuplot fft_powr2chip.gp"
#End:
