#!/usr/bin/env gnuplot
##
E_0 = -1.3184285821E+02

a0 = 7.4434230817
B11 = 135.613652996909
B12 =  45.734101469876
B44 =  51.202683759012

P_alpha = 93.3748737880548
P_gamma = -133.80460557674
kappa = -0.293062714445983


BOHR=0.52917720859
HARTREE=27.21138386

set terminal postscript portrait enhanced color 'Times-Roman,18'
set output 'perovskite-optcell2.eps'
set encoding iso_8859_1
set multiplot

#set rmargin 13.5
set format y '%.4f'
set xtics 0.02
set xlabel '{/Times-Italic u} [\305]'

set size 1,0.5

f_xx(x)=a_xx*x**2
f_xy(x)=a_xy*x**2
f_zz(x)=a_zz*x**2
fit f_xx(x) 'perovskite-optcell2-110.dat' using (sqrt($2**2+$3**2+$4**2)*BOHR):($8*$13/a0-1) via a_xx
fit f_xy(x) 'perovskite-optcell2-110.dat' using (sqrt($2**2+$3**2+$4**2)*BOHR):($8*$14/a0*2) via a_xy
fit f_zz(x) 'perovskite-optcell2-110.dat' using (sqrt($2**2+$3**2+$4**2)*BOHR):($10/a0-1)    via a_zz

B1xx = -a_xx*4*B11+a_zz*2*(B11-2*B12)
B1yy = -a_xx*4*B12-a_zz*2*B11
B4yz = -2 * B44 * a_xy
B = B11 + 2*B12
mu_t = (B11-B12) / 2
mu_r = B44
C = B1xx + 2*B1yy
nu_t = (B1xx-B1yy) / 2
nu_r = B4yz
alpha_p = P_alpha - (C**2/B+4*nu_t**2/mu_t)/24
gamma_p = P_gamma + (nu_t**2/mu_t-nu_r**2/mu_r)/2


set origin 0.0, 0.5
set key left
set ylabel 'strain'
set label 1 '(a)' at 0.01,-0.002 font "Times-Roman, 36"
plot 'perovskite-optcell2-110.dat'        using (sqrt($2**2+$3**2+$4**2)*BOHR):($8*$13/a0-1) title '{/Times-Italic e_{xx}}' w p lt 2 ps 2 pt 4,\
     f_xx(x) title 'quadratic fit' w l lt 2 lw 2,\
     'perovskite-optcell2-110.dat'        using (sqrt($2**2+$3**2+$4**2)*BOHR):($8*$14/a0*2) title '{/Times-Italic e_{xy}}' w p lt 2 ps 2 pt 6,\
     f_xy(x) title 'quadratic fit' w l lt 2 lw 2,\
     'perovskite-optcell2-110.dat'        using (sqrt($2**2+$3**2+$4**2)*BOHR):($10/a0-1)    title '{/Times-Italic e_{zz}}' w p lt 2 ps 2 pt 8,\
     f_zz(x) title 'quadratic fit' w l lt 2 lw 2

set origin 0.0, 0.0
set key -0.03,0.0028 spacing 1.4
set ylabel '{/Times-Italic E}_{tot} - {/Times-Italic E}_{0} [eV]'
set yrange [-0.001:0.003]
set label 1 '(b)' at 0.01,-0.0006 font "Times-Roman, 36"
plot 'perovskite-optcell2-001.dat'        using (sqrt($2**2+$3**2+$4**2)*BOHR):(($6-E_0)*HARTREE) title '[001]' w p ps 1 lt 1,\
     kappa*x**2 + alpha_p*x**4             title '{/Symbol k}{/Times-Italic u}^2+{/Symbol a\242}{/Times-Italic u}^4' w l lt 1,\
     'perovskite-optcell2-110.dat'        using (sqrt($2**2+$3**2+$4**2)*BOHR):(($6-E_0)*HARTREE) title '[110]' w p ps 1 lt 2,\
     kappa*x**2 + (alpha_p+gamma_p/4)*x**4 title '{/Symbol k}{/Times-Italic u}^2+({/Symbol a\242}+{/Symbol g\242}/4){/Times-Italic u}^4' w l lt 2,\
     'perovskite-optcell2-111.dat'        using (sqrt($2**2+$3**2+$4**2)*BOHR):(($6-E_0)*HARTREE) title '[111]' w p ps 1 lt 3,\
     kappa*x**2 + (alpha_p+gamma_p/3)*x**4 title '{/Symbol k}{/Times-Italic u}^2+({/Symbol a\242}+{/Symbol g\242}/3){/Times-Italic u}^4' w l lt 3

print 'B1xx = ',   B1xx, ' [eV/Angstrom^2]'
print 'B1yy = ',   B1yy, ' [eV/Angstrom^2]'
print 'B4yz = ',   B4yz, ' [eV/Angstrom^2]'

#set nomultiplot
#set output
#!gs -q -sDEVICE=ppm -sPAPERSIZE=a4 -r90x90 -dSAFER -dNOPAUSE -dBATCH -sOutputFile=- -q perovskite-optcell2.eps | \
#                                                  pnmcrop -white | cjpeg -quality 90 > perovskite-optcell2.jpg

#Local variables:
#  compile-command: "gnuplot perovskite-optcell2.gp 2>&1 | tail -3"
#End:
