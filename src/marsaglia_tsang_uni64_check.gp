#!/usr/bin/env gnuplot
# marsaglia_tsang_uni64_check.gp
# Author: Takeshi Nishimatsu
# $Date: 2012-07-06 21:27:09 +0900 (金, 06  7 2012) $
# $Rev: 1340 $
# $Author: t-nissie $
##
set terminal postscript portrait enhanced color solid  "Times-Roman,20"
set output 'marsaglia_tsang_uni64_check.eps'
set title '10^7 samples'
set xrange [0:100]
set xtics 10
set yrange [0:450000]
set ytics 50000
set grid

plot 'marsaglia_tsang_uni64_check.dat' title 'data' w points,\
     1.0e7/sqrt(2*pi*10.0**2)*exp(-(x-50.0)**2/(2*10.0**2)) \
     title '10^7 {/Times-Italic N}({/Symbol m}=50, {/Symbol s}^2=10^2)'


set output
print 'marsaglia_tsang_uni64_check.eps is generated.'
#!epstopdf.pl marsaglia_tsang_uni64_check.eps

#Local variables:
#  compile-command: "gnuplot marsaglia_tsang_uni64_check.gp"
#End:
