#!/bin/csh
# Usage: submit AEB general -exec sixd-100-two6threads.csh -J sixd-100-two6threads
##
setenv OMP_NUM_THREADS 6
taskset -c 0-5  ./sixd-100-cooling.sh &
taskset -c 6-11 ./sixd-100-heating.sh &
wait
