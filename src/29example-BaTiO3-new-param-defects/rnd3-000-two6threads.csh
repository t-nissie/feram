#!/bin/csh
# Usage: submit AEB general -exec rnd3-000-two6threads.csh -J rnd3-000-two6threads
##
setenv OMP_NUM_THREADS 6
taskset -c 0-5  ./rnd3-000-cooling.sh &
taskset -c 6-11 ./rnd3-000-heating.sh &
wait
