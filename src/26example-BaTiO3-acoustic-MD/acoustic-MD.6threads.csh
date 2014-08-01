#!/bin/csh
# Author:  Takeshi Nishimatsu
# Purpose: benchmark with single chip Intel Xeon X5650
# Usage:   submit AEB general -exec acoustic-MD.csh -J acoustic-MD
##
setenv OMP_NUM_THREADS 6
taskset -c 6-11 ./feram acoustic-MD.vs.feram
ln -sf acoustic-MD.vs.0000050000.coord acoustic-MD.lf.restart
taskset -c 6-11 ./feram acoustic-MD.lf.feram
grep TIMING_REPORT *.log > acoustic-MD.dat
rm -f  acoustic-MD.vs.0000050000.coord acoustic-MD.lf.restart
