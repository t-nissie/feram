#!/bin/csh
# Usage: submit AEB general -exec anti-100-two6threads.csh -J anti-100-two6threads
##
setenv OMP_NUM_THREADS 6
taskset -c 0-5  ./anti-100-cooling.sh &
taskset -c 6-11 ./anti-100-heating.sh &
wait
