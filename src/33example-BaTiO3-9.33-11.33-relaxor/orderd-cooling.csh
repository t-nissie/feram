#!/bin/csh
# For IBM XL Fortran
setenv MALLOCMULTIHEAP true
if (! ${?XLSMPOPTS}) then
    setenv XLSMPOPTS "spins=0:yields=0"
endif
./orderd-cooling.sh
