#!/bin/csh
# Usage: ./two2threads.csh 2> two4threads.stderr &
##
hostname > two4threads.dat
w       >> two4threads.dat

setenv OMP_NUM_THREADS 4

taskset -c 0-3 ./cooling.sh &
taskset -c 4-7 ./heating.sh &
wait

grep TIMING_REPORT *.log >> two4threads.dat
