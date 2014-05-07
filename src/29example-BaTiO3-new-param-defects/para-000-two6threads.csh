#!/bin/csh
# Usage: submit AEB general -exec para-000-two6threads.csh -J para-000-two6threads
##
setenv OMP_NUM_THREADS 6
taskset -c 0-5  ./para-000-cooling.sh &
taskset -c 6-11 ./para-000-heating.sh &
wait
