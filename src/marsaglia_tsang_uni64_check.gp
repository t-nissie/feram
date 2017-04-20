#!/usr/bin/env gnuplot
# marsaglia_tsang_uni64_check.gp
# Author: Takeshi Nishimatsu
# $Date: 2012-07-06 21:27:09 +0900 (金, 06  7 2012) $
# $Rev: 1340 $
# $Author: t-nissie $
##
if ("`ls -1 marsaglia_tsang_uni64_check.dat`" ne 'marsaglia_tsang_uni64_check.dat') {
        marsaglia_tsang_uni64_check.gp: cannot find marsaglia_tsang_uni64_check.dat
}

set terminal postscript eps enhanced color solid  "Times-Roman,30"
set size 1.0,2.0
set output 'marsaglia_tsang_uni64_check.eps'
set title '10^7 samples'
set xrange [0:100]
set xtics 10
set yrange [0:500000]
set ytics 50000
set grid
set key spacing 1.5
set arrow 1 from 40,0 to 70,400000 nohead
set arrow 2 from 90,0 to 70,400000 nohead

plot 'marsaglia_tsang_uni64_check.dat' using 1:3 title 'triangular' w points,\
     '' title 'data' w points,\
     1.0e7/sqrt(2*pi*10.0**2)*exp(-(x-50.0)**2/(2*10.0**2)) \
     title '10^7 {/Times-Italic N}({/Symbol m}=50, {/Symbol s}^2=10^2)'

set output
print 'marsaglia_tsang_uni64_check.eps is generated.'
!epstopdf marsaglia_tsang_uni64_check.eps

#Local variables:
#  compile-command: "gnuplot marsaglia_tsang_uni64_check.gp"
#End:
