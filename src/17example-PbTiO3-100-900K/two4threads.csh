#!/bin/csh
##
setenv OMP_NUM_THREADS 4
taskset -c 2-5  ./cooling.sh &
taskset -c 8-11 ./heating.sh &
wait
grep TIMING_REPORT *.log >> two4threads.dat
rm -f *.coord *K.restart *K.param *K.distribution *K.avg
