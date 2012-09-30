#!/bin/bash
# Usage: ./epit256x256x256.X5690.bash >epit256x256x256.X5690.out 2>epit256x256x256.X5690.err
##
rm -f wisdom
for i in 6 12; do
    export OMP_NUM_THREADS=$i
    taskset -c 0-`expr $i - 1` ../fft_check 100  256 256 256
    mv wisdom_new wisdom
    taskset -c 0-`expr $i - 1` ../feram epit256x256x256.feram 
    timing_report=`grep TIMING_REPORT epit256x256x256.log`
    printf '%2d %s\n' $s $i "$timing_report" >> epit256x256x256.X5690.dat
    mv wisdom wisdom.256x256x256.threads$i
done
rm -f *.coord
