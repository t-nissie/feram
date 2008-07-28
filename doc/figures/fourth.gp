#!/usr/bin/env gnuplot
# Time-stamp: <2008-07-28 21:59:39 takeshi>
# Author: Takeshi NISHIMATSU
##
set bmargin 4
set grid
set xrange [-2.0:2]
set yrange [-5.5:2]
set xlabel '{/Times-Italic u_{/Symbol a}}'
set ylabel '{/Times-Italic V}^{self}({/Times-Italic u_{/Symbol a}})'
set xtics 10
set ytics 10

set label 1 "Without positive higher order terms,\nthe crystal will break down."\
at 0, -3 center font "Helvetica,34" front textcolor lt 1
set arrow 1 from   0.97,  -2.3 to  1.4, -5 head lt 1 lw 3
set arrow 2 from  -0.97,  -2.3 to -1.4, -5 head lt 1 lw 3

set terminal postscript landscape enhanced color 'Times-Roman' 30
set output 'fourth.eps'
plot -3*x**2+x**4 title 'fourth order'   lt 2 lw 3,\
     -3*x**2      title 'quadratic only' lt 1 lw 3

# close file
set output

# then white background
! ./epswhitebg.pl fourth.eps > fourth-white.eps

#Local variables:
#  compile-command: "gnuplot fourth.gp && kill -HUP `pgrep gv`"
#End:
