#!/bin/csh
# Usage: ./cufft_check_powr2.csh >cufft_check_powr2.dat 2>cufft_check_powr2.err &
##
./cufft_check  100000   32   32   32
./cufft_check   10000   64   64   64
./cufft_check   10000  256   64   32
./cufft_check    1000   16 1024   64
./cufft_check    1000  128  128  128
./cufft_check     100  256  256  256
./cufft_check     100  128  256 1024
./cufft_check     100  256  256  512
./cufft_check      50  256  512  512
./cufft_check      50  512  256  512
./cufft_check      50  512  512  512
./cufft_check      50  256  512 1024
