#!/bin/sh
# feram_transition_check.sh
##
result=`ruby $srcdir/feram_transition_detector.rb 0.05 $srcdir/21example-KNbO3/*ing.avg |\
        grep Tc | ruby $srcdir/feram_transition_sorter.rb`
if [ "$result" != "136.00 216.00   278.00 370.00   694.00 714.00" ]; then
    echo $0:$LINENO: Could not detect Tc correctly. The result was "$result".
    exit 1
fi
