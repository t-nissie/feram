#!/bin/csh
##
setenv OMP_NUM_THREADS 6
taskset -c 0-5  ./cooling.sh &
taskset -c 6-11 ./heating.sh &
wait
grep TIMING_REPORT *.log >> two6threads.dat
rm -f *.coord *K.restart *K.param *K.distribution *K.avg
