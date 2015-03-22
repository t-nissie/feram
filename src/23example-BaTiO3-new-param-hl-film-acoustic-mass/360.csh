#!/bin/csh
# Usage: submit SC general -exec 360.csh -J 360
##
# For IBM XL Fortran
setenv MALLOCMULTIHEAP true
setenv XLSMPOPTS "spins=0:yields=0"
./feram 360.feram
