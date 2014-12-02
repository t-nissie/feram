#!/usr/bin/env gnuplot
# fft_check.gp
# Author: Takeshi Nishimatsu
# $Date: 2012-07-06 21:27:09 +0900 (金, 06  7 2012) $
# $Rev: 1340 $
# $Author: t-nissie $
##
set terminal postscript portrait enhanced color solid  "Times-Roman,10"

set yrange [0:180]
set ylabel 'GFLOPS'
set bmargin 8
set lmargin 8
set key outside Left reverse

set xrange [-1:27]
set xtics ("30x30x30" 0,\
"48x48x48"	      1,\
"54x54x54"	      2,\
"32x32x243"           3,\
"72x72x72"	      4,\
"75x75x75"	      5,\
"80x80x80"	      6,\
"81x81x81"	      7,\
"96x96x96"	      8,\
"100x100x100"	      9,\
"120x120x120"	     10,\
"240x240x240"	     11,\
"243x243x243"	     12,\
"300x300x300"	     13,\
"320x320x320"	     14,\
"360x360x360"	     15,\
"400x400x400"	     16,\
"405x405x405"	     17,\
"432x432x432"	     18,\
"500x500x500"	     19,\
"600x600x600"	     20,\
"720x720x720"	     21,\
"729x729x729"	     22,\
"800x800x800"	     23,\
"810x810x810"	     24,\
"900x900x900"	     25,\
"1000x1000x1000"     26) rotate

#set size 1.0,1.0   #-----------------------------------------------------------------------------
set output "fft_nonp2.eps"
set multiplot

set size 1.0,0.34

set label 1 at -4.3,190 '(a)' font "Times-Roman,15"
set title "double-precision complex, 3d transforms, 1 node\nnon-powers of two, in-place"
set origin 0.0,0.67
plot 'fft_check_nonp2_stride2.SR16000.r1492.dat'               using 0:9  t 'SR16000'   w lp lw 2 lt 1 pt 1,\
     'fft_check_nonp2.SR16000.r2312.FFTW.node.dat'             using 0:9  t 'SR16000S'  w lp lw 2 lt 9 pt 5,\
     'fft_check_nonp2.X7560.r1507.MKL.dat'                     using 0:9  t 'X7560/MKL' w lp lw 2 lt 5 pt 6,\
     'fft_check_nonp2.X7560.r1507.FFTW_PATIENT.dat'            using 0:9  t 'X7560'     w lp lw 2 lt 7 pt 7,\
     '< grep "  16   " fft_check_nonp2.E5-2680.r1455.FFTW.dat' using 0:9  t 'E5-2680'   w lp lw 2 lt 2 pt 2,\
     'fft_check_nonp2.X5650.r1455.dat'                         using 0:9  t 'X5650'     w lp lw 2 lt 3 pt 3,\
     'fft_check_nonp2.FX10.r1454.FFTW_MEASURE.dat'             using 0:9  t 'FX10'      w lp lw 2 lt 4 pt 4

set label 1 '(b)'
set title "double-precision real, 3d transforms, 1 node\nnon-powers of two, in-place"
set origin 0.0,0.34
plot 'fft_check_nonp2_stride2.SR16000.r1492.dat'               using 0:12 t 'SR16000'   w lp lw 2 lt 1 pt 1,\
     'fft_check_nonp2.SR16000.r2312.FFTW.node.dat'             using 0:12 t 'SR16000S'  w lp lw 2 lt 9 pt 5,\
     'fft_check_nonp2.X7560.r1507.MKL.dat'                     using 0:12 t 'X7560/MKL' w lp lw 2 lt 5 pt 6,\
     'fft_check_nonp2.X7560.r1507.FFTW_PATIENT.dat'            using 0:12 t 'X7560'     w lp lw 2 lt 7 pt 7,\
     '< grep "  16   " fft_check_nonp2.E5-2680.r1455.FFTW.dat' using 0:12 t 'E5-2680'   w lp lw 2 lt 2 pt 2,\
     'fft_check_nonp2.X5650.r1455.dat'                         using 0:12 t 'X5650'     w lp lw 2 lt 3 pt 3,\
     'fft_check_nonp2.FX10.r1454.FFTW_MEASURE.dat'             using 0:12 t 'FX10'      w lp lw 2 lt 4 pt 4

set label 1 '(c)'
set title "double-precision real, 3d transforms, 1 node\nnon-powers of two, out-of-place"
set origin 0.0,0.01
plot 'fft_check_nonp2_stride2.SR16000.r1492.dat'               using 0:15 t 'SR16000'   w lp lw 2 lt 1 pt 1,\
     'fft_check_nonp2.SR16000.r2312.FFTW.node.dat'             using 0:15 t 'SR16000S'  w lp lw 2 lt 9 pt 5,\
     'fft_check_nonp2.X7560.r1507.MKL.dat'                     using 0:15 t 'X7560/MKL' w lp lw 2 lt 5 pt 6,\
     'fft_check_nonp2.X7560.r1507.FFTW_PATIENT.dat'            using 0:15 t 'X7560'     w lp lw 2 lt 7 pt 7,\
     '< grep "  16   " fft_check_nonp2.E5-2680.r1455.FFTW.dat' using 0:15 t 'E5-2680'   w lp lw 2 lt 2 pt 2,\
     'fft_check_nonp2.X5650.r1455.dat'                         using 0:15 t 'X5650'     w lp lw 2 lt 3 pt 3,\
     'fft_check_nonp2.FX10.r1454.FFTW_MEASURE.dat'             using 0:15 t 'FX10'      w lp lw 2 lt 4 pt 4

set nomultiplot
set output
!epstopdf.pl fft_nonp2.eps

#Local variables:
#  compile-command: "gnuplot fft_nonp2.gp"
#End:
