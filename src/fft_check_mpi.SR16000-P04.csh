#!/usr/bin/csh
# Usage: submit EB general -largememory -jobtype parallel -n 4 -B -N -u t-nissie@imr.tohoku.ac.jp -exec fft_check_mpi.SR16000-P04.csh -J fft_check_mpi.SR16000-P04
##
setenv MEMORY_AFFINITY MCM
setenv MALLOCMULTIHEAP true
echo "#" `hostname`
poe ./Annabel_Lee 100  640  640  640 in
poe ./Annabel_Lee 200  640  640  640 in
poe ./Annabel_Lee 100  640  640  640 out
poe ./Annabel_Lee 200  640  640  640 out

poe ./Annabel_Lee 100 1024 1024 1024 in
poe ./Annabel_Lee 200 1024 1024 1024 in
poe ./Annabel_Lee 100 1024 1024 1024 out
poe ./Annabel_Lee 200 1024 1024 1024 out

poe ./Annabel_Lee 100 1280 1280 1280 in
poe ./Annabel_Lee 200 1280 1280 1280 in
poe ./Annabel_Lee 100 1280 1280 1280 out
poe ./Annabel_Lee 200 1280 1280 1280 out

poe ./Annabel_Lee  50 2048 2048 2048 in
poe ./Annabel_Lee 100 2048 2048 2048 in
poe ./Annabel_Lee  50 2048 2048 2048 out
poe ./Annabel_Lee 100 2048 2048 2048 out

poe ./Annabel_Lee  50 2560 2560 2560 in
poe ./Annabel_Lee 100 2560 2560 2560 in
#poe ./Annabel_Lee  50 2560 2560 2560 out
#poe ./Annabel_Lee 100 2560 2560 2560 out
