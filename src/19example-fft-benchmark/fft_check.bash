#!/bin/bash
# Usage: ./fft_check.bash 2> fft_check.stderr &
##

benchmark()
{
    powr2=$1
    nonp2=$2
    ../fft_check  100000   32   32   32 >> $powr2
    ../fft_check   10000   64   64   64 >> $powr2
    ../fft_check   10000  256   64   32 >> $powr2
    ../fft_check    1000   16 1024   64 >> $powr2
    ../fft_check    1000  128  128  128 >> $powr2
    ../fft_check     100  256  256  256 >> $powr2
    ../fft_check     100  128  256 1024 >> $powr2
    ../fft_check     100  256  256  512 >> $powr2
    ../fft_check      50  256  512  512 >> $powr2
    ../fft_check      50  512  256  512 >> $powr2
    ../fft_check      50  512  512  512 >> $powr2
    ../fft_check      50  256  512 1024 >> $powr2
    ../fft_check      50 1024  512  256 >> $powr2
    ../fft_check      50  512  512 1024 >> $powr2
    ../fft_check      50  512 1024 1024 >> $powr2
    ../fft_check      20 1024 1024 1024 >> $powr2
    #
    ../fft_check  100000   30   30   30 >> $nonp2
    ../fft_check   50000   48   48   48 >> $nonp2
    ../fft_check   50000   54   54   54 >> $nonp2
    ../fft_check   10000   72   72   72 >> $nonp2
    ../fft_check   10000   75   75   75 >> $nonp2
    ../fft_check    5000   80   80   80 >> $nonp2
    ../fft_check    5000   81   81   81 >> $nonp2
    ../fft_check    2000   96   96   96 >> $nonp2
    ../fft_check    2000  100  100  100 >> $nonp2
    ../fft_check    1000  120  120  120 >> $nonp2
    ../fft_check     300  240  240  240 >> $nonp2
    ../fft_check     100  243  243  243 >> $nonp2
    ../fft_check     100  300  300  300 >> $nonp2
    ../fft_check     100  320  320  320 >> $nonp2
    ../fft_check      50  360  360  360 >> $nonp2
    ../fft_check      50  400  400  400 >> $nonp2
    ../fft_check      50  405  405  405 >> $nonp2
    ../fft_check      50  432  432  432 >> $nonp2
    ../fft_check      30  500  500  500 >> $nonp2
    ../fft_check      30  600  600  600 >> $nonp2
    ../fft_check      30  720  720  720 >> $nonp2
    ../fft_check      30  729  729  729 >> $nonp2
    ../fft_check      30  800  800  800 >> $nonp2
    ../fft_check      20  810  810  810 >> $nonp2
    ../fft_check      20  900  900  900 >> $nonp2
    ../fft_check      10 1000 1000 1000 >> $nonp2
}

debug()
{
    powr2=$1
    nonp2=$2
    ../fft_check    1000   64   64   64 >> $powr2
    ../fft_check    1000   60   60   60 >> $nonp2
    ../fft_check    1000   81   81   81 >> $nonp2
    ../fft_check    1000   90   90   90 >> $nonp2
}

export MEMORY_AFFINITY=MCM
export HF_ERR_STATUS_MODE=1
export HF_PRUNST_BIND=1
export HF_BINDPROC_NUM=0

rm -f fft_check_powr2.dat \
      fft_check_nonp2.dat

export HF_BINDPROC_STRIDE=2
for i in 1 2 4 6 8 10 12; do
    export OMP_NUM_THREADS=$i
    benchmark fft_check_powr2.dat \
              fft_check_nonp2.dat
done
