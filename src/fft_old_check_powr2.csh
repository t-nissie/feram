#!/bin/csh
# Usage: submit SC general -largememory -exec fft_old_check_powr2.csh -J fft_old_check_powr2
#        submit EB general -largememory -exec fft_old_check_powr2.csh -J fft_old_check_powr2
##

# For IBM XL Fortran
setenv MALLOCMULTIHEAP true
setenv XLSMPOPTS "spins=0:yields=0"

./fft_old_check  100000   32   32   32 3 F >> fft_old_check_powr2.dat
./fft_old_check   10000   64   64   64 3 F >> fft_old_check_powr2.dat
./fft_old_check   10000  256   64   32 3 F >> fft_old_check_powr2.dat
./fft_old_check    1000   16 1024   64 3 F >> fft_old_check_powr2.dat
./fft_old_check    1000  128  128  128 3 F >> fft_old_check_powr2.dat
./fft_old_check     100  256  256  256 3 F >> fft_old_check_powr2.dat
./fft_old_check     100  128  256 1024 3 F >> fft_old_check_powr2.dat
./fft_old_check     100  256  256  512 3 F >> fft_old_check_powr2.dat
./fft_old_check      50  256  512  512 3 F >> fft_old_check_powr2.dat
./fft_old_check      50  512  256  512 3 F >> fft_old_check_powr2.dat
./fft_old_check      50  512  512  512 3 F >> fft_old_check_powr2.dat
./fft_old_check      50  256  512 1024 3 F >> fft_old_check_powr2.dat
./fft_old_check      50 1024  512  256 3 F >> fft_old_check_powr2.dat
./fft_old_check      50  512  512 1024 3 F >> fft_old_check_powr2.dat
./fft_old_check      50  512 1024 1024 3 F >> fft_old_check_powr2.dat
#./fft_old_check     20 1024 1024 1024 3 F >> fft_old_check_powr2.dat
