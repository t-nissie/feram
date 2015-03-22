#!/bin/csh
# Usage: submit AEB general -exec anti-075-two6threads.csh -J anti-075-two6threads
##
setenv OMP_NUM_THREADS 6
taskset -c 0-5  ./anti-075-cooling.sh &
taskset -c 6-11 ./anti-075-heating.sh &
wait
