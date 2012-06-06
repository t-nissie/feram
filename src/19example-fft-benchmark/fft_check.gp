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

set title "double-precision complex, 3d transforms, 1 node, powers of two\nin-place"
set origin 0.0,0.5
plot '< grep "  32      0" fft_check_powr2_stride2.SR16000.r1307.dat'\
                                                  using 0:10  t   'SR16000 MATRIX/MPP SMT=off' w lp lt 3 lw 2 pt 4,\
     '< grep "  64      0" fft_check_powr2_stride1.SR16000.r1307.dat'\
                                                  using 0:10  t   'SR16000 MATRIX/MPP SMT=on ' w lp lt 3 lw 2 pt 5,\
     'fft_check_powr2.FX10.r1292.FFTW.dat'        using 0:10  t                    'FX10 FFTW' w lp lt 1 lw 2 pt 7,\
     'fft_check_powr2.FX10.r1292.SSL2.dat'        using 0:10  t                    'FX10 SSL2' w lp lt 1 lw 2 pt 1,\
     'fft_check_powr2.E5-2670.r1292.FFTW.dat'     using 0:10  t          'E5-2670 FFTW HT=off' w lp lt 2 lw 2 pt 6,\
     'fft_check_powr2.E5-2670.r1292.MKL.dat'      using 0:10  t         'E5-2670 MKL   HT=off' w lp lt 2 lw 2 pt 2

set title "double-precision real-data, 3d transforms, 1 node, powers of two\nout-of-place or copy before/after transform"
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

set title "double-precision complex, 3d transforms, 1 CPU, powers of two\nin-place"
set origin 0.0,0.5
plot '< grep "   8      0" fft_check_powr2_stride2.SR16000.r1307.dat'\
                                                  using 0:10  t   'SR16000 MATRIX/MPP SMT=off' w lp lt 3 lw 2 pt 4,\
     '< grep "  16      0" fft_check_powr2_stride1.SR16000.r1307.dat'\
                                                  using 0:10  t   'SR16000 MATRIX/MPP SMT=on ' w lp lt 3 lw 2 pt 5,\
     'fft_check_powr2.FX10.r1292.FFTW.dat'        using 0:11  t                    'FX10 FFTW' w lp lt 1 lw 2 pt 7,\
     'fft_check_powr2.FX10.r1292.SSL2.dat'        using 0:11  t                    'FX10 SSL2' w lp lt 1 lw 2 pt 1

set title "double-precision real-data, 3d transforms, 1 CPU, powers of two\nout-of-place or copy before/after transform"
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
set xrange [-1:26]
set xtics ("30x30x30" 0,\
"48x48x48"	      1,\
"54x54x54"	      2,\
"72x72x72"	      3,\
"75x75x75"	      4,\
"80x80x80"	      5,\
"81x81x81"	      6,\
"96x96x96"	      7,\
"100x100x100"	      8,\
"120x120x120"	      9,\
"240x240x240"	     10,\
"243x243x243"	     11,\
"300x300x300"	     12,\
"320x320x320"	     13,\
"360x360x360"	     14,\
"400x400x400"	     15,\
"405x405x405"	     16,\
"432x432x432"	     17,\
"500x500x500"	     18,\
"600x600x600"	     19,\
"720x720x720"	     20,\
"729x729x729"	     21,\
"800x800x800"	     22,\
"810x810x810"	     23,\
"900x900x900"	     24,\
"1000x1000x1000"     25) rotate

set size 1.0,1.0   #-----------------------------------------------------------------------------
set output "fft_check_nonp2.1node.eps"
set multiplot

set size 1.0,0.52

set title "double-precision complex, 3d transforms, 1 node, powers of two\nin-place"
set origin 0.0,0.5
plot '< grep "  32      0" fft_check_nonp2_stride2.SR16000.r1307.dat'\
                                                  using 0:10  t   'SR16000 MATRIX/MPP SMT=off' w lp lt 3 lw 2 pt 4,\
     '< grep "  64      0" fft_check_nonp2_stride1.SR16000.r1307.dat'\
                                                  using 0:10  t   'SR16000 MATRIX/MPP SMT=on ' w lp lt 3 lw 2 pt 5,\
     '< grep "  12      0" fft_check_nonp2.X5650.r1307.dat'\
                                                  using 0:10  t             'X5650 MKL HT=off' w lp lt 4 lw 2 pt 2

set title "double-precision real-data, 3d transforms, 1 node, powers of two\nout-of-place or copy before/after transform"
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

set title "double-precision complex, 3d transforms, 1 CPU, powers of two\nin-place"
set origin 0.0,0.5
plot '< grep "   8      0" fft_check_nonp2_stride2.SR16000.r1307.dat'\
                                                  using 0:10  t   'SR16000 MATRIX/MPP SMT=off' w lp lt 3 lw 2 pt 4,\
     '< grep "  16      0" fft_check_nonp2_stride1.SR16000.r1307.dat'\
                                                  using 0:10  t   'SR16000 MATRIX/MPP SMT=on ' w lp lt 3 lw 2 pt 5,\
     '< grep "   6      0" fft_check_nonp2.X5650.r1307.dat'\
                                                  using 0:10  t             'X5650 MKL HT=off' w lp lt 4 lw 2 pt 2

set title "double-precision real-data, 3d transforms, 1 CPU, powers of two\nout-of-place or copy before/after transform"
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
