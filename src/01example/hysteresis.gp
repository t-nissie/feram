#!/usr/bin/env gnuplot
# hysteresis.gp
# Time-stamp: <2007-12-14 11:54:03 takeshi>
# Author: Takeshi NISHIMATSU
##
set encoding iso_8859_1
set terminal postscript portrait enhanced solid color 'Times-Roman' 16
set output 'hysteresis.ps'
set xrang [-2000:2000]
set yrang [-0.2:0.2]
set xlabel '{/Times-Italic E} [kV/cm]'
set ylabel '{/Times-Italic u_z} [\305]'
plot '< grep avg%polarization externalE.avg' using ( $4*100000.0):( $8)\
     title '16{/Symbol \264}16{/Symbol \264}({/Times-Italic l}=15, {/Times-Italic d}=1), {/Times-Italic T} = 100 K'\
     w lp lt 1,\
     '< grep avg%polarization externalE.avg' using (-$4*100000.0):(-$8) title ''\
     w lp lt 1,\
     0 title '' w l lt 9,\
     '< (echo 0 -0.2; echo 0 0.2)'  title '' w l lt 9
#Local variables:
#  compile-command: "gnuplot hysteresis.gp && kill -HUP `pgrep gv`"
#End:
