#!/bin/sh
# Usage: ./rnd3-000-two8threads.sh 2> rnd3-000-two8threads.err &
##
export OMP_NUM_THREADS=8
numactl --cpunodebind=0 ./rnd3-000-cooling.sh &
numactl --cpunodebind=1 ./rnd3-000-heating.sh &
wait
