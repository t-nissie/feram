#!/bin/sh
# defect-maker-check.sh
##
./defects_maker.rb 16 16 16 'rand 1.0' 1000 2134567890 > defects_maker_check.defects
gnuplot defects_maker_check.gp
test -z "`sort defects_maker_check.defects | colrm 15 | uniq -d`"
g
