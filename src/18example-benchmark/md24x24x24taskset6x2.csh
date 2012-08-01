#!/bin/csh
##
hostname > md24x24x24taskset6x2.dat
w       >> md24x24x24taskset6x2.dat

setenv OMP_NUM_THREADS 6

rm -f wisdom
taskset -c 0-5  ../fft_check 10000 24 24 24 >> md24x24x24taskset6x2.dat
mv wisdom_new wisdom

ln -s md24x24x24.feram md24x24x24a.feram
ln -s md24x24x24.feram md24x24x24b.feram

taskset -c 0-5  ../feram md24x24x24a.feram &
taskset -c 6-11 ../feram md24x24x24b.feram &
wait

grep TIMING_REPORT md24x24x24[ab].log >> md24x24x24taskset6x2.dat

rm -f md24x24x24[ab].*
