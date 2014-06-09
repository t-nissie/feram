#!/bin/csh
# Usage: submit SC general -exec elastocaloric770K_check.csh -J elastocaloric770K_check
##
# For IBM XL Fortran
setenv MALLOCMULTIHEAP true
setenv XLSMPOPTS "spins=0:yields=0:parthds=8:stride=2:startproc=0"

if (!(-f       elastocaloric770K_check.vs.feram)) then
    cp $srcdir/elastocaloric770K_check.vs.feram .
    cp $srcdir/elastocaloric770K_check.lf.feram .
endif

./feram elastocaloric770K_check.vs.feram elastocaloric770K_check.lf.feram
set t_final=`colrm 8 < elastocaloric770K_check.lf.avg`
test `echo "$t_final < 695.00" | bc` = 1
