#!/bin/csh
# Usage: submit SC general -largememory -exec fft_check_powr2.csh -J fft_check_powr2
##
./fft_check  100000   32   32   32 >> fft_check_powr2.dat
./fft_check   10000   64   64   64 >> fft_check_powr2.dat
./fft_check   10000  256   64   32 >> fft_check_powr2.dat
./fft_check    1000   16 1024   64 >> fft_check_powr2.dat
./fft_check    1000  128  128  128 >> fft_check_powr2.dat
./fft_check     100  256  256  256 >> fft_check_powr2.dat
./fft_check     100  128  256 1024 >> fft_check_powr2.dat
./fft_check     100  256  256  512 >> fft_check_powr2.dat
./fft_check      50  256  512  512 >> fft_check_powr2.dat
./fft_check      50  512  256  512 >> fft_check_powr2.dat
./fft_check      50  512  512  512 >> fft_check_powr2.dat
./fft_check      50  256  512 1024 >> fft_check_powr2.dat
./fft_check      50 1024  512  256 >> fft_check_powr2.dat
./fft_check      50  512  512 1024 >> fft_check_powr2.dat
./fft_check      50  512 1024 1024 >> fft_check_powr2.dat
./fft_check      20 1024 1024 1024 >> fft_check_powr2.dat
