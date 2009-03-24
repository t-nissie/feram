#!/usr/bin/env gnuplot
# dipole-dipole.gp
# Time-stamp: <2009-03-24 22:34:22 takeshi>
# Author: Takeshi NISHIMATSU
##
set encoding iso_8859_1

set terminal postscript landscape enhanced color "Times-Roman" 21
set output "eigenvalues2j.eps"

set grid
set nokey

set ylabel 'eigenvalues of IFC matrix [eV / \305^2]'

set xlabel '{/Times-Italic k}'
set xtics ('{/Symbol \107}'   0.000000000,\
           'X'                0.500000000,\
           'M'                1.000000000,\
           ''                 1.353553391,\
           '{/Symbol \107}'   1.707106781,\
           'R'                2.573132185,\
           'X'                3.280238966,\
           'R'                3.987345747,\
           'M'                4.487345747)
axis_height = -6.3
set label 9991 'D' at 0.25                          ,axis_height center font      "Symbol,18"
set label 9992 'Z' at 0.75                          ,axis_height center font "Times-Roman,18"
set label 9993 'S' at 1.00+  sqrt(2.0)/4            ,axis_height center font      "Symbol,18"
set label 9994 'L' at 1.00+  sqrt(2.0)/2+sqrt(3.0)/4,axis_height center font      "Symbol,18"
set label 9995 'S' at 1.00+3*sqrt(2.0)/4+sqrt(3.0)/2,axis_height center font "Times-Roman,18"
set label 9996 'S' at 1.00+5*sqrt(2.0)/4+sqrt(3.0)/2,axis_height center font "Times-Roman,18"
set label 9997 'T' at 1.25+3*sqrt(2.0)/2+sqrt(3.0)/2,axis_height center font "Times-Roman,18"

plot 0 w l lt 2,\
'bulk32x32x32.dipole-dipole-long+short.dat' using 1:($5) w l lt 1 lw 3,\
'bulk32x32x32.dipole-dipole-long+short.dat' using 1:($6) w l lt 1 lw 3,\
'bulk32x32x32.dipole-dipole-long+short.dat' using 1:($7) w l lt 1 lw 3

#Local variables:
#  compile-command: "gnuplot eigenvalues2j.gp && kill -HUP `pgrep gv`"
#End:
