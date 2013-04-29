#!/bin/csh
# timing.csh: Measuring parallel performance with forward.feram
# Author: Takeshi Nishimatsu
# Requirement: taskset(1)
##
rm -f wisdom

setenv OMP_NUM_THREADS 1
./fft_check 10000 32 32 243
mv wisdom_new wisdom
./feram forward.feram
printf '%2d %10.2f %10.2f %10.2f %s\n' $OMP_NUM_THREADS `grep TIMING_REPORT forward.log` >  forward.Core_i5.dat
mv wisdom wisdom.Core_i5.06threads

setenv OMP_NUM_THREADS 2
./fft_check 10000 32 32 243
mv wisdom_new wisdom
./feram forward.feram
printf '%2d %10.2f %10.2f %10.2f %s\n' $OMP_NUM_THREADS `grep TIMING_REPORT forward.log` >> forward.Core_i5.dat
mv wisdom wisdom.Core_i5.12threads

rm -f *.coord
