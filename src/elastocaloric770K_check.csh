#!/bin/csh
# Usage: submit SC general -exec elastocaloric770K_check.csh -J elastocaloric770K_check
##
# For IBM XL Fortran
setenv MALLOCMULTIHEAP true
setenv XLSMPOPTS "spins=0:yields=0"

if (!(-f       elastocaloric770K_check.vs.feram)) then
    cp $srcdir/elastocaloric770K_check.vs.feram .
    cp $srcdir/elastocaloric770K_check.lf.feram .
endif

./feram elastocaloric770K_check.vs.feram elastocaloric770K_check.lf.feram
