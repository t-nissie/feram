#!/bin/csh
# Usage: submit SC general -exec 770.csh -J 770
##
# For IBM XL Fortran
setenv MALLOCMULTIHEAP true
setenv XLSMPOPTS "spins=0:yields=0"
./feram 770.vs.feram
ln -sf 770.vs.0000050000.coord 770.lf.restart
./feram 770.lf.feram
rm -f  770.vs.0000050000.coord 770.lf.restart 770.lf.0000050000.coord
