#!/bin/csh
# Usage: submit SC general -exec 770.csh -J 770
##
# For IBM XL Fortran
setenv MALLOCMULTIHEAP true
setenv XLSMPOPTS "spins=0:yields=0"
./feram 770.vs.feram 770.lf.feram
