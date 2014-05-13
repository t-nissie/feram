#!/bin/sh
# Usage: ./rnd4-100-two8threads.sh 2> rnd4-100-two8threads.err &
##
export OMP_NUM_THREADS=8
numactl --cpunodebind=0 ./rnd4-100-cooling.sh &
numactl --cpunodebind=1 ./rnd4-100-heating.sh &
wait
