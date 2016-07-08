#!/usr/bin/env gnuplot
# perovskite-phonon.gp
# Time-stamp: <2016-07-08 10:16:07 t-nissie>
# Author: Takeshi NISHIMATSU
# Howto:
#    SOMEWHERE/abinit-8.0.8/src/98_main/mrgddb < perovskite-mrgddb.files
#    SOMEWHERE/abinit-8.0.8/src/98_main/anaddb < perovskite-anaddb.files
#    gnuplot perovskite-phonon.dat
##
set terminal postscript eps enhanced color "Times-Roman,30"
set encoding iso_8859_1
set output 'perovskite-phonon.eps'
set nokey
set xlabel '{/Times-Italic k}'
set grid xtics
set xtics ('{/Symbol \107}'   0.000000000,\
           'X'                0.500000000,\
           'M'                1.000000000,\
           '{/Symbol \107}'   1.0+  sqrt(2.0)/2,\
           'R'                1.0+  sqrt(2.0)/2+sqrt(3.0)/2,\
           'X'                1.0+  sqrt(2.0)  +sqrt(3.0)/2,\
           'R'                1.0+3*sqrt(2.0)/2+sqrt(3.0)/2,\
           'M'                1.5+3*sqrt(2.0)/2+sqrt(3.0)/2)
offset = -0.0007
set label 9991 'D' at 0.25                          ,offset center font      "Symbol,24"
set label 9992 'Z' at 0.75                          ,offset center font "Times-Roman,24"
set label 9993 'S' at 1.00+  sqrt(2.0)/4            ,offset center font      "Symbol,24"
set label 9994 'L' at 1.00+  sqrt(2.0)/2+sqrt(3.0)/4,offset center font      "Symbol,24"
set label 9995 'S' at 1.00+3*sqrt(2.0)/4+sqrt(3.0)/2,offset center font "Times-Roman,24"
set label 9996 'S' at 1.00+5*sqrt(2.0)/4+sqrt(3.0)/2,offset center font "Times-Roman,24"
set label 9997 'T' at 1.25+3*sqrt(2.0)/2+sqrt(3.0)/2,offset center font "Times-Roman,24"
plot 0 w l lt 2,\
'< paste perovskite-k.points perovskite-anaddb.out_B2EPS.freq'\
   using 4:5  w l lt 1,\
'' using 4:6  w l lt 1,\
'' using 4:7  w l lt 1,\
'' using 4:8  w l lt 1,\
'' using 4:9  w l lt 1,\
'' using 4:10 w l lt 1,\
'' using 4:11 w l lt 1,\
'' using 4:12 w l lt 1,\
'' using 4:13 w l lt 1,\
'' using 4:14 w l lt 1,\
'' using 4:15 w l lt 1,\
'' using 4:16 w l lt 1,\
'' using 4:17 w l lt 1,\
'' using 4:18 w l lt 1,\
'' using 4:19 w l lt 1
set output
!epstopdf perovskite-phonon.eps
#Local variables:
#  compile-command: "gnuplot perovskite-phonon.gp"
#End:
