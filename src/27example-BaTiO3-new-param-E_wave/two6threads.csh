#!/bin/csh
# Usage@app1.IMR$ submit AEB general -exec two6threads.csh -J two6threads
##
setenv OMP_NUM_THREADS 6

taskset -c 0-5  ../feram 360cos.feram &
taskset -c 6-11 ../feram 360sin.feram &
wait

grep TIMING_REPORT *.log >> two6threads.dat

rm -f *.coord *K.restart *K.param *K.distribution *K.avg
