#!/bin/sh
# feram_cross_section_check.sh
##
ln -s zzz16.param.gp param.gp
$srcdir/feram_cross_section_q.sh zzz16.0000000060.coord
rm -f param.gp
if [ ! -r zzz16.0000000060-q-x.eps ]; then
    echo $0:$LINENO: cannot find zzz16.0000000060-q-x.eps
    exit 1
fi
