#!/bin/csh
# Usage: submit AEB general -exec rnd3-100-two6threads.csh -J rnd3-100-two6threads
##
setenv OMP_NUM_THREADS 6
taskset -c 0-5  ./rnd3-100-cooling.sh &
taskset -c 6-11 ./rnd3-100-heating.sh &
wait
