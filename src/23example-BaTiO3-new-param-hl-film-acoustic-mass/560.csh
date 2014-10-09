#!/bin/csh
# Usage: submit SC general -exec 560.csh -J 560
##
# For IBM XL Fortran
setenv MALLOCMULTIHEAP true
setenv XLSMPOPTS "spins=0:yields=0"
./feram 560.feram
