#!/usr/bin/csh
# Usage: submit SC general -pt 16 -exec heating.csh -J heating-xxx
##
setenv MEMORY_AFFINITY MCM
setenv MALLOCMULTIHEAP true
setenv XLSMPOPTS spins=0:yields=0
hostname
./heating.sh
