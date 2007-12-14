#!/usr/bin/env gnuplot
# Time-stamp: <2007-12-14 02:44:26 takeshi>
# Author: Takeshi NISHIMATSU
# Purpose: Check energy conservation
##
#--- Common settings ------------------------------------------------
min_step = 0
max_step = 10000
set xrange [min_step:max_step]
set rmargin 5
set grid
#set title 'quartz01:/work/t-nissie/feram/feram-0.90/epit-32x32-11-01-Q0.1-5.0GPa-quartz01'
set xlabel 'time step'
set ylabel 'energy [eV/cell]'
set format y '%.2f'
set xtics max_step/5

set terminal postscript landscape enhanced solid color 'Times-Roman' 16
set output 'plot.ps'
min_energy = -0.14
max_energy =  0.10
set ytics 0.02
set yrange [min_energy:max_energy]
set key max_step+(max_step-min_step)*0.39, max_energy Left reverse spacing 1.3
set rmargin 18
plot '< grep " dipo_kinetic    " feram.log'\
     using 0:2 title '{/Times-Italic E}_{dipole-kinetic}' w l lt 2,\
     '< grep " dipole_dipole   " feram.log'\
     using 0:2 title '{/Times-Italic E}_{dipole-dipole}'  w l lt 3,\
     '< grep " unharmonic      " feram.log'\
     using 0:2 title '{/Times-Italic E}_{unharmonic}'     w l lt 4,\
     '< grep " homo_strain     " feram.log'\
     using 0:2 title '{/Times-Italic E}_{homo-strain}'    w l lt 5,\
     '< grep " homo_coupling   " feram.log'\
     using 0:2 title '{/Times-Italic E}_{homo-coupling}'  w l lt 6,\
     '< grep " inho_strain     " feram.log'\
     using 0:2 title '{/Times-Italic E}_{inho-strain}'    w l lt 7,\
     '< grep " inho_coupling   " feram.log'\
     using 0:2 title '{/Times-Italic E}_{inho-coupling}'  w l lt 8,\
     '< grep " total_energy    " feram.log'\
     using 0:2 title '{/Times-Italic E}_{total}'          w l lt 1,\
     '< grep " H_Nose_Poincare " feram.log'\
     using 0:2 title '{/Times-Italic H}_{N-P}'            w l lt 9,\
     '< grep " dipole_E_field " feram.log'\
     using 0:2 title '{/Times-Italic E}_{dipole-E}'       w l lt 5

set terminal postscript landscape enhanced solid color 'Times-Roman' 16
set output 'plot.Nose.ps'
set yrange [-2:4]
#set autoscale y
set ytics auto
set key max_step+(max_step-min_step)*0.13, 1.0 Left reverse spacing 1.3
set rmargin 18
plot '< grep  "s_Nose"         feram.log'\
     using 0:2 title '{/Times-Italic s}_{Nose}'           w l lt 4,\
     '< grep "pi_Nose"         feram.log'\
     using 0:4 title       '{/Symbol p}_{Nose}'           w l lt 5

set terminal postscript landscape enhanced solid color 'Times-Roman' 16
set output 'plot.total.ps'
set autoscale y
set ytics auto
set key max_step+(max_step-min_step)*0.13, 0.02 Left reverse spacing 1.3
plot '< grep " total_energy  " feram.log' using 0:2 \
     title '{/Times-Italic E}_{total}'          w l

set terminal postscript landscape enhanced solid color 'Times-Roman' 16
set output 'plot.dipoR004.ps'
set autoscale y
set key max_step+(max_step-min_step)*0.13, 0.150 Left reverse spacing 1.3
plot '< grep "  dipoR" feram.log' using 0:2 title '{/Times-Italic u_x}(0,0,0)' w l,\
     '< grep "  dipoR" feram.log' using 0:3 title '{/Times-Italic u_y}(0,0,0)' w l,\
     '< grep "  dipoR" feram.log' using 0:4 title '{/Times-Italic u_z}(0,0,0)' w l

set terminal postscript landscape enhanced solid color 'Times-Roman' 16
set output 'plot.strain.ps'
#set yrange [-0.015:0.035]
set autoscale y
set key max_step+(max_step-min_step)*0.13, 0.02 Left reverse spacing 1.3
plot \
 '< grep " strain " feram.log' using 0:2 title '{/Times-Italic e_{xx}}' w l,\
 '< grep " strain " feram.log' using 0:3 title '{/Times-Italic e_{yy}}' w l,\
 '< grep " strain " feram.log' using 0:4 title '{/Times-Italic e_{zz}}' w l,\
 '< grep " strain " feram.log' using 0:5 title '{/Times-Italic e_{yz}}' w l,\
 '< grep " strain " feram.log' using 0:6 title '{/Times-Italic e_{zx}}' w l,\
 '< grep " strain " feram.log' using 0:7 title '{/Times-Italic e_{xy}}' w l lt 7

set terminal postscript landscape enhanced solid color 'Times-Roman' 16
set output 'plot.strain1.ps'
#set yrange [-0.015:0.035]
set autoscale y
set key max_step+(max_step-min_step)*0.13, 0.02 Left reverse spacing 1.3
#set ytics 0.001
plot '< grep " strain " feram.log' using 0:2 title '{/Times-Italic e_{xx}}' w l,\
     '< grep " strain " feram.log' using 0:3 title '{/Times-Italic e_{yy}}' w l,\
     '< grep " strain " feram.log' using 0:4 title '{/Times-Italic e_{zz}}' w l

set terminal postscript landscape enhanced solid color 'Times-Roman' 16
set output 'plot.strain4.ps'
set autoscale y
set key max_step+(max_step-min_step)*0.13, 0.02 Left reverse spacing 1.3
set ytics auto
plot \
 '< grep " strain " feram.log' using 0:5 title '{/Times-Italic e_{yz}}' w l,\
 '< grep " strain " feram.log' using 0:6 title '{/Times-Italic e_{zx}}' w l,\
 '< grep " strain " feram.log' using 0:7 title '{/Times-Italic e_{xy}}' w l
#Local variables:
#  compile-command: "gnuplot plot.gp && kill -HUP `pgrep gv`"
#End:
