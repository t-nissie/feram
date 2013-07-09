#!/usr/bin/env gnuplot
# Time-stamp: <2013-07-10 08:51:11 takeshi>
# Author: Takeshi NISHIMATSU
##
set terminal postscript portrait enhanced dashed color 'Times-Roman' 12
set output 'fft_check_mpi_only.real.out-of-place.eps'
set title "3-dimensional real{/Symbol \253}complex out-of-place FFT\nwith FFTW\\_MEASURE, without padding"

#set key outside
#set bmargin 8
set key left
set size 0.7,0.6
set size square

set xrange [0:4]
set xlabel "\nSR16000:  (MPI process) / (node)"
set xtics ("64\n2" 0,\
          "128\n4" 1,\
          "256\n8" 2,\
         "512\n16" 3,\
        "1024\n32" 4)
set x2label "FX10:  (node) / (MPI process)\n"
set x2tics ("8\n128" 0,\
           "16\n256" 1,\
           "32\n512" 2,\
          "64\n1024" 3,\
         "128\n2048" 4)

set ylabel 'GFLOPS'
set yrange [0:4]
set ytics ("100" 0,\
           "200" 1,\
           "400" 2,\
           "800" 3,\
          "1600" 4)
plot x t '',\
     'fft_check_mpi_only.real.4096x4096x4096.out.SR16000'\
     using (log($1/2)/log(2)):(log($12/100.00)/log(2)) t 'SR16000: 4096x4096x4096' w lp pt 1 lw 2,\
     'fft_check_mpi_only.real.2048x2048x2048.out.SR16000'\
     using (log($1/2)/log(2)):(log($12/100.00)/log(2)) t 'SR16000: 2048x2048x2048' w lp pt 2 lw 2,\
     'fft_check_mpi_only.real.1024x1024x1024.out.SR16000'\
     using (log($1/2)/log(2)):(log($12/100.00)/log(2)) t 'SR16000: 1024x1024x1024' w lp pt 3 lw 2,\
     'fft_check_mpi_only.real.2048x2048x2048.out.FX10'\
     using (log($1/8)/log(2)):(log($12/100.00)/log(2)) t    'FX10: 2048x2048x2048' w lp pt 4 lw 2,\
     'fft_check_mpi_only.real.1024x1024x1024.out.FX10'\
     using (log($1/8)/log(2)):(log($12/100.00)/log(2)) t    'FX10: 1024x1024x1024' w lp pt 5 lw 2 lc 8

!epstopdf.pl fft_check_mpi_only.real.out-of-place.eps
#Local variables:
#  compile-command: "gnuplot fft_check_mpi_only.real.out-of-place.gp"
#End:
