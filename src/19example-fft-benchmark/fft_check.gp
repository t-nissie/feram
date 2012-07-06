#!/usr/bin/env gnuplot
# fft_check.gp
# Author: Takeshi Nishimatsu
# $Date$
# $Rev$
# $Author$
##
set terminal postscript portrait enhanced color solid  "Times-Roman,15"

set yrange [0:100]
set ylabel 'GFLOPS'
set bmargin 8
set lmargin 8

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

set size 1.0,1.0   #-----------------------------------------------------------------------------
set output "fft_check_powr2.1node.eps"
set multiplot
set size 1.0,0.52

set title "double-precision complex, 3d transforms, 1 node\npowers of two, in-place"
set origin 0.0,0.5
plot '< grep "  32      0" fft_check_powr2_stride2.SR16000.r1307.dat'\
                                                  using 0:10  t   'SR16000 MATRIX/MPP SMT=off' w lp lt 3 lw 2 pt 4,\
     '< grep "  64      0" fft_check_powr2_stride1.SR16000.r1307.dat'\
                                                  using 0:10  t   'SR16000 MATRIX/MPP SMT=on ' w lp lt 3 lw 2 pt 5,\
     'fft_check_powr2.FX10.r1292.FFTW.dat'        using 0:10  t                    'FX10 FFTW' w lp lt 1 lw 2 pt 7,\
     'fft_check_powr2.FX10.r1292.SSL2.dat'        using 0:10  t                    'FX10 SSL2' w lp lt 1 lw 2 pt 1,\
     'fft_check_powr2.E5-2670.r1292.FFTW.dat'     using 0:10  t          'E5-2670 FFTW HT=off' w lp lt 2 lw 2 pt 6,\
     'fft_check_powr2.E5-2670.r1292.MKL.dat'      using 0:10  t         'E5-2670 MKL   HT=off' w lp lt 2 lw 2 pt 2

set title "double-precision real-data, 3d transforms, 1 node\npowers of two, out-of-place or copy before/after transform"
set origin 0.0,0.0
plot '< grep "  32      0" fft_check_powr2_stride2.SR16000.r1307.dat'\
                                                  using 0:11  t   'SR16000 MATRIX/MPP SMT=off' w lp lt 3 lw 2 pt 4,\
     '< grep "  64      0" fft_check_powr2_stride1.SR16000.r1307.dat'\
                                                  using 0:11  t   'SR16000 MATRIX/MPP SMT=on ' w lp lt 3 lw 2 pt 5,\
     'fft_check_powr2.FX10.r1292.FFTW.dat'        using 0:11  t                    'FX10 FFTW' w lp lt 1 lw 2 pt 7,\
     'fft_check_powr2.FX10.r1292.SSL2.dat'        using 0:11  t                    'FX10 SSL2' w lp lt 1 lw 2 pt 1,\
     'fft_check_powr2.E5-2670.r1292.FFTW.dat'     using 0:11  t          'E5-2670 FFTW HT=off' w lp lt 2 lw 2 pt 6,\
     'fft_check_powr2.E5-2670.r1292.MKL.dat'      using 0:11  t         'E5-2670 MKL   HT=off' w lp lt 2 lw 2 pt 2

set nomultiplot
set output
!epstopdf.pl fft_check_powr2.1node.eps

set size 1.0,1.0   #-----------------------------------------------------------------------------
set output "fft_check_powr2.1CPU.eps"
set multiplot

set size 1.0,0.52

set xrange [-1:16]

set title "double-precision complex, 3d transforms, 1 CPU\npowers of two, in-place"
set origin 0.0,0.5
plot '< grep "   8      0" fft_check_powr2_stride2.SR16000.r1307.dat'\
                                                  using 0:10  t   'SR16000 MATRIX/MPP SMT=off' w lp lt 3 lw 2 pt 4,\
     '< grep "  16      0" fft_check_powr2_stride1.SR16000.r1307.dat'\
                                                  using 0:10  t   'SR16000 MATRIX/MPP SMT=on ' w lp lt 3 lw 2 pt 5,\
     'fft_check_powr2.FX10.r1292.FFTW.dat'        using 0:10  t                    'FX10 FFTW' w lp lt 1 lw 2 pt 7,\
     'fft_check_powr2.FX10.r1292.SSL2.dat'        using 0:10  t                    'FX10 SSL2' w lp lt 1 lw 2 pt 1

