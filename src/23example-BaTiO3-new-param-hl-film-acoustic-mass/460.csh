#!/bin/csh
# Usage: submit SC general -exec 460.csh -J 460
##
# For IBM XL Fortran
setenv MALLOCMULTIHEAP true
setenv XLSMPOPTS "spins=0:yields=0"
./feram 460.feram
