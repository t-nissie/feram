#!/usr/bin/csh
# Usage: submit ED general -largememory -jobtype parallel -n 16 -B -N -u t-nissie@imr.tohoku.ac.jp -exec fft_check_mpi.SR16000-P16.csh -J fft_check_mpi.SR16000-P16
##
setenv MEMORY_AFFINITY MCM
setenv MALLOCMULTIHEAP true
echo "#" `hostname`
poe ./Annabel_Lee 100 1024 1024 1024 in
poe ./Annabel_Lee 200 1024 1024 1024 in
poe ./Annabel_Lee 100 1024 1024 1024 out
poe ./Annabel_Lee 200 1024 1024 1024 out

poe ./Annabel_Lee  50 2048 2048 2048 in
poe ./Annabel_Lee 100 2048 2048 2048 in
poe ./Annabel_Lee  50 2048 2048 2048 out
poe ./Annabel_Lee 100 2048 2048 2048 out

poe ./Annabel_Lee  50 2560 2560 2560 in
poe ./Annabel_Lee 100 2560 2560 2560 in
poe ./Annabel_Lee  50 2560 2560 2560 out
poe ./Annabel_Lee 100 2560 2560 2560 out

poe ./Annabel_Lee  50 3072 3072 3072 in
poe ./Annabel_Lee 100 3072 3072 3072 in
poe ./Annabel_Lee  50 3072 3072 3072 out
poe ./Annabel_Lee 100 3072 3072 3072 out

poe ./Annabel_Lee  10 4096 4096 4096 in
poe ./Annabel_Lee  20 4096 4096 4096 in
poe ./Annabel_Lee  10 4096 4096 4096 out
poe ./Annabel_Lee  20 4096 4096 4096 out

poe ./Annabel_Lee  10 5120 5120 5120 in
poe ./Annabel_Lee  20 5120 5120 5120 in
# poe ./Annabel_Lee  10 5120 5120 5120 out
# poe ./Annabel_Lee  20 5120 5120 5120 out

# poe ./Annabel_Lee  10 6144 6144 6144 in
# poe ./Annabel_Lee  20 6144 6144 6144 in
# poe ./Annabel_Lee  10 6144 6144 6144 out
# poe ./Annabel_Lee  20 6144 6144 6144 out
