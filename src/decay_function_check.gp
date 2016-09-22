#!/usr/bin/env gnuplot
# decay_function_check.gp
# plots decay functions for the Ewald sumation of dipoles.
# Author: Takeshi Nishimatsu
# $Date$
# $Rev$
# $Author$
##
Lz=16
a0=3.94
kappa=0.1125
inp=sprintf("< ./decay_function_check %.5f %d %.5f", a0, Lz, kappa)

set terminal postscript eps enhanced color 'Times-Roman' 20
set encoding iso_8859_1
set output 'decay_function_check.eps'

set grid
set key right spacing 1.4
set bmargin 4
set lmargin 16
set xlabel '{/Times-Italic r} / {/Times-Italic a}_0 ,'.\
        '   {/Times-Italic k} / (2{/Symbol p} / ({/Times-Italic La}_0))'
set ylabel '\305^{-3}'
set logscale y
set xtics Lz/2
set yrange [1e-70:1]
set xrange [0:Lz*1.5]
set ytics ("1"  1.0e0,\
           "10^{-10}" 1.0e-10,\
           "10^{-20}" 1.0e-20,\
           "10^{-30}" 1.0e-30,\
           "10^{-40}" 1.0e-40,\
           "10^{-50}" 1.0e-50,\
           "10^{-60}" 1.0e-60,\
           "10^{-70}" 1.0e-70)

set arrow 1 from -Lz/2,1e-22 to Lz/2,1e-22 heads lt 4 lw 2
set arrow 2 from     0,1e-52 to Lz,  1e-52 heads lt 7 lw 2
set label 1 'first Brillouin zone' at    0,1e-25 center textcolor lt 4
set label 2 'super cell size'      at Lz/2,1e-55 center textcolor lt 7

plot inp using 1:3 title '{/Times-Italic B}({/Times-Italic r}, {/Symbol k})'   with lp lw 3,\
     inp using 1:4 title '{/Times-Italic Crr}({/Times-Italic r}, {/Symbol k})' with lp lw 3,\
     exp(-(2*pi*x/(a0*Lz))**2 / kappa**2 )/a0**3\
     title 'exp(-{/Times-Italic k}^2/{/Symbol k}^2) / {/Times-Italic a}_0^3' with l lw 3
set output
#!epstopdf decay_function_check.eps
#Local variables:
#  compile-command: "gnuplot decay_function_check.gp"
#End:
