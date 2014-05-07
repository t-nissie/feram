#!/bin/sh
# Usage: ./zero-100-two8threads.sh 2> zero-100-two8threads.err &
##
export OMP_NUM_THREADS=8
numactl --cpunodebind=0 ./zero-100-cooling.sh &
numactl --cpunodebind=1 ./zero-100-heating.sh &
wait
