#!/bin/sh
# Usage: ./rnd2-000-two8threads.sh 2> rnd2-000-two8threads.err &
##
export OMP_NUM_THREADS=8
numactl --cpunodebind=0 ./rnd2-000-cooling.sh &
numactl --cpunodebind=1 ./rnd2-000-heating.sh &
wait
