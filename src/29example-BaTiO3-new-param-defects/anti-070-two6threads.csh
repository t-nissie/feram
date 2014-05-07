#!/bin/csh
# Usage: submit AEB general -exec anti-070-two6threads.csh -J anti-070-two6threads
##
setenv OMP_NUM_THREADS 6
taskset -c 0-5  ./anti-070-cooling.sh &
taskset -c 6-11 ./anti-070-heating.sh &
wait
