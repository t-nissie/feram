#!/bin/csh
# Usage: submit AEB general -exec para-100-two6threads.csh -J para-100-two6threads
##
setenv OMP_NUM_THREADS 6
taskset -c 0-5  ./para-100-cooling.sh &
taskset -c 6-11 ./para-100-heating.sh &
wait
