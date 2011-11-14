#!/usr/bin/env gnuplot
# BaTiO3-000-dispersion-with-ifc.gp
# Time-stamp: <2011-11-14 13:20:05 takeshi>
# Author: Takeshi NISHIMATSU
# Parameters from: /home/t-nissie/abinit/BaTiO3-phonon/BaTiO3-phonon-62-WuCohenGGA-0.0GPa-8x8x8-ecut60-dilatmx1.2-5.7.3-SR11000/zzz-parameters.txt
#  Because
#     DDB_a = -3.812330
#     DDB_b = 34.256065,
#  values in panel (B) are
#     Gamma             -1.51821042113588
#     X      DDB_b/2 + (-1.51821042113588 - DDB_a/2) = 17.5159870788641
##
set encoding iso_8859_1
call 'BaTiO3-000.param'
c = 14.399644 * Z_star**2 / epsilon_inf / a0**3
print "c = ", c

set nokey

set grid xtics
set xtics ('{/Symbol \107}'   0.000000000,\
           'X'                0.500000000,\
           'M'                1.000000000,\
           '{/Symbol \107}'   1.707106781,\
           'R'                2.573132185,\
           'X'                3.280238966,\
           'R'                3.987345747,\
           'M'                4.487345747)
 
set format y "%.1f"
set ytics 1.0 nomirror
set ylabel  '(half of eigenvalue) {/Symbol \244} ( {/Times-Italic Z}^{*2} {/Symbol \244} {/Symbol e_\245}{/Times-Italic a}_@0^3 )'

set y2label 'eV {/Symbol \244} \305^2'
set y2tics ('-12.0' -12/c,\
            '-10.0' -10/c,\
            '-8.0' -8/c,\
            '-6.0' -6/c,\
            '-4.0' -4/c,\
            '-2.0' -2/c,\
            ' 0.0' 0,\
            ' 2.0' 2/c,\
            ' 4.0' 4/c,\
            ' 6.0' 6/c,\
            ' 8.0' 8/c,\
            ' 10.0' 10/c,\
            ' 12.0' 12/c,\
            ' 14.0' 14/c,\
            ' 16.0' 16/c,\
            ' 18.0' 18/c,\
            ' 20.0' 20/c,\
            ' 22.0' 22/c       )

set terminal postscript portrait enhanced color "Times-Roman" 14
set output "BaTiO3-000-dispersion-with-ifc.eps"
set multiplot

call 'dipole-dipole-axis.gp' '-3.7'
set size 1.0, 0.54
set origin 0.0, 0.47
set arrow 1 from 1.3535533905932737,-3.5 to 1.3535533905932737,5.5 nohead back ls 3
set label 1 '(a)-2{/Symbol p}/3' front at 1.80,-2.10
set label 2 '(b)4.844'           front at 3.40, 4.80
set label 3 '(c)-2.422'          front at 3.03,-2.65
set label 4 '(d)-2.677'          front at 0.75,-2.95
set label 5 '(e)1.338'           front at 0.37, 1.30
set label 6 '(f)0'               front at 2.53,-0.30
set label 7 '(g)2.932'           front at 1.35, 2.80
set label 8 '(A)' front at 0.07, 5.20 font "Times-Roman,22"
set yrange [-3.5:5.5]

plot 0 w l lt 2,\
'BaTiO3-000.dipole-dipole-long.dat' using 1:($5/c/2) w l lt 1 lw 2,\
'BaTiO3-000.dipole-dipole-long.dat' using 1:($6/c/2) w l lt 1 lw 2,\
'BaTiO3-000.dipole-dipole-long.dat' using 1:($7/c/2) w l lt 1 lw 2


call 'dipole-dipole-axis.gp' '-1.23'
set size 1.0, 0.48
set origin 0.0, 0.01
set xlabel '{/Times-Italic k}'
set noarrow 1
set nolabel 1
set nolabel 2
set nolabel 3
set nolabel 4
set nolabel 5
set nolabel 6
set nolabel 7
set label 8 '(B)' front at 0.07, 6.20 font "Times-Roman,22"
set yrange [-1.0:6.5]


# 97.1736 [Hatree/Bohr^2] => [eV/Angstrom^2]
elevation=0.0
plot 0 w l lt 2,\
'perovskite.dat'                          using 4:(($5 *97.1736/2+elevation)/c) w l lt 2 lc 7 lw 1,\
'perovskite.dat'                          using 4:(($6 *97.1736/2+elevation)/c) w l lt 2 lc 7 lw 1,\
'perovskite.dat'                          using 4:(($7 *97.1736/2+elevation)/c) w l lt 2 lc 7 lw 1,\
'perovskite.dat'                          using 4:(($8 *97.1736/2+elevation)/c) w l lt 2 lc 7 lw 1,\
'perovskite.dat'                          using 4:(($9 *97.1736/2+elevation)/c) w l lt 2 lc 7 lw 1,\
'perovskite.dat'                          using 4:(($10*97.1736/2+elevation)/c) w l lt 2 lc 7 lw 1,\
'perovskite.dat'                          using 4:(($11*97.1736/2+elevation)/c) w l lt 2 lc 7 lw 1,\
'perovskite.dat'                          using 4:(($12*97.1736/2+elevation)/c) w l lt 2 lc 7 lw 1,\
'perovskite.dat'                          using 4:(($13*97.1736/2+elevation)/c) w l lt 2 lc 7 lw 1,\
'perovskite.dat'                          using 4:(($14*97.1736/2+elevation)/c) w l lt 2 lc 7 lw 1,\
'perovskite.dat'                          using 4:(($15*97.1736/2+elevation)/c) w l lt 2 lc 7 lw 1,\
'perovskite.dat'                          using 4:(($16*97.1736/2+elevation)/c) w l lt 2 lc 7 lw 1,\
'perovskite.dat'                          using 4:(($17*97.1736/2+elevation)/c) w l lt 2 lc 7 lw 1,\
'perovskite.dat'                          using 4:(($18*97.1736/2+elevation)/c) w l lt 2 lc 7 lw 1,\
'perovskite.dat'                          using 4:(($19*97.1736/2+elevation)/c) w l lt 2 lc 7 lw 1,\
'BaTiO3-000.dipole-dipole-long+short.dat' using 1:($5/c/2)         w l lt 1 lw 2,\
'BaTiO3-000.dipole-dipole-long+short.dat' using 1:($6/c/2)         w l lt 1 lw 2,\
'BaTiO3-000.dipole-dipole-long+short.dat' using 1:($7/c/2)         w l lt 1 lw 2


#Local variables:
#  compile-command: "gnuplot BaTiO3-000-dispersion-with-ifc.gp"
#End:
