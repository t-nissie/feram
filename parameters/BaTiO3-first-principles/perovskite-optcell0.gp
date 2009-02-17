#!/usr/bin/env gnuplot
##
E_0 = -1.3184285821E+02

BOHR=0.52917720859
HARTREE=27.21138386

set terminal postscript portrait enhanced color 'Times-Roman,18'
set output 'perovskite-optcell0.eps'
set encoding iso_8859_1
set size 1.0,0.5

set format y '%.4f'
set xtics 0.02
set yrange [-0.0005:0.002]
set key left spacing 1.4
set ylabel '{/Times-Italic E}_{tot} - {/Times-Italic E}_{0} [eV]'
set xlabel '{/Times-Italic u} [\305]'

f001(x) = alpha*x**4 +  kappa001*x**2
fit f001(x) 'perovskite-optcell0-001.dat' using (sqrt($2**2+$3**2+$4**2)*BOHR):(($6-E_0)*HARTREE) via alpha, kappa001
f111(x) = agma3*x**4 +  kappa111*x**2
fit f111(x) 'perovskite-optcell0-111.dat' using (sqrt($2**2+$3**2+$4**2)*BOHR):(($6-E_0)*HARTREE) via agma3, kappa111

P_gamma = 3*(agma3-alpha)

plot        'perovskite-optcell0-001.dat' using (sqrt($2**2+$3**2+$4**2)*BOHR):(($6-E_0)*HARTREE) title '[001]' with p lt 1 ps 2,\
            f001(x) title '4th order func.' w l lt 1 lw 2,\
            'perovskite-optcell0-110.dat' using (sqrt($2**2+$3**2+$4**2)*BOHR):(($6-E_0)*HARTREE) title '[110]' with p lt 2 ps 2,\
            (alpha+1.0/4*P_gamma)*x**4 + (kappa001+kappa111)/2*x**2 title '{/Symbol k}{/Times-Italic u}^2+({/Symbol a}+{/Symbol g}/4){/Times-Italic u}^4' w l lt 2 lw 2,\
            'perovskite-optcell0-111.dat' using (sqrt($2**2+$3**2+$4**2)*BOHR):(($6-E_0)*HARTREE) title '[111]' with p lt 3 ps 2,\
            f111(x) title '4th order func.' w l lt 3 lw 2,\
            (kappa001+kappa111)/2*x**2 title '{/Symbol k}{/Times-Italic u}^2' w l lt 7 lw 1

print 'P_alpha = ',   alpha, ' [eV/Angstrom^4]'
print 'P_gamma = ', P_gamma, ' [eV/Angstrom^4]'
print 'average kappa = ', (kappa001+kappa111)/2, ' [eV/Angstrom^2]'

#set output
#!gs -q -sDEVICE=ppm -sPAPERSIZE=a4 -r90x90 -dSAFER -dNOPAUSE -dBATCH -sOutputFile=- -q perovskite-optcell0.eps | \
#                                                  pnmcrop -white | cjpeg -quality 90 > perovskite-optcell0.jpg

#Local variables:
#  compile-command: "gnuplot perovskite-optcell0.gp"
#End:
