#!/usr/bin/env gnuplot
# timingSC20.gp
# Author: Takeshi Nishimatsu
# $Date$
# $Rev$
# $Author$
##
set terminal postscript portrait enhanced color solid  "Times-Roman,24"
set output "timingSC20.eps"

f_max(x) = t1_max * ((1-p_max)+p_max/x)
t1_max = 1800
p_max  = 0.9
fit f_max(x) 'timingSC20.max' using 1:2 via t1_max,p_max

f_min(x) = t1_min * ((1-p_min)+p_min/x)
t1_min = 1800
p_min  = 0.9
fit f_min(x) 'timingSC20.min' using 1:2 via t1_min,p_min

f_X5690(x) = t1_X5690 * ((1-p_X5690)+p_X5690/x)
t1_X5690 = 1500
p_X5690  = 0.9
fit f_X5690(x) 'forward.X5690.r1224.dat' using 1:2 via t1_X5690,p_X5690

set lmargin 9
set tics front
set key spacing 1.5
set grid

set xrange [0:17]
set xtics (1,2,4,6,8,10,12,14,16)
set xlabel '{/Times-Italic N}_{thread}'

set yrange [0:2000]
set ytics 250
set ylabel '{/Times-Italic t} [s]'

tp_max   = sprintf("{/Times-Italic p}_{max} = %.3f"  , p_max)
tp_min   = sprintf("{/Times-Italic p}_{min} = %.3f"  , p_min)
tp_X5690 = sprintf("{/Times-Italic p}_{X5690} = %.3f", p_X5690)

plot 'timingSC20.dat' t '20 timing/{/Times-Italic N}_{thread}' w p lt 7 pt 4,\
     f_max(x)         t tp_max                                 w l lt 1 lw 3,\
     f_min(x)         t tp_min                                 w l lt 3 lw 3,\
     f_X5690(x)       t tp_X5690                               w l lt 2 lw 3,\
     'forward.X5690.r1224.dat' t "Xeon X5690\ngfortran, FFTW"  w p lt 2 pt 2 ps 2

set output
!epstopdf.pl timingSC20.eps

#Local variables:
#  compile-command: "gnuplot timingSC20.gp"
#End:
