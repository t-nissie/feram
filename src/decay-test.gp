#!/usr/bin/env gnuplot
# decay-test.gp     2005-08-05   NISHIMATSU Takeshi
##
call 'param.gp'

!echo `grep a0 param.gp | sed 's/^.* =//'` `grep Lz param.gp | sed 's/^.* =//'` `grep 'kappa ' param.gp | sed 's/^.* =//'` | ./decay-test > decay-test.dat

set terminal postscript landscape enhanced color 'Times-Roman' 22
set output 'decay-test.ps'

set grid
#set key -21, 1e-30
set key right spacing 1.4
set bmargin 4
set lmargin 14
#set rmargin 15
#set title "{/Times-Italic a}_0 = 4.0 @^{/Symbol \ \260}A, {/Times-Italic L} = 32, {/Symbol k} = 0.08"
set xlabel '{/Times-Italic r / a}_0 ,  {/Times-Italic k /} (2{/Symbol p} {/Times-Italic / La}_0)'
set ylabel '@^{/Symbol \ \260}A^{-3}'
set logscale y
set xtics Lz/2
set yrange [1e-90:1]
set xrange [0:Lz*1.5]

set arrow 1 from -Lz/2,1e-43 to Lz/2,1e-43 heads lt 4 lw 2
set arrow 2 from     0,1e-53 to Lz,  1e-53 heads lt 7 lw 2

set label 1 'first Brillouin zone' at    0,1e-45 center textcolor lt 4
set label 2 'super cell size'      at Lz/2,1e-55 center textcolor lt 7

plot 'decay-test.dat' using 1:3 title '{/Times-Italic B}({/Times-Italic r})'   with lp lw 1,\
     'decay-test.dat' using 1:4 title '{/Times-Italic Crr}({/Times-Italic r})' with lp lw 1,\
exp(-(2*pi*x/(a0*Lz))**2 / kappa**2 )/a0**3\
                   title 'exp(-{/Times-Italic k}^2/{/Symbol k}^2) / {/Times-Italic a}_0^3'

#Local variables:
#  compile-command: "gnuplot decay-test.gp && kill -HUP `pgrep gv`"
#End:
