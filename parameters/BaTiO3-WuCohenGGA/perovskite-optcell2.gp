#!/usr/bin/env gnuplot
##
E0=-1.3136340444E+02
a0=7.5323692530
B11 = 126.731671475652
B12 =  41.7582963902598
B44 =  49.2408864348646
PRESSURE=0.0

BOHR=0.52917720859
HARTREE=27.21138386

f_xx(x)=a_xx*x**2
f_xy(x)=a_xy*x**2
f_zz(x)=a_zz*x**2
fit f_xx(x) 'perovskite-optcell2-110-narrow.dat' using ($2*BOHR):($6*$11/a0-1) via a_xx
fit f_xy(x) 'perovskite-optcell2-110-narrow.dat' using ($2*BOHR):($6*$12/a0*2) via a_xy
fit f_zz(x) 'perovskite-optcell2-110-narrow.dat' using ($2*BOHR):($8/a0-1)     via a_zz

B1xx = -a_xx*4*B11+a_zz*2*(B11-2*B12)
B1yy = -a_xx*4*B12-a_zz*2*B11
B4yz = -2 * B44 * a_xy


kappa=-1.4
alphap=3.0
k4=30.0
E001(x) = kappa*x**2 + (alphap         )*x**4 + (k1             )*x**6 + k4*x**8
E110(x) = kappa*x**2 + (alphap+gammap/4)*x**4 + (k1+  k2/4      )*x**6 + k4*x**8
E111(x) = kappa*x**2 + (alphap+gammap/3)*x**4 + (k1+2*k2/9+k3/27)*x**6 + k4*x**8
fit E001(x)  'perovskite-optcell2-001-narrow.dat' using ($2*BOHR):(($4-E0)*HARTREE) via kappa,alphap,k1,k4
fit E110(x)  'perovskite-optcell2-110-narrow.dat' using ($2*BOHR):(($4-E0)*HARTREE) via gammap,k2
fit E111(x)  'perovskite-optcell2-111-narrow.dat' using ($2*BOHR):(($4-E0)*HARTREE) via k3

#gammap = (gammap110+gammap111)/2

B = B11 + 2*B12
mu_t = (B11-B12) / 2
mu_r = B44
C = B1xx + 2*B1yy
nu_t = (B1xx-B1yy) / 2
nu_r = B4yz
P_alpha = alphap + (C**2/B+4*nu_t**2/mu_t)/24
P_gamma = gammap - (nu_t**2/mu_t-nu_r**2/mu_r)/2

set terminal postscript portrait enhanced color 'Times-Roman,18'
set output 'perovskite-optcell2.eps'
set encoding iso_8859_1
set multiplot
set size 1,0.5
set format y '%.3f'
set format x '%.2f'
set xtics 0.1
set xrange [0:0.5]
set key left top

set origin 0.0, 0.5
set title 'BaTiO_3, Wu and Cohen, abinit-5.7.3, kpt 8x8x8, ecut=63.0, ecutsm=3.0'  font 'Times-Roman,14'
set ylabel 'strain'
set yrange [-0.05:0.05]
#set label 1 '(a)' at 0.01,-0.002 font "Times-Roman, 36"
plot 'perovskite-optcell2-110-narrow.dat' using ($2*BOHR):($6*$11/a0-1) title '{/Times-Italic e_{xx}}' w p lt 2 ps 1 pt 1,\
     f_xx(x) title ''               w l lt 2 lw 2,\
     'perovskite-optcell2-110-narrow.dat' using ($2*BOHR):($6*$12/a0*2) title '{/Times-Italic e_{xy}}' w p lt 2 ps 1 pt 2,\
     f_xy(x) title ''               w l lt 2 lw 2,\
     'perovskite-optcell2-110-narrow.dat' using ($2*BOHR):($8/a0-1)     title '{/Times-Italic e_{zz}}' w p lt 2 ps 1 pt 3,\
     f_zz(x) title 'quadratic fits' w l lt 2 lw 2

set origin 0.0, 0.0
set notitle
set xlabel '{/Times-Italic u} [\305]'
set ylabel '{/Times-Italic E} - {/Times-Italic E}^0 [eV]'
set ytics    0.05
set yrange [-0.05:0.20]
plot 'perovskite-optcell2-001.dat' using ($2*BOHR):(($4-E0)*HARTREE) title 'calculated [001]' with p lt 1 pt 4,\
     'perovskite-optcell2-110.dat' using ($2*BOHR):(($4-E0)*HARTREE) title 'calculated [110]' with p lt 2 pt 6,\
     'perovskite-optcell2-111.dat' using ($2*BOHR):(($4-E0)*HARTREE) title 'calculated [111]' with p lt 3 pt 8,\
     'perovskite-optcell2-001-narrow.dat' using ($2*BOHR):(($4-E0)*HARTREE) title '' with p lt 1 pt 5,\
     'perovskite-optcell2-110-narrow.dat' using ($2*BOHR):(($4-E0)*HARTREE) title '' with p lt 2 pt 7,\
     'perovskite-optcell2-111-narrow.dat' using ($2*BOHR):(($4-E0)*HARTREE) title '' with p lt 3 pt 9,\
      E001(x) title '{/Times-Italic E}_{001}({/Times-Italic u}) - {/Times-Italic E}^0' w l lt 1 lw 2,\
      E110(x) title '{/Times-Italic E}_{110}({/Times-Italic u}) - {/Times-Italic E}^0' w l lt 2 lw 2,\
      E111(x) title '{/Times-Italic E}_{111}({/Times-Italic u}) - {/Times-Italic E}^0' w l lt 3 lw 2

set nomultiplot
set output
!ps2pdf perovskite-optcell2.eps perovskite-optcell2.pdf
#!gs -q -sDEVICE=ppm -sPAPERSIZE=a4 -r90x90 -dSAFER -dNOPAUSE -dBATCH -sOutputFile=- -q difficult.eps | pnmcrop -white | cjpeg -quality 90 > difficult.jpg

print ''
print 'B1xx = ',   B1xx, ' [eV/Angstrom^2]'
print 'B1yy = ',   B1yy, ' [eV/Angstrom^2]'
print 'B4yz = ',   B4yz, ' [eV/Angstrom^2]'
print 'P_k1 = ', k1, ' [eV/Angstrom^6]'
print 'P_k2 = ', k2, ' [eV/Angstrom^6]'
print 'P_k3 = ', k3, ' [eV/Angstrom^6]'
print 'P_k4 = ', k4, ' [eV/Angstrom^8]'
print 'P_alpha = ', P_alpha, ' [eV/Angstrom^4]'
print 'P_gamma = ', P_gamma, ' [eV/Angstrom^4]'#, '   gammap110, gammap111 = ', gammap110, gammap111
print '#kappa = ',   kappa,    ' [eV/Angstrom^2]'

#Local variables:
#  compile-command: "gnuplot perovskite-optcell2.gp"
#End:
