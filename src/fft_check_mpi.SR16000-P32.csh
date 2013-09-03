#!/usr/bin/csh
# Usage: submit ED general -largememory -jobtype parallel -n 32 -B -N -u t-nissie@imr.tohoku.ac.jp -exec fft_check_mpi.SR16000-P32.csh -J fft_check_mpi.SR16000-P32
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
poe ./Annabel_Lee  10 5120 5120 5120 out
poe ./Annabel_Lee  20 5120 5120 5120 out

poe ./Annabel_Lee  10 6144 6144 6144 in
poe ./Annabel_Lee  20 6144 6144 6144 in
# poe ./Annabel_Lee  10 6144 6144 6144 out
# poe ./Annabel_Lee  20 6144 6144 6144 out

# poe ./Annabel_Lee  10 7168 7168 7168 in
# poe ./Annabel_Lee  20 7168 7168 7168 in
# poe ./Annabel_Lee  10 7168 7168 7168 out
# poe ./Annabel_Lee  20 7168 7168 7168 out

# poe ./Annabel_Lee  10 8192 8192 8192 in
# poe ./Annabel_Lee  20 8192 8192 8192 in
# poe ./Annabel_Lee  10 8192 8192 8192 out
# poe ./Annabel_Lee  20 8192 8192 8192 out
