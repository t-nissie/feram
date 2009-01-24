#!/usr/bin/env gnuplot
##
E_0 = -1.3184285700E+02
a0 = 7.4434230817

BOHR=0.52917720859
HARTREE=27.2116

set terminal postscript portrait enhanced color 'Times-Roman,18'
set output 'perovskite-optcell2.eps'
set encoding iso_8859_1
set multiplot

set lmargin 12
#set rmargin 13.5
set format y '%.4f'
set xtics 0.05
set key left
set ylabel '{/Times-Italic E}_{tot} - {/Times-Italic E}_{0} [eV]'
set xlabel '{/Times-Italic u} [\305]'

set size 1,0.5

f_xx(x)=a_xx*x**2
f_xy(x)=a_xy*x**2
f_zz(x)=a_zz*x**2
fit f_xx(x) 'perovskite-optcell2-110.dat' using (sqrt($2**2+$3**2+$4**2)*BOHR):($8*$13/a0-1) via a_xx
fit f_xy(x) 'perovskite-optcell2-110.dat' using (sqrt($2**2+$3**2+$4**2)*BOHR):($8*$14/a0*2) via a_xy
fit f_zz(x) 'perovskite-optcell2-110.dat' using (sqrt($2**2+$3**2+$4**2)*BOHR):($10/a0-1)    via a_zz

set origin 0.0, 0.5
plot 'perovskite-optcell2-110.dat'        using (sqrt($2**2+$3**2+$4**2)*BOHR):($8*$13/a0-1) title '{/Times-Italic e_{xx}}' w p lt 2 ps 2 pt 4,\
     f_xx(x) title 'quadratic fit' w l lt 2 lw 2,\
     'perovskite-optcell2-110.dat'        using (sqrt($2**2+$3**2+$4**2)*BOHR):($8*$14/a0*2) title '{/Times-Italic e_{xy}}' w p lt 2 ps 2 pt 6,\
     f_xy(x) title 'quadratic fit' w l lt 2 lw 2,\
     'perovskite-optcell2-110.dat'        using (sqrt($2**2+$3**2+$4**2)*BOHR):($10/a0-1)    title '{/Times-Italic e_{zz}}' w p lt 2 ps 2 pt 8,\
     f_zz(x) title 'quadratic fit' w l lt 2 lw 2

set origin 0.0, 0.0
plot 'perovskite-optcell2-001.dat'        using (sqrt($2**2+$3**2+$4**2)*BOHR):(($6-E_0)*HARTREE) title '[001]' w lp ps 2 lt 1,\
     'perovskite-optcell2-110.dat'        using (sqrt($2**2+$3**2+$4**2)*BOHR):(($6-E_0)*HARTREE) title '[110]' w lp ps 2 lt 2,\
     'perovskite-optcell2-111.dat'        using (sqrt($2**2+$3**2+$4**2)*BOHR):(($6-E_0)*HARTREE) title '[111]' w lp ps 2 lt 3

# print 'P_alpha = ',   alpha, ' [eV/Angstrom^4]'
# print 'P_gamma = ', P_gamma, ' [eV/Angstrom^4]'

#Local variables:
#  compile-command: "gnuplot perovskite-optcell2.gp"
#End:
