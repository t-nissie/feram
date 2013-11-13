#!/bin/csh
##
../feram acoustic-MD.vs.feram
ln -sf acoustic-MD.vs.0000050000.coord acoustic-MD.lf.restart
../feram acoustic-MD.lf.feram
grep TIMING_REPORT *.log > acoustic-MD.dat
