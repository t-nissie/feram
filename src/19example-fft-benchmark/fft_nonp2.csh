#!/bin/csh
foreach i (1 2 4 6 8 10 12)
    setenv OMP_NUM_THREADS $i
    ../fft_check  100000   30   30   30 >> fft_nonp2.dat
    ../fft_check   50000   48   48   48 >> fft_nonp2.dat
    ../fft_check   50000   54   54   54 >> fft_nonp2.dat
    ../fft_check   10000   32   32  243 >> fft_nonp2.dat
    ../fft_check   10000   72   72   72 >> fft_nonp2.dat
    ../fft_check   10000   75   75   75 >> fft_nonp2.dat
    ../fft_check    5000   80   80   80 >> fft_nonp2.dat
    ../fft_check    5000   81   81   81 >> fft_nonp2.dat
    ../fft_check    2000   96   96   96 >> fft_nonp2.dat
    ../fft_check    2000  100  100  100 >> fft_nonp2.dat
    ../fft_check    1000  120  120  120 >> fft_nonp2.dat
    ../fft_check     300  240  240  240 >> fft_nonp2.dat
    ../fft_check     100  243  243  243 >> fft_nonp2.dat
    ../fft_check     100  300  300  300 >> fft_nonp2.dat
    ../fft_check     100  320  320  320 >> fft_nonp2.dat
    ../fft_check      50  360  360  360 >> fft_nonp2.dat
    ../fft_check      50  400  400  400 >> fft_nonp2.dat
    ../fft_check      50  405  405  405 >> fft_nonp2.dat
    ../fft_check      50  432  432  432 >> fft_nonp2.dat
    ../fft_check      30  500  500  500 >> fft_nonp2.dat
    ../fft_check      30  600  600  600 >> fft_nonp2.dat
    ../fft_check      30  720  720  720 >> fft_nonp2.dat
    ../fft_check      30  729  729  729 >> fft_nonp2.dat
#    ../fft_check      30  800  800  800 >> fft_nonp2.dat
#    ../fft_check      20  810  810  810 >> fft_nonp2.dat
#    ../fft_check      20  900  900  900 >> fft_nonp2.dat
#    ../fft_check      10 1000 1000 1000 >> fft_nonp2.dat
end
