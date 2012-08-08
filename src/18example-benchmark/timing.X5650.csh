#!/bin/csh
# timing.csh: Measuring parallel performance with forward.feram
# Author: Takeshi Nishimatsu
# Requirement: taskset(1)
##
rm wisdom

setenv OMP_NUM_THREADS 6
taskset -c 0-5 ../fft_check 1000 32 32 243
mv wisdom_new wisdom
taskset -c 0-5 ../feram forward.feram
printf '%2d %s\n' $OMP_NUM_THREADS `grep TIMING_REPORT forward.log` >  forward.X5650.dat
mv wisdom wisdom.X5650.06threads

setenv OMP_NUM_THREADS 12
../fft_check 1000 32 32 243
mv wisdom_new wisdom
../feram forward.feram
printf '%2d %s\n' $OMP_NUM_THREADS `grep TIMING_REPORT forward.log` >> forward.X5650.dat
mv wisdom wisdom.X5650.12threads
