#!/bin/sh
# feram_modulation_maker_check.sh
##
if [ `ruby $srcdir/feram_modulation_maker.rb 16 16 16 0    2134567891 | awk '{m+=$4} END{print m;}'` -ne -32768 ]; then
    echo $0:$LINENO: Wrong modulation for ratio=0.00.
    exit 1
fi
if [ `ruby $srcdir/feram_modulation_maker.rb 16 16 16 0.25 2134567892 | awk '{m+=$4} END{print m;}'` -ne -16384 ]; then
    echo $0:$LINENO: Wrong modulation for ratio=0.25.
    exit 2
fi
if [ `ruby $srcdir/feram_modulation_maker.rb 16 16 16 0.50 2134567893 | awk '{m+=$4} END{print m;}'` -ne      0 ]; then
    echo $0:$LINENO: Wrong modulation for ratio=0.50.
    exit 3
fi
if [ `ruby $srcdir/feram_modulation_maker.rb 16 16 16 0.75 2134567894 | awk '{m+=$4} END{print m;}'` -ne  16384 ]; then
    echo $0:$LINENO: Wrong modulation for ratio=0.75.
    exit 4
fi
if [ `ruby $srcdir/feram_modulation_maker.rb 16 16 16 1    2134567896 | awk '{m+=$4} END{print m;}'` -ne  32768 ]; then
    echo $0:$LINENO: Wrong modulation for ratio=1.00.
    exit 5
fi
