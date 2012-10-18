#!/bin/bash
##
export OMP_NUM_THREADS=16

rm -f wisdom

../feram md64x64x64.feram
mv md64x64x64.log md64x64x64.without-numactl.log

numactl --cpunodebind=0,1 --interleave=all ../feram md64x64x64.feram
mv md64x64x64.log md64x64x64.without-wisdom.log

numactl --cpunodebind=0,1 --interleave=all ../fft_check 10000 64 64 64 > fft_check64x64x64.log 2>&1
mv wisdom_new wisdom

numactl --cpunodebind=0,1 --interleave=all ../feram md64x64x64.feram
mv md64x64x64.log md64x64x64.with-wisdom.log
