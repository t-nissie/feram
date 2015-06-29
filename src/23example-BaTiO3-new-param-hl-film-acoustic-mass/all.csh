#!/usr/bin/csh -f
#@ class = qem
#@ output = $(job_name).$(jobid).$(stepid).out
#@ error  = $(job_name).$(jobid).$(stepid).err
#@ environment = COPY_ALL
#@ restart = no
#@ job_name = all
#@ notification = never
#@ job_type = serial
#@ stack_limit = 15360mb
#@ queue
# Usage: submit EM general -jcf all.csh
setenv MEMORY_AFFINITY MCM
setenv MALLOCMULTIHEAP true
setenv OMP_NUM_THREADS 32
setenv XLSMPOPTS spins=0:yields=0:parthds="32":stride=2:startproc=0
./feram *.feram
