#!/bin/csh
##
hostname > two6threads.dat
w       >> two6threads.dat

setenv OMP_NUM_THREADS 6

rm -f wisdom
taskset -c 0-5  ../../fft_check 10000 24 24 24 >> two6threads.dat
mv wisdom_new wisdom

taskset -c 0-5  ./cooling.sh &
taskset -c 6-11 ./heating.sh &
wait

grep TIMING_REPORT *.log >> two6threads.dat

rm -f *.coord *K.restart *K.param *K.distribution *K.avg
