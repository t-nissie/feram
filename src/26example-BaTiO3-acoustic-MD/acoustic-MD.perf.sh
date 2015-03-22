#!/bin/sh
# Usage: ./acoustic-MD.perf.sh 2> acoustic-MD.perf.err &
# If you get "WARNING: Kernel address maps (/proc/{kallsyms,modules}) are restricted,
# check /proc/sys/kernel/kptr_restrict.", you need to `echo 0 > /proc/sys/kernel/kptr_restrict`
# as a super user.
##
perf record -o acoustic-MD.vs.perf.data ./feram acoustic-MD.vs.feram
perf report -i acoustic-MD.vs.perf.data | head -n 200 > acoustic-MD.vs.perf.report
ln -sf acoustic-MD.vs.0000050000.coord acoustic-MD.lf.restart
perf record -o acoustic-MD.lf.perf.data ./feram acoustic-MD.lf.feram
perf report -i acoustic-MD.lf.perf.data | head -n 200 > acoustic-MD.lf.perf.report
