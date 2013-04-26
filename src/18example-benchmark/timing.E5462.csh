#!/bin/csh
# timing.csh: Measuring parallel performance with forward.feram
# Author: Takeshi Nishimatsu
# Requirement: taskset(1)
##
rm -f wisdom

setenv OMP_NUM_THREADS 4
taskset -c 0-5 ./fft_check 10000 32 32 243
mv wisdom_new wisdom
taskset -c 0-5 ./feram forward.feram
printf '%2d %10.2f %10.2f %10.2f %s\n' $OMP_NUM_THREADS `grep TIMING_REPORT forward.log` >  forward.E5462.dat
mv wisdom wisdom.E5462.04threads

setenv OMP_NUM_THREADS 8
./fft_check 10000 32 32 243
mv wisdom_new wisdom
./feram forward.feram
printf '%2d %10.2f %10.2f %10.2f %s\n' $OMP_NUM_THREADS `grep TIMING_REPORT forward.log` >> forward.E5462.dat
mv wisdom wisdom.E5462.08threads

rm -f *.coord
