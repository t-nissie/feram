#!/usr/bin/env gnuplot
##
E_0 = -1.3184285199E+02

BOHR=0.52917720859
HARTREE=27.2116

set terminal postscript portrait enhanced color 'Times-Roman,18'
set output 'perovskite-optcell0.eps'
set encoding iso_8859_1

set lmargin 10
#set rmargin 13.5
set format y '%.3f'
set xtics 0.05
set key left
set ylabel '{/Times-Italic E}_{tot} - {/Times-Italic E}_{0} [eV]'
set xlabel '{/Times-Italic u} [\305]'

f001(x) = alpha*x**4 +  kappa001*x**2
fit f001(x) 'perovskite-optcell0-001.dat' using (sqrt($2**2+$3**2+$4**2)*BOHR):(($6-E_0)*HARTREE) via alpha, kappa001
f111(x) = agma3*x**4 +  kappa111*x**2
fit f111(x) 'perovskite-optcell0-111.dat' using (sqrt($2**2+$3**2+$4**2)*BOHR):(($6-E_0)*HARTREE) via agma3, kappa111

P_gamma = 3*(agma3-alpha)

plot        'perovskite-optcell0-001.dat' using (sqrt($2**2+$3**2+$4**2)*BOHR):(($6-E_0)*HARTREE) title '001' with p,\
            f001(x) title '4th order func.',\
            'perovskite-optcell0-111.dat' using (sqrt($2**2+$3**2+$4**2)*BOHR):(($6-E_0)*HARTREE) title '111' with p,\
            f111(x) title '4th order func.',\
            'perovskite-optcell0-110.dat' using (sqrt($2**2+$3**2+$4**2)*BOHR):(($6-E_0)*HARTREE) title '110' with p,\
            (alpha+1.0/4*P_gamma)*x**4 + (kappa001+kappa111)/2*x**2

print 'P_alpha = ',   alpha, ' [eV/Angstrom^4]'
print 'P_gamma = ', P_gamma, ' [eV/Angstrom^4]'
            
#Local variables:
#  compile-command: "gnuplot perovskite-optcell0.gp"
#End:
