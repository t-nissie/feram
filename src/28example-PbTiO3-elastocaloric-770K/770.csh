#!/bin/csh
# Usage: submit SC general -longtime -pt 16 -exec 770.csh -J 770example28
##
# For IBM XL Fortran
setenv MALLOCMULTIHEAP true
setenv XLSMPOPTS "spins=0:yields=0"
./feram 770.vs.feram 770.lf.feram
