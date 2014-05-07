#!/bin/csh
# Usage: submit AEB general -exec rand-000-two6threads.csh -J rand-000-two6threads
##
setenv OMP_NUM_THREADS 6
taskset -c 0-5  ./rand-000-cooling.sh &
taskset -c 6-11 ./rand-000-heating.sh &
wait
