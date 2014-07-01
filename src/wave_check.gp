#!/usr/bin/env gnuplot
# wave_check.gp
# Author: Takeshi Nishimatsu
# $Date: 2012-07-06 21:27:09 +0900 (金, 06  7 2012) $
# $Rev: 1340 $
# $Author: t-nissie $
##
set terminal postscript portrait enhanced color dashed "Times-Roman,20"
set output 'wave_check.eps'
set title 'wave\_check.f checks wave\_module.F'
set xtics 4
set grid
set key bottom left

plot 'wave_check.dat' using 1:2  title 'triangular\_sin' with linespoints,\
     'wave_check.dat' using 1:5  title 'triangular\_cos' with linespoints,\
     'wave_check.dat' using 1:8  title 'ramping\_on'     with linespoints,\
     'wave_check.dat' using 1:11 title 'ramping\_off'    with linespoints

set output
print 'wave_check.eps is generated.'
#!epstopdf.pl wave_check.eps

#Local variables:
#  compile-command: "gnuplot wave_check.gp"
#End:
