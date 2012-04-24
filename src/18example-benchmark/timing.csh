#!/bin/csh
# timing.csh: Measuring parallel performance with forward.feram
# Author: Takeshi Nishimatsu
# Requirement: GNU 1.7 version of time(1)
##
env OMP_NUM_THREADS=1  /usr/bin/time -o timing.dat -f '%e %U %S %R'    ../feram forward.feram
env OMP_NUM_THREADS=2  /usr/bin/time -o timing.dat -f '%e %U %S %R' -a ../feram forward.feram
env OMP_NUM_THREADS=3  /usr/bin/time -o timing.dat -f '%e %U %S %R' -a ../feram forward.feram
env OMP_NUM_THREADS=4  /usr/bin/time -o timing.dat -f '%e %U %S %R' -a ../feram forward.feram
env OMP_NUM_THREADS=5  /usr/bin/time -o timing.dat -f '%e %U %S %R' -a ../feram forward.feram
env OMP_NUM_THREADS=6  /usr/bin/time -o timing.dat -f '%e %U %S %R' -a ../feram forward.feram
env OMP_NUM_THREADS=7  /usr/bin/time -o timing.dat -f '%e %U %S %R' -a ../feram forward.feram
env OMP_NUM_THREADS=8  /usr/bin/time -o timing.dat -f '%e %U %S %R' -a ../feram forward.feram
env OMP_NUM_THREADS=9  /usr/bin/time -o timing.dat -f '%e %U %S %R' -a ../feram forward.feram
env OMP_NUM_THREADS=10 /usr/bin/time -o timing.dat -f '%e %U %S %R' -a ../feram forward.feram
env OMP_NUM_THREADS=11 /usr/bin/time -o timing.dat -f '%e %U %S %R' -a ../feram forward.feram
env OMP_NUM_THREADS=12 /usr/bin/time -o timing.dat -f '%e %U %S %R' -a ../feram forward.feram
