#!/bin/csh
# Usage: submit SC general -exec elastocaloric770K_check.csh -J elastocaloric770K_check
##
# For IBM XL Fortran
setenv MALLOCMULTIHEAP true
if (! ${?XLSMPOPTS}) then
    setenv XLSMPOPTS "spins=0:yields=0"
endif

if (!(-f       elastocaloric770K_check.vs.feram)) then
    cp $srcdir/elastocaloric770K_check.vs.feram .
    cp $srcdir/elastocaloric770K_check.lf.feram .
endif

./feram elastocaloric770K_check.vs.feram elastocaloric770K_check.lf.feram
set t_final=`colrm 8 < elastocaloric770K_check.lf.avg`
if ((`echo "691.00 < $t_final" | bc` == 1) && (`echo "$t_final < 695.00" | bc` == 1)) then
    echo $0 : T_final = $t_final seems OK
else
    echo $0 : T_final = $t_final seems NOT good
    exit 1
endif
