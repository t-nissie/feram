#!/bin/sh
# Usage: ./scorep_04threads.sh > scorep_04threads.out 2>&1 &
##
OMP_NUM_THREADS=4 taskset -c 0-3 scan -e scorep_acoustic-MD.vs_04threads ./feram acoustic-MD.vs.feram
mv acoustic-MD.vs.log                    scorep_acoustic-MD.vs_04threads
ln -sf acoustic-MD.vs.0000050000.coord acoustic-MD.lf.restart
OMP_NUM_THREADS=4 taskset -c 0-3 scan -e scorep_acoustic-MD.lf_04threads ./feram acoustic-MD.lf.feram
mv acoustic-MD.lf.log                    scorep_acoustic-MD.lf_04threads
rm -rf acoustic-MD.vs.0000050000.coord acoustic-MD.lf.restart
