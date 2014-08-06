#!/bin/sh
# Usage: ./scorep_08threads.sh > scorep_08threads.out 2>&1 &
##
OMP_NUM_THREADS=8 scan -e scorep_acoustic-MD.vs_08threads ./feram acoustic-MD.vs.feram
mv acoustic-MD.vs.log     scorep_acoustic-MD.vs_08threads
ln -sf acoustic-MD.vs.0000050000.coord acoustic-MD.lf.restart
OMP_NUM_THREADS=8 scan -e scorep_acoustic-MD.lf_08threads ./feram acoustic-MD.lf.feram
mv acoustic-MD.lf.log     scorep_acoustic-MD.lf_08threads
rm -rf acoustic-MD.vs.0000050000.coord acoustic-MD.lf.restart
