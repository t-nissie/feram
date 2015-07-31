#!/bin/csh
# For IBM XL Fortran
setenv MALLOCMULTIHEAP true
if (! ${?XLSMPOPTS}) then
    setenv XLSMPOPTS "spins=0:yields=0"
endif
./feram 350.1vs.feram 350.2lf.feram
