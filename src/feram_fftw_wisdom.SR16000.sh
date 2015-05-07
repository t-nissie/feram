#!/bin/sh
# Usage: MALLOCMULTIHEAP=true XLSMPOPTS="spins=0:yields=0:parthds=32:stride=2:startproc=0" feram_fftw_wisdom.SR16000.sh
##
# For IBM XL Fortran
export MALLOCMULTIHEAP=true
if [ -z "$XLSMPOPTS" ]; then
    export XLSMPOPTS="spins=0:yields=0"
fi

./feram_fftw_wisdom 10000  32  32  32 1 | tee 032x032x032-1.dat
./feram_fftw_wisdom 10000  32  32  32 3 | tee 032x032x032-3.dat
./feram_fftw_wisdom  2000  64  64  64 3 | tee 064x064x064-3.dat
./feram_fftw_wisdom  1000  96  96  96 1 | tee 096x096x096-1.dat
./feram_fftw_wisdom   500 128 128 128 1 | tee 128x128x128-1.dat
./feram_fftw_wisdom   500 128 128 128 3 | tee 128x128x128-3.dat
