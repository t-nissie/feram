#!/bin/csh
# Usage: submit EB general -exec all.csh -J all
##
# For IBM XL Fortran
setenv MALLOCMULTIHEAP true
if (! ${?XLSMPOPTS}) then
    setenv XLSMPOPTS "spins=0:yields=0"
endif
./feram Lz064gap_id0film100K.feram \
        Lz128gap_id2film100K.feram \
        Lz256gap_id2film100K.feram \
        Lz512gap_id2film100K.feram
