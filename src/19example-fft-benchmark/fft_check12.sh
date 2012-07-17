#!/bin/sh
# Usage: ./fft_check12.sh
##
set OMP_NUM_THREADS=12
export OMP_NUM_THREADS

../fft_check  100000   32   32   32
../fft_check   10000   64   64   64
../fft_check   10000  256   64   32
../fft_check    1000   16 1024   64
../fft_check    1000  128  128  128
../fft_check     100  256  256  256
../fft_check     100  128  256 1024
../fft_check     100  256  256  512
../fft_check      50  256  512  512
../fft_check      50  512  256  512
../fft_check      50  512  512  512
../fft_check      50  256  512 1024
../fft_check      50 1024  512  256
../fft_check      20  512  512 1024
../fft_check      10  512 1024 1024

../fft_check  100000   30   30   30
../fft_check   50000   48   48   48
../fft_check   50000   54   54   54
../fft_check   10000   32   32  243
../fft_check   10000   72   72   72
../fft_check   10000   75   75   75
../fft_check    5000   80   80   80
../fft_check    5000   81   81   81
../fft_check    2000   96   96   96
../fft_check    2000  100  100  100
../fft_check    1000  120  120  120
../fft_check     300  240  240  240
../fft_check     100  243  243  243
../fft_check     100  300  300  300
../fft_check     100  320  320  320
../fft_check      50  360  360  360
../fft_check      50  400  400  400
../fft_check      50  405  405  405
../fft_check      50  432  432  432
../fft_check      30  500  500  500
../fft_check      30  600  600  600
../fft_check      30  720  720  720
../fft_check      30  729  729  729
../fft_check      30  800  800  800
../fft_check      20  810  810  810
../fft_check      10  900  900  900
