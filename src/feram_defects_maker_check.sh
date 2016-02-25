#!/bin/sh
# defect_maker_check.sh
##
ruby $srcdir/feram_defects_maker.rb 30 31 32 'rand 1.0' 20000 2134567890 > feram_defects_maker_check.defects
gnuplot -e 'basename="feram_defects_maker_check"; binwidth=0.1' $srcdir/feram_defects_maker_check.gp
gnuplot -e 'basename="feram_defects_maker_check"; binwidth=1.8' $srcdir/feram_defects_maker_check_sphere.gp
epstopdf feram_defects_maker_check.eps
epstopdf feram_defects_maker_check_sphere.eps
test -z "`sort feram_defects_maker_check.defects | cut -b -15 | uniq -d`"
