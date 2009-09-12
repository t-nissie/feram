#!/usr/bin/env gnuplot
##
BOHR=0.52917720859
HARTREE=27.21138386

E0_WuC=  -1.3136340444E+02

set terminal postscript landscape enhanced color 'Times-Roman,23'
set output 'BaTiO3WuCohenGGA.eps'
set encoding iso_8859_1
set format y '%.2f'
set format x '%.1f'
set xtics 0.2
set xrange [-0.4:0.4]
set ytics    0.02
set yrange [-0.04:0.12]
set key left
set xlabel '{/Times-Italic u} [\305]'
set ylabel '{/Times-Italic E} - {/Times-Italic E}_0 [eV]'

set label 1 at -0.33,0.082 '{/Times-Italic u}^@2_{/Symbol a} = \{{/Times-Italic v^@A}_{/Symbol a}\}^2 + \{{/Times-Italic v^@B}_{/Symbol a}\}^2 +  \{{/Times-Italic v}^@{O_I}_{/Symbol a} \}^2 + \{{/Times-Italic v}^@{O_{II}}_{/Symbol a}  \}^2 + \{{/Times-Italic v}^@{O_{III}}_{/Symbol a}   \}^2'
set label 2 at -0.33,0.064 '{/Times-Italic u}^2 = {/Times-Italic u_@x}^2 + {/Times-Italic u_@y}^2 + {/Times-Italic u_@z}^2'
plot 'perovskite-optcell2-001.dat' using ( $2*BOHR):(($4-E0_WuC)*HARTREE) title '[001]' with l lt 1 lw 3,\
     'perovskite-optcell2-110.dat' using ( $2*BOHR):(($4-E0_WuC)*HARTREE) title '[110]' with l lt 2 lw 3,\
     'perovskite-optcell2-111.dat' using ( $2*BOHR):(($4-E0_WuC)*HARTREE) title '[111]' with l lt 3 lw 3,\
     'perovskite-optcell2-001.dat' using (-$2*BOHR):(($4-E0_WuC)*HARTREE) notitle       with l lt 1 lw 3,\
     'perovskite-optcell2-110.dat' using (-$2*BOHR):(($4-E0_WuC)*HARTREE) notitle       with l lt 2 lw 3,\
     'perovskite-optcell2-111.dat' using (-$2*BOHR):(($4-E0_WuC)*HARTREE) notitle       with l lt 3 lw 3

     
set output
!gs -q -sDEVICE=ppm -sPAPERSIZE=a4 -r90x90 -dSAFER -dNOPAUSE -dBATCH -sOutputFile=- -q BaTiO3WuCohenGGA.eps | pnmcrop -white | pnmflip -r270 | cjpeg -quality 90 > BaTiO3WuCohenGGA.jpg

#Local variables:
#  compile-command: "gnuplot BaTiO3WuCohenGGA.gp"
#End:
