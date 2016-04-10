#!/bin/csh
# Usage@app1.IMR$ submit AEB general -exec two6threads.csh -J two6threads
##
setenv OMP_NUM_THREADS 6
taskset -c 0-5  ./cooling.sh &
taskset -c 6-11 ./heating.sh &
wait
grep TIMING_REPORT *.log > two6threads.dat
rm -f *.coord *K.restart *K.param.gp *K.avg
