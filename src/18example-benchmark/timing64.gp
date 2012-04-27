#!/usr/bin/env gnuplot
# forward.SR16000.r1204.gp: Plot results of forward.feram benchmark.
# Author: Takeshi Nishimatsu
# $Date: 2012-04-20 14:26:51 +0900 (金, 20  4 2012) $
# $Rev: 1201 $
# $Author: t-nissie $
#
#  $ for p in 18example-ConsumableCpus??/pm*; do pmpr $p > $p.txt; done
#  $ grep 'CPU time              ' 18example-ConsumableCpus??/pm*.txt   |  sed -e 's/.*: //' -e 's/\[s\]//'  | nl                                 > 18example-ConsumableCpus64/timing_total.dat
#  $ grep 'FFT_3D(../../src/fft.F' 18example-ConsumableCpus??/pm*.txt                                        | sed -e 's/.*\[  1\] //' | cut -c-9 > 18example-ConsumableCpus64/timing_fft.dat
#  $ grep 'OPTIMIZE_INHO_STRAIN(../../src/optimize-inho-strain.F' 18example-ConsumableCpus??/pm*.txt pm*.txt | sed -e 's/.*\[  2\] //' | cut -c-9 > 18example-ConsumableCpus64/timing_osi.dat
#  $ cd 18example-ConsumableCpus64/timing_osi.dat
#  $ paste timing64.dat timing_fft_3d.dat timing_osi.dat > timing64.dat
#
##
set terminal postscript portrait enhanced color solid  "Times-Roman,24"
set output "forward.SR16000.r1204.eps"
datafile = 'forward.SR16000.r1204.dat'
set multiplot

f_total(x) = t1_total * ((1-p_total)+p_total/x)
t1_total = 2000
p_total  = 0.9
fit f_total(x) datafile using 1:2 via t1_total,p_total

f_fft3d(x) = t1_fft3d * ((1-p_fft3d)+p_fft3d/x)
t1_fft3d = 744
p_fft3d  = 0.9
fit f_fft3d(x) datafile using 1:3 via t1_fft3d,p_fft3d

f_ois(x) = t1_ois * ((1-p_ois)+p_ois/x)
t1_ois = 300
p_ois  = 0.9
fit f_ois(x) datafile using 1:4 via t1_ois,p_ois

set xrange [0:65]
set tics front
set xtics (1,4,8,16,24,32,40,48,56,64)
set lmargin 9

set origin 0.0,0.6
set size 1.0,0.4
set yrange [0:2000]
set ylabel '{/Times-Italic t} [s]'
width=7
plot datafile using 1:2       t 'others'      w impuls lt 2 lw width,\
     datafile using 1:($3+$4) t 'opt.\_inho.' w impuls lt 3 lw width,\
     datafile using 1:3       t 'fft3d'       w impuls lt 1 lw width

set origin 0.0,0.0
#set size square
set size 1.0,0.64
set yrange [0:65]
set ytics 8
set xlabel '{/Times-Italic N}_{thread}'
set ylabel 'speed up'
set key left
tp_total=sprintf("{/Times-Italic p} = %.3f", p_total)
tp_fft3d=sprintf("{/Times-Italic p} = %.3f", p_fft3d)
tp_ois=sprintf("{/Times-Italic p} = %.3f", p_ois)
plot      x t 'ideal' w l lt 5 lw 1,\
          datafile using 1:(t1_total/$2)  t 'total'        w p lt 7 lw 1 ps 1 pt 4,\
          1.0 / ((1-p_total)+p_total/x)   t tp_total       w l lt 7 lw 2,\
          datafile using 1:(t1_fft3d/$3)  t 'fft3d'        w p lt 1 lw 1 ps 1,\
          1.0 / ((1-p_fft3d)+p_fft3d/x)   t tp_fft3d       w l lt 1 lw 2,\
          datafile using 1:(t1_ois/$4)    t 'opt.\_inho.'  w p lt 3 lw 1 ps 1,\
          1.0 / ((1-p_ois)+p_ois/x)       t tp_ois         w l lt 3 lw 2

set nomultiplot
set output
!epstopdf.pl forward.SR16000.r1204.eps

#Local variables:
#  compile-command: "gnuplot forward.SR16000.r1204.gp"
#End:
