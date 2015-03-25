#!/bin/sh
# elastocaloric770K_check.sh: Bourne shell version of elastocaloric770K_check.csh
##
# For IBM XL Fortran
export MALLOCMULTIHEAP=true
if [ -z "$XLSMPOPTS" ]; then
    export XLSMPOPTS="spins=0:yields=0"
fi

if [ ! -f elastocaloric770K_check.vs.feram ]; then
    cp $srcdir/elastocaloric770K_check.vs.feram .
    cp $srcdir/elastocaloric770K_check.lf.feram .
fi

./feram elastocaloric770K_check.vs.feram elastocaloric770K_check.lf.feram

for f in elastocaloric770K_check.vs.log elastocaloric770K_check.lf.log; do
    (head -222 $f; echo '=== (snip) ========================'; tail -222 $f) > $f.digest
done

t_final=`colrm 8 < elastocaloric770K_check.lf.avg`
if [ `echo "691.00 < $t_final" | bc` = 1  -a `echo "$t_final < 695.00" | bc` = 1 ]; then
    echo $0 : T_final = $t_final seems OK
else
    echo $0 : T_final = $t_final seems NOT good
    exit 1
fi
