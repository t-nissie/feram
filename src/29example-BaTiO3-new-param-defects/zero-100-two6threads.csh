#!/bin/csh
# Usage: submit AEB general -exec zero-100-two6threads.csh -J zero-100-two6threads
##
setenv OMP_NUM_THREADS 6
taskset -c 0-5  ./zero-100-cooling.sh &
taskset -c 6-11 ./zero-100-heating.sh &
wait
