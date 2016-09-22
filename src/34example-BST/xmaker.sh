#!/bin/sh
# xmaker.sh
# Time-stamp: <2016-07-18 18:25:31 takeshi>
# Author: Takeshi NISHIMATSU
##
for x in `seq -w 0.0 0.1 1.0`; do
    mkdir -p x$x
    ruby ../feram_modulation_maker.rb 32 32 32 $x > x$x/modulation
    sed -e 's/temperature"`/temperature + (0.5-xxx) * 6.0000"`/' -e "s/xxx/$x/" cooling.sh > x$x/cooling.sh
    sed -e 's/temperature"`/temperature + (0.5-xxx) * 6.0000"`/' -e "s/xxx/$x/" heating.sh > x$x/heating.sh
    chmod 755 x$x/cooling.sh
    chmod 755 x$x/heating.sh
    sed "s/xxx/$x/" cooling.csh > x$x/cooling.csh
    sed "s/xxx/$x/" heating.csh > x$x/heating.csh
    # cp wisdom x$x
    cp polarization-local.gp x$x
done
