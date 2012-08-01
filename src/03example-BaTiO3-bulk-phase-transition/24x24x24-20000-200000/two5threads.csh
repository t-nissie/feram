#!/bin/csh
##
hostname > two5threads.dat
w       >> two5threads.dat

setenv OMP_NUM_THREADS 5

rm -f wisdom
taskset -c 0-4  ../../fft_check 10000 24 24 24 >> two5threads.dat
mv wisdom_new wisdom

taskset -c 0-4  ./cooling.sh &
taskset -c 6-10 ./heating.sh &
wait

grep TIMING_REPORT *.log >> two5threads.dat

rm -f *.coord *K.restart *K.param *K.distribution *K.avg
