#!/bin/csh
# timing.csh: Measuring parallel performance with epit100x100x100.feram
# Author: Takeshi Nishimatsu
# Requirement: taskset(1)
##
rm -f wisdom

setenv OMP_NUM_THREADS 4
# taskset -c 0-`expr $OMP_NUM_THREADS - 1` ./fft_check 10000  100 100 100
# mv wisdom_new wisdom
taskset -c 0-`expr $OMP_NUM_THREADS - 1` ./feram epit100x100x100.feram
printf '%2d %10.2f %10.2f %10.2f %s\n' $OMP_NUM_THREADS `grep TIMING_REPORT epit100x100x100.log` >  epit100x100x100.E5462.dat
# mv wisdom wisdom.E5462.04threads

setenv OMP_NUM_THREADS 8
# ./fft_check 10000  100 100 100
# mv wisdom_new wisdom
./feram epit100x100x100.feram
printf '%2d %10.2f %10.2f %10.2f %s\n' $OMP_NUM_THREADS `grep TIMING_REPORT epit100x100x100.log` >> epit100x100x100.E5462.dat
# mv wisdom wisdom.E5462.08threads

rm -f *.coord
