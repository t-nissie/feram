#!/usr/bin/env gnuplot
# Time-stamp: <2005-09-16 12:34:14 t-nissie>
# Author: Takeshi NISHIMATSU
##
set terminal postscript landscape enhanced solid color 'Times-Roman' 22
set xlabel 'Temperature [K]'
set ylabel 'Strain'
set output 'strain.ps'
set key 35,0.0055
set grid

plot 'strain.avg' using 1:2 title '{/Symbol h}_1' w lp,\
     'strain.avg' using 1:3 title '{/Symbol h}_2' w lp,\
     'strain.avg' using 1:4 title '{/Symbol h}_3' w lp
#!/usr/bin/env gnuplot
# Time-stamp: <2005-09-14 08:18:39 t-nissie>
# Author: Takeshi NISHIMATSU
# Purpose: Check energy conservation
##
set terminal postscript landscape enhanced solid color 'Times-Roman' 22
set xlabel 'Temperature [K]'
set ylabel 'Strain'
set output 'strain.ps'
set key 45,0.0055
set grid

plot 'strain.avg' using 1:2 title '{/Symbol h}_1' w lp,\
     'strain.avg' using 1:3 title '{/Symbol h}_2' w lp,\
     'strain.avg' using 1:4 title '{/Symbol h}_3' w lp
#Local variables:
#  compile-command: "gnuplot strain.gp && kill -HUP `pgrep gv`"
#End:
