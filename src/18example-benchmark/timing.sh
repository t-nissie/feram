#!/bin/sh
# timing.sh: Measuring parallel performance with forward.feram
# Author: Takeshi Nishimatsu
# Requirement: GNU 1.7 version of time(1)
# $Date$
# $Rev$
# $Author$
##
rm -f timing.dat
for i in `jot 12`; do
    for j in `jot 5`; do
	OMP_NUM_THREADS=$i time -o timing.dat -f "$i %e %U %S %R" -a ../feram forward.feram
    done
done
rm forward.0000005000.coord forward.coord
