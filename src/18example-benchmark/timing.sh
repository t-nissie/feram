#!/bin/sh
# timing.sh: Measuring parallel performance with forward.feram
# Author: Takeshi Nishimatsu
# Requirement: GNU 1.7 version of time(1)
# $Date$
# $Rev$
# $Author$
##
rm -f timing.dat
for j in `jot 5`; do
    for i in `jot 12`; do
	OMP_NUM_THREADS=$i time -o timing.dat -f "$i %e %U %S %R" -a ../feram forward.feram
    done
done
