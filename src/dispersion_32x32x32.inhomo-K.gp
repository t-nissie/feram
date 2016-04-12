#!/usr/bin/env gnuplot
# dispersion_32x32x32.inhomo-K.gp
# Author: Takeshi Nishimatsu
# $Date: 2016-04-11 05:49:22 +0900 (Mon, 11 Apr 2016) $
# $Rev: 2767 $
# $Author: t-nissie $
##
call 'dispersion_32x32x32.param.gp'
### Common settings
#set title 'Phonon Dispersion of Simple Cubic Dipole Crystal'
set grid
set nokey
set xlabel '{/Times-Italic k}'
set xtics ('{/Symbol \107}'   0.000000000,\
           'X'                0.500000000,\
           'M'                1.000000000,\
           '{/Symbol \107}'   1.707106781,\
           'R'                2.573132185,\
           'X'                3.280238966,\
           'R'                3.987345747,\
           'M'                4.487345747)

#set yrange [-1.5:2]
set ylabel '{/Symbol w}'
#set ylabel '{/Symbol w} / sqrt( ({/Times-Italic Z}^{*2}/{/Times-Italic m}{/Symbol e_\245}) (4{/Symbol p}/3{/Times-Italic a}_@0^3) )'
call 'dispersion_axes.gp' '-0.5'

set terminal postscript eps enhanced solid color "Times-Roman" 22
set output "dispersion_32x32x32.inhomo-K.eps"
set title 'long-wavelength approximation of acoustic phonon branches in sc'
plot 0,\
'dispersion_32x32x32.inhomo-K.dat' using 1:( $5>0 ? sqrt($5) :-sqrt(-$5) ) w l,\
'dispersion_32x32x32.inhomo-K.dat' using 1:( $6>0 ? sqrt($6) :-sqrt(-$6) ) w l,\
'dispersion_32x32x32.inhomo-K.dat' using 1:( $7>0 ? sqrt($7) :-sqrt(-$7) ) w l

#Local variables:
#  compile-command: "make check TESTS='dispersion_check.sh dispersion_32x32x32.inhomo-K.gp'"
#End:
