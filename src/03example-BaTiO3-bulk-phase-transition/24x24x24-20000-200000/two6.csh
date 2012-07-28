#!/bin/csh
##
w
setenv OMP_NUM_THREADS 6
../../fft_check 10000 24 24 24
mv wisdom_new wisdom
./cooling.sh &
./heating.sh
wait
