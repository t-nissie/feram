#!/usr/bin/env gnuplot
# dipole-dipole.gp
# Time-stamp: <2014-10-15 18:41:46 t-nissie>
# Author: Takeshi NISHIMATSU
##
set encoding iso_8859_1
call 'bulk32x32x32.param.gp'
c =                  14.399644 * Z_star**2 / epsilon_inf / a0**3
omega_unit_m = sqrt( 14.399644 * Z_star**2 / epsilon_inf*4*pi / 3 / a0**3 )
omega_unit = omega_unit_m / sqrt(mass_dipo)
print "omega_unit = ", omega_unit, " x 10^12 [s^-1]"
print "           = ", omega_unit/2/pi," [THz]"
print "           = ", omega_unit/2/pi*100/2.9979," [cm^-1]"
### Common settings
#set title 'Phonon Dispersion of Simple Cubic Dipole Crystal'
set ytics ( '2.0'  2.0,\
            '1.5'  1.5,\
            '1.0'  1.0,\
            '0.5'  0.5,\
            '0.0'  0.0,\
           '0.5i' -0.5,\
           '1.0i' -1.0,\
           '1.5i' -1.5)
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

set yrange [-1.5:2]
set ylabel '{/Symbol w} / sqrt( 4{/Symbol p}{/Times-Italic Z}^{*2} / 3{/Symbol e_\245}{/Times-Italic M}^*{/Times-Italic a}_@0^3 )'
call 'dipole-dipole-axis.gp' '-1.63'


set terminal postscript landscape enhanced color "Times-Roman" 21
set output "dipole-dipole-long.eps"
set label 1 "Universal for any perovskite ferroelectrics" at 0.4,1.8 left font "Times-Roman,30" tc lt 1
set label 2 "TO" at 0.1, -0.85 left font "Times-Roman,30" tc lt 2
set label 3 "LO" at 0.1,  1.3  left font "Times-Roman,30" tc lt 4
set label 4 "{/Symbol w}_@1^2+{/Symbol w}_@2^2+{/Symbol w}_@3^2=0"\
                               at 2.4, 1.1 left font "Times-Roman,30" tc lt 5
plot 0,\
'bulk32x32x32.dipole-dipole-long.dat' using 1:(($5>0?sqrt($5):-sqrt(-$5))/omega_unit_m) w l,\
'bulk32x32x32.dipole-dipole-long.dat' using 1:(($6>0?sqrt($6):-sqrt(-$6))/omega_unit_m) w l,\
'bulk32x32x32.dipole-dipole-long.dat' using 1:(($7>0?sqrt($7):-sqrt(-$7))/omega_unit_m) w l

set terminal postscript landscape enhanced color "Times-Roman" 21
set output "bulk32x32x32.dipole-dipole-short.eps"
set nolabel 1
set nolabel 2
set nolabel 3
set nolabel 4
set nolabel 5
plot 0,\
'bulk32x32x32.dipole-dipole-short.dat' using 1:(($5>0?sqrt($5):-sqrt(-$5))/omega_unit_m) w l,\
'bulk32x32x32.dipole-dipole-short.dat' using 1:(($6>0?sqrt($6):-sqrt(-$6))/omega_unit_m) w l,\
'bulk32x32x32.dipole-dipole-short.dat' using 1:(($7>0?sqrt($7):-sqrt(-$7))/omega_unit_m) w l

set terminal postscript landscape enhanced color "Times-Roman" 21
set output "bulk32x32x32.dipole-dipole-long-long+short.eps"
plot 0,\
'bulk32x32x32.dipole-dipole-long.dat' using 1:(($5>0?sqrt($5):-sqrt(-$5))/omega_unit_m) w l,\
'bulk32x32x32.dipole-dipole-long.dat' using 1:(($6>0?sqrt($6):-sqrt(-$6))/omega_unit_m) w l,\
'bulk32x32x32.dipole-dipole-long.dat' using 1:(($7>0?sqrt($7):-sqrt(-$7))/omega_unit_m) w l,\
'bulk32x32x32.dipole-dipole-long+short.dat' using 1:(($5>0?sqrt($5):-sqrt(-$5))/omega_unit_m) w l lt 11 lw 3,\
'bulk32x32x32.dipole-dipole-long+short.dat' using 1:(($6>0?sqrt($6):-sqrt(-$6))/omega_unit_m) w l lt 12 lw 3,\
'bulk32x32x32.dipole-dipole-long+short.dat' using 1:(($7>0?sqrt($7):-sqrt(-$7))/omega_unit_m) w l lt 13 lw 3

