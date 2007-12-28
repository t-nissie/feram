#!/usr/bin/env gnuplot
# Time-stamp: <2007-08-08 18:02:58 t-nissie>
# Author: Takeshi NISHIMATSU
# Purpose: Check energy conservation
##
#--- Common settings ------------------------------------------------
min_step = 0
max_step = 60000
set xrange [min_step:max_step]
set rmargin 5
set grid
#set title 'quartz01:/work/t-nissie/feram/feram-0.90/epit-32x32-11-01-Q0.1-5.0GPa-quartz01'
set xlabel 'time step'
set ylabel 'energy [eV/cell]'
set format y '%.2f'
set xtics 10000

set terminal postscript landscape enhanced solid color 'Times-Roman' 16
set output 'external300.ps'
min_energy = -0.20
max_energy =  0.10
set ytics 0.02
set yrange [min_energy:max_energy]
set key max_step+(max_step-min_step)*0.13, max_energy Left reverse spacing 1.3
set rmargin 18
plot '< grep " dipo_kinetic    " external300.log'\
     using 0:2 title '{/Times-Italic E}_{dipole-kinetic}' w l lt 2,\
     '< grep " dipole_dipole   " external300.log'\
     using 0:2 title '{/Times-Italic E}_{dipole-dipole}'  w l lt 3,\
     '< grep " unharmonic      " external300.log'\
     using 0:2 title '{/Times-Italic E}_{unharmonic}'     w l lt 4,\
     '< grep " homo_strain     " external300.log'\
     using 0:2 title '{/Times-Italic E}_{homo-strain}'    w l lt 5,\
     '< grep " homo_coupling   " external300.log'\
     using 0:2 title '{/Times-Italic E}_{homo-coupling}'  w l lt 6,\
     '< grep " inho_strain     " external300.log'\
     using 0:2 title '{/Times-Italic E}_{inho-strain}'    w l lt 7,\
     '< grep " inho_coupling   " external300.log'\
     using 0:2 title '{/Times-Italic E}_{inho-coupling}'  w l lt 8,\
     '< grep " total_energy    " external300.log'\
     using 0:2 title '{/Times-Italic E}_{total}'          w l lt 1,\
     '< grep " H_Nose_Poincare " external300.log'\
     using 0:2 title '{/Times-Italic H}_{N-P}'            w l lt 9,\
     '< grep " dipole_E_field " external300.log'\
     using 0:2 title '{/Times-Italic E}_{dipole_E_field}' w l lt 9

#Local variables:
#  compile-command: "gnuplot external300.gp && kill -HUP `pgrep gv`"
#End:
