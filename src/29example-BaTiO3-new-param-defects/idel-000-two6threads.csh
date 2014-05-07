#!/bin/csh
# Usage: submit AEB general -exec idel-000-two6threads.csh -J idel-000-two6threads
##
setenv OMP_NUM_THREADS 6
taskset -c 0-5  ./idel-000-cooling.sh &
taskset -c 6-11 ./idel-000-heating.sh &
wait