set terminal postscript landscape enhanced color "Times-Roman" 21
set output "bulk32x32x32.dipole-dipole-long+short.eps"
set label 1 " BaTiO_3 optical phonon dispersion" at 0.6,-0.8 left font "Times-Roman,35" tc lt 1
plot 0,\
'bulk32x32x32.dipole-dipole-long+short.dat' using 1:(($5>0?sqrt($5):-sqrt(-$5))/omega_unit_m) w l lt 11,\
'bulk32x32x32.dipole-dipole-long+short.dat' using 1:(($6>0?sqrt($6):-sqrt(-$6))/omega_unit_m) w l lt 12,\
'bulk32x32x32.dipole-dipole-long+short.dat' using 1:(($7>0?sqrt($7):-sqrt(-$7))/omega_unit_m) w l lt 13

set nolabel 1

set yrange [-3:6]
set ytics 1
set format y "%.1f"
set ylabel '(interaction energy per unit cell) / ( {/Times-Italic Z}^{*2} {/Times-Italic u}^2 / {/Symbol e_\245}{/Times-Italic a}_@0^3 )'
call 'dipole-dipole-axis.gp' '-3.25'

set terminal postscript landscape enhanced color "Times-Roman" 21

set output "bulk32x32x32.dipole-dipole-long.interaction.eps"
plot 0 w l lt 2,\
'bulk32x32x32.dipole-dipole-long.dat' using 1:($5/c/2) w l lt 1 lw 3,\
'bulk32x32x32.dipole-dipole-long.dat' using 1:($6/c/2) w l lt 3 lw 3,\
'bulk32x32x32.dipole-dipole-long.dat' using 1:($7/c/2) w l lt 4 lw 3

set output "bulk32x32x32.dipole-dipole-long+short.interaction.eps"
plot 0 w l lt 2,\
'bulk32x32x32.dipole-dipole-long+short.dat' using 1:($5/c/2) w l lt 1 lw 3,\
'bulk32x32x32.dipole-dipole-long+short.dat' using 1:($6/c/2) w l lt 3 lw 3,\
'bulk32x32x32.dipole-dipole-long+short.dat' using 1:($7/c/2) w l lt 4 lw 3

set yrange [-15:30]
set ytics -5
#set format y "%.3f"
set ylabel 'Eigenvalues of {/Symbol F}({/Times-Italic k})/2 [eV \305^{-2} unit-cell^{-1}]'
call 'dipole-dipole-axis.gp' '-16.3'

set terminal postscript landscape enhanced color "Times-Roman" 21
set output "bulk32x32x32.dipole-dipole-long.energy.eps"
plot 0,\
'bulk32x32x32.dipole-dipole-long.dat' using 1:($5/2) w l lw 3,\
'bulk32x32x32.dipole-dipole-long.dat' using 1:($6/2) w l lw 3,\
'bulk32x32x32.dipole-dipole-long.dat' using 1:($7/2) w l lw 3

set terminal postscript landscape enhanced color "Times-Roman" 21
set output "bulk32x32x32.dipole-dipole-short.energy.eps"
plot 0,\
'bulk32x32x32.dipole-dipole-short.dat' using 1:($5/2) w l lw 3,\
'bulk32x32x32.dipole-dipole-short.dat' using 1:($6/2) w l lw 3,\
'bulk32x32x32.dipole-dipole-short.dat' using 1:($7/2) w l lw 3

set terminal postscript landscape enhanced color "Times-Roman" 21
set output "bulk32x32x32.dipole-dipole-long+short.energy.eps"
plot 0,\
'bulk32x32x32.dipole-dipole-long+short.dat' using 1:($5/2) w l lw 3,\
'bulk32x32x32.dipole-dipole-long+short.dat' using 1:($6/2) w l lw 3,\
'bulk32x32x32.dipole-dipole-long+short.dat' using 1:($7/2) w l lw 3

#Local variables:
#  compile-command: "gnuplot dipole-dipole.gp && kill -HUP `pgrep gv`"
#End:
