#!/bin/csh
##
hostname > two8threads.dat
w       >> two8threads.dat

setenv OMP_NUM_THREADS 8

rm -f wisdom
taskset -c 0-7  ../../fft_check 10000 24 24 24 >> two8threads.dat
mv wisdom_new wisdom

taskset -c 0-7  ./cooling.sh &
taskset -c 8-15 ./heating.sh &
wait

grep TIMING_REPORT *.log >> two8threads.dat

rm -f *.coord *K.restart *K.param *K.distribution *K.avg
