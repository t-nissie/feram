#!/bin/csh
# Usage: submit SC general -largememory -exec fft_old_check_nonp2.csh -J fft_old_check_nonp2
#        submit EB general -largememory -exec fft_old_check_nonp2.csh -J fft_old_check_nonp2
##

# For IBM XL Fortran
setenv MALLOCMULTIHEAP true
setenv XLSMPOPTS "spins=0:yields=0"

./fft_old_check  100000   30   30   30 0 F >> fft_old_check_nonp2.dat
./fft_old_check   50000   48   48   48 0 F >> fft_old_check_nonp2.dat
./fft_old_check   50000   54   54   54 0 F >> fft_old_check_nonp2.dat
./fft_old_check   10000   32   32  243 0 F >> fft_old_check_nonp2.dat
./fft_old_check   10000   72   72   72 0 F >> fft_old_check_nonp2.dat
./fft_old_check   10000   75   75   75 0 F >> fft_old_check_nonp2.dat
./fft_old_check    5000   80   80   80 0 F >> fft_old_check_nonp2.dat
./fft_old_check    5000   81   81   81 0 F >> fft_old_check_nonp2.dat
./fft_old_check    2000   96   96   96 0 F >> fft_old_check_nonp2.dat
./fft_old_check    2000  100  100  100 0 F >> fft_old_check_nonp2.dat
./fft_old_check    1000  120  120  120 0 F >> fft_old_check_nonp2.dat
./fft_old_check     300  240  240  240 0 F >> fft_old_check_nonp2.dat
./fft_old_check     100  243  243  243 0 F >> fft_old_check_nonp2.dat
./fft_old_check     100  300  300  300 0 F >> fft_old_check_nonp2.dat
./fft_old_check     100  320  320  320 0 F >> fft_old_check_nonp2.dat
./fft_old_check      50  360  360  360 0 F >> fft_old_check_nonp2.dat
./fft_old_check      50  400  400  400 0 F >> fft_old_check_nonp2.dat
./fft_old_check      50  405  405  405 0 F >> fft_old_check_nonp2.dat
./fft_old_check      50  432  432  432 0 F >> fft_old_check_nonp2.dat
./fft_old_check      30  500  500  500 0 F >> fft_old_check_nonp2.dat
./fft_old_check      30  600  600  600 0 F >> fft_old_check_nonp2.dat
./fft_old_check      30  720  720  720 0 F >> fft_old_check_nonp2.dat
./fft_old_check      30  729  729  729 0 F >> fft_old_check_nonp2.dat
./fft_old_check      30  800  800  800 0 F >> fft_old_check_nonp2.dat
./fft_old_check      20  810  810  810 0 F >> fft_old_check_nonp2.dat
#./fft_old_check     20  900  900  900 0 F >> fft_old_check_nonp2.dat
#./fft_old_check     10 1000 1000 1000 0 F >> fft_old_check_nonp2.dat
