#!/bin/csh
# timing.csh: Measuring parallel performance with forward.feram
# Author: Takeshi Nishimatsu
# Requirement: taskset(1)
##
rm -f wisdom

setenv OMP_NUM_THREADS 6
taskset -c 0-5 ../feram forward.feram
printf '%2d %10.2f %10.2f %10.2f %s\n' $OMP_NUM_THREADS `grep TIMING_REPORT forward.log` >  forward.X5650.dat

setenv OMP_NUM_THREADS 12
../feram forward.feram
printf '%2d %10.2f %10.2f %10.2f %s\n' $OMP_NUM_THREADS `grep TIMING_REPORT forward.log` >> forward.X5650.dat

rm -f *.coord
