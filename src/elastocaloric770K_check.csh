#!/usr/bin/csh -f
#@ class = qem
#@ output = $(job_name).$(jobid).$(stepid).out
#@ error  = $(job_name).$(jobid).$(stepid).err
#@ environment = COPY_ALL
#@ restart = no
#@ job_name = elastocaloric770K_check
#@ notification = never
#@ job_type = serial
#@ stack_limit = 15360mb
#@ queue
# Usage: submit EM general -jcf elastocaloric770K_check.csh
setenv MEMORY_AFFINITY MCM
setenv HF_ERR_STATUS_MODE 1
setenv MALLOCMULTIHEAP true
setenv OMP_NUM_THREADS 32
setenv XLSMPOPTS spins=0:yields=0:parthds="32":stride=2:startproc=0

if (!(-f       elastocaloric770K_check.vs.feram)) then
    cp $srcdir/elastocaloric770K_check.vs.feram .
    cp $srcdir/elastocaloric770K_check.lf.feram .
endif

./feram elastocaloric770K_check.vs.feram elastocaloric770K_check.lf.feram

if (-f /opt/freeware/bin/bc) then
    set bc=/opt/freeware/bin/bc
else
    set bc=bc
endif

set t_final=`colrm 8 < elastocaloric770K_check.lf.avg`
if ((`echo "691.00 < $t_final" | $bc` == 1) && (`echo "$t_final < 695.00" | $bc` == 1)) then
    echo $0 : T_final = $t_final seems OK
else
    echo $0 : T_final = $t_final seems NOT good
    exit 1
endif
