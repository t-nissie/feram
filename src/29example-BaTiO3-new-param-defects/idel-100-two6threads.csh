#!/bin/csh
# Usage: submit AEB general -exec idel-100-two6threads.csh -J idel-100-two6threads
##
setenv OMP_NUM_THREADS 6
taskset -c 0-5  ./idel-100-cooling.sh &
taskset -c 6-11 ./idel-100-heating.sh &
wait