set title "double-precision real-data, 3d transforms, 1 CPU\npowers of two, out-of-place or copy before/after transform"
set origin 0.0,0.0
plot '< grep "   8      0" fft_check_powr2_stride2.SR16000.r1307.dat'\
                                                  using 0:11  t   'SR16000 MATRIX/MPP SMT=off' w lp lt 3 lw 2 pt 4,\
     '< grep "  16      0" fft_check_powr2_stride1.SR16000.r1307.dat'\
                                                  using 0:11  t   'SR16000 MATRIX/MPP SMT=on ' w lp lt 3 lw 2 pt 5,\
     'fft_check_powr2.FX10.r1292.FFTW.dat'        using 0:11  t                    'FX10 FFTW' w lp lt 1 lw 2 pt 7,\
     'fft_check_powr2.FX10.r1292.SSL2.dat'        using 0:11  t                    'FX10 SSL2' w lp lt 1 lw 2 pt 1

set nomultiplot
set output
!epstopdf.pl fft_check_powr2.1CPU.eps

#======================================================================================================
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

set size 1.0,1.0   #-----------------------------------------------------------------------------
set output "fft_check_nonp2.1node.eps"
set multiplot

set size 1.0,0.52

set title "double-precision complex, 3d transforms, 1 node\nnon-powers of two, in-place"
set origin 0.0,0.5
plot '< grep "  32      0" fft_check_nonp2_stride2.SR16000.r1307.dat'\
                                                  using 0:10  t   'SR16000 MATRIX/MPP SMT=off' w lp lt 3 lw 2 pt 4,\
     '< grep "  64      0" fft_check_nonp2_stride1.SR16000.r1307.dat'\
                                                  using 0:10  t   'SR16000 MATRIX/MPP SMT=on ' w lp lt 3 lw 2 pt 5,\
     '< grep "  12      0" fft_check_nonp2.X5650.r1307.dat'\
                                                  using 0:10  t             'X5650 MKL HT=off' w lp lt 4 lw 2 pt 2

set title "double-precision real-data, 3d transforms, 1 node\nnon-powers of two, out-of-place or copy before/after transform"
set origin 0.0,0.0
plot '< grep "  32      0" fft_check_nonp2_stride2.SR16000.r1307.dat'\
                                                  using 0:11  t   'SR16000 MATRIX/MPP SMT=off' w lp lt 3 lw 2 pt 4,\
     '< grep "  64      0" fft_check_nonp2_stride1.SR16000.r1307.dat'\
                                                  using 0:11  t   'SR16000 MATRIX/MPP SMT=on ' w lp lt 3 lw 2 pt 5,\
     '< grep "  12      0" fft_check_nonp2.X5650.r1307.dat'\
                                                  using 0:11  t             'X5650 MKL HT=off' w lp lt 4 lw 2 pt 2

set nomultiplot
set output
!epstopdf.pl fft_check_nonp2.1node.eps

set size 1.0,1.0   #-----------------------------------------------------------------------------
set output "fft_check_nonp2.1CPU.eps"
set multiplot

set size 1.0,0.52

set title "double-precision complex, 3d transforms, 1 CPU\nnon-powers of two, in-place"
set origin 0.0,0.5
plot '< grep "   8      0" fft_check_nonp2_stride2.SR16000.r1307.dat'\
                                                  using 0:10  t   'SR16000 MATRIX/MPP SMT=off' w lp lt 3 lw 2 pt 4,\
     '< grep "  16      0" fft_check_nonp2_stride1.SR16000.r1307.dat'\
                                                  using 0:10  t   'SR16000 MATRIX/MPP SMT=on ' w lp lt 3 lw 2 pt 5,\
     '< grep "   6      0" fft_check_nonp2.X5650.r1307.dat'\
                                                  using 0:10  t             'X5650 MKL HT=off' w lp lt 4 lw 2 pt 2

set title "double-precision real-data, 3d transforms, 1 CPU\nnon-powers of two, out-of-place or copy before/after transform"
set origin 0.0,0.0
plot '< grep "   8      0" fft_check_nonp2_stride2.SR16000.r1307.dat'\
                                                  using 0:11  t   'SR16000 MATRIX/MPP SMT=off' w lp lt 3 lw 2 pt 4,\
     '< grep "  16      0" fft_check_nonp2_stride1.SR16000.r1307.dat'\
                                                  using 0:11  t   'SR16000 MATRIX/MPP SMT=on ' w lp lt 3 lw 2 pt 5,\
     '< grep "   6      0" fft_check_nonp2.X5650.r1307.dat'\
                                                  using 0:11  t             'X5650 MKL HT=off' w lp lt 4 lw 2 pt 2

set nomultiplot
set output
!epstopdf.pl fft_check_nonp2.1CPU.eps

#Local variables:
#  compile-command: "gnuplot fft_check.gp"
#End:
