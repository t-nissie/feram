#!/usr/bin/env gnuplot
# Time-stamp: <2013-07-09 21:04:23 takeshi>
# Author: Takeshi NISHIMATSU
##
set terminal postscript portrait enhanced dashed color 'Times-Roman' 12
set output 'fft_check_mpi_only.real.out-of-place.eps'
#set key outside
#set bmargin 8
set key left
set size 0.7,0.5
set size square

set xlabel "\nSR16000: (MPI process)/(node)"
set xrange [0:4]
set xtics ("64\n2" 0,\
          "128\n4" 1,\
          "256\n8" 2,\
         "512\n16" 3,\
        "1024\n32" 4)

set ylabel 'GFLOPS'
set yrange [0:4]
set ytics ("100" 0,\
           "200" 1,\
           "400" 2,\
           "800" 3,\
          "1600" 4)
plot x t '',\
     'fft_check_mpi_only.real.4096x4096x4096.out.SR16000'\
     using (log($1/2)/log(2)):(log($12/100.00)/log(2)) t 'SR16000: 4096x4096x4096' w lp,\
     'fft_check_mpi_only.real.2048x2048x2048.out.SR16000'\
     using (log($1/2)/log(2)):(log($12/100.00)/log(2)) t 'SR16000: 2048x2048x2048' w lp

#Local variables:
#  compile-command: "gnuplot fft_check_mpi_only.real.out-of-place.gp"
#End:
