#!/usr/bin/env gnuplot
##
HARTREE_IN_EV = 27.21138386
BOHR    =  0.5291772083

set encoding iso_8859_1
set terminal postscript portrait enhanced "Times-Roman" color 24
set output "perovskite-B1112.eps"
set multiplot


Etot(x) = B0*x/(B0p*(B0p-1.0)) *(B0p*(1.0-V0/x)+(V0/x)**B0p-1.0)+Emin
# initial values
B0             =     1.2
B0p            =     4.4
V0             =    64.0
Emin           = -3587.0
fit Etot(x) 'perovskite-B1112.dat1' using (($2*BOHR)**3):($7*HARTREE_IN_EV) via B0, B0p, V0, Emin

Etot11(x) = B11/2*((x-a0)/a0)**2 + Emin11
# initial values
a0           =     7.44  # [Bohr]
B11           =  130.0   # [eV]
Emin11       = -3587.0   # [eV]
fit Etot11(x) 'perovskite-B1112.dat2' using ($4):($7*HARTREE_IN_EV) via a0,B11,Emin11

set size 1.0,0.5

set format y "%.3f"
set ylabel "{/Times-Italic E}_{tot}-{/Times-Italic E}_0 [eV]"

set origin 0.0,0.5
set yrange [-0.01:0.05]
set xlabel "{/Times-Italic V} [\305^3]"
set xtics 1
plot 'perovskite-B1112.dat1' using (($2*BOHR)**3):($7*HARTREE_IN_EV-Emin) t 'calculated data' w p pt 1 ps 2 lw 3,\
      Etot(x)-Emin t 'equation of state' w l lt 1 lw 3

set origin 0.0,0.0
set yrange [-0.005:0.020]
set xlabel "{/Times-Italic e_{xx}}"
set xtics 0.01
plot 'perovskite-B1112.dat2' using (($4-a0)/a0):($7*HARTREE_IN_EV-Emin11) t 'calculated data' w p lt 2 pt 2 ps 2 lw 3,\
     B11/2*x**2 t 'quadratic fitting' w l lt 2 lw 3

# B11 and B12
print 'DATASET 1 -- 9'
a0_Angstrom = V0**(1.0/3)
print 'a0 = ', a0_Angstrom/BOHR, ' [Bohr] = ',  a0_Angstrom, ' [Angstrom]'
print 'Emin = ', Emin, ' [eV]'
print 'B = ',  B0*160.22, ' [GPa]'

print 'DATASET 10 -- 19'
print 'a0 = ', a0, ' [Bohr] = ',  a0*BOHR, ' [Angstrom]'
print 'Emin = ', Emin11, ' [eV]'
print 'B11 = ', B11, ' [eV]'
C11 = B11 / a0_Angstrom**3 * 160.22
print 'C11 = ', C11, ' [GPa]'

print 'Compute B12'
B12 = (3*B0*a0_Angstrom**3-B11)/2
print 'B12 = ', B12, ' [eV]'
C12 = B12 / a0_Angstrom**3 * 160.22
print 'C12 = ', C12, ' [GPa]'

#Local variables:
#  compile-command: "gnuplot perovskite-B1112.gp"
#End:
