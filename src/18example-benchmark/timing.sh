#!/bin/sh
# timing.sh: Measuring parallel performance with forward.feram
# Author: Takeshi Nishimatsu
# Requirement: GNU 1.7 version of time(1)
# $Date$
# $Rev$
# $Author$
##
OMP_NUM_THREADS=1  time -o timing.dat -f '%e %U %S %R'    ../feram forward.feram
OMP_NUM_THREADS=2  time -o timing.dat -f '%e %U %S %R' -a ../feram forward.feram
OMP_NUM_THREADS=3  time -o timing.dat -f '%e %U %S %R' -a ../feram forward.feram
OMP_NUM_THREADS=4  time -o timing.dat -f '%e %U %S %R' -a ../feram forward.feram
OMP_NUM_THREADS=5  time -o timing.dat -f '%e %U %S %R' -a ../feram forward.feram
OMP_NUM_THREADS=6  time -o timing.dat -f '%e %U %S %R' -a ../feram forward.feram
OMP_NUM_THREADS=7  time -o timing.dat -f '%e %U %S %R' -a ../feram forward.feram
OMP_NUM_THREADS=8  time -o timing.dat -f '%e %U %S %R' -a ../feram forward.feram
OMP_NUM_THREADS=9  time -o timing.dat -f '%e %U %S %R' -a ../feram forward.feram
OMP_NUM_THREADS=10 time -o timing.dat -f '%e %U %S %R' -a ../feram forward.feram
OMP_NUM_THREADS=11 time -o timing.dat -f '%e %U %S %R' -a ../feram forward.feram
OMP_NUM_THREADS=12 time -o timing.dat -f '%e %U %S %R' -a ../feram forward.feram
