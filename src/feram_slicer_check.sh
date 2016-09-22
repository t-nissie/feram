#!/bin/sh
# feram_slicer_check.sh
##
ruby $srcdir/feram_slicer.rb zzz16.0000000060.coord 8
if [ ! -r zzz16.0000000060-slice-z008.eps ]; then
    echo $0:$LINENO: cannot find zzz16.0000000060-slice-z008.eps
    exit 1
fi
