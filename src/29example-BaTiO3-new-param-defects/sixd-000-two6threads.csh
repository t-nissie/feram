#!/bin/csh
# Usage: submit AEB general -exec sixd-000-two6threads.csh -J sixd-000-two6threads
##
setenv OMP_NUM_THREADS 6
taskset -c 0-5  ./sixd-000-cooling.sh &
taskset -c 6-11 ./sixd-000-heating.sh &
wait
