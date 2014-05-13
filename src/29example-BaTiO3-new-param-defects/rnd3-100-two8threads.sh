#!/bin/sh
# Usage: ./rnd3-100-two8threads.sh 2> rnd3-100-two8threads.err &
##
export OMP_NUM_THREADS=8
numactl --cpunodebind=0 ./rnd3-100-cooling.sh &
numactl --cpunodebind=1 ./rnd3-100-heating.sh &
wait
