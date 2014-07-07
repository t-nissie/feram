#!/bin/csh
# Usage: submit SC general -exec vs.csh -J vs
##
# For IBM XL Fortran
setenv MALLOCMULTIHEAP true
setenv XLSMPOPTS "spins=0:yields=0"
../feram vs.feram
