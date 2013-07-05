#!/bin/csh
# Usage: ./two2threads.csh 2> two2threads.stderr &
##
hostname > two2threads.dat
w       >> two2threads.dat

setenv OMP_NUM_THREADS 2

taskset -c 0-1 ./cooling.sh &
taskset -c 2-3 ./heating.sh &
wait

grep TIMING_REPORT *.log >> two2threads.dat

rm -f *.coord *K.restart *K.param *K.distribution *K.avg
