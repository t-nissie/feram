#!/usr/bin/env gnuplot
# Tc.gp
# Time-stamp: <2016-07-18 18:32:06 takeshi>
# Author: Takeshi NISHIMATSU
##
set encoding iso_8859_1  # for longer minus
set terminal postscript eps enhanced color dashed "Times-Roman" 15
set output 'Tc.eps'
set size 0.5,0.7
#set title "{/Times-Italic b}=6.0,  empty: {/Times-Italic c}=0.6554, filled: {/Times-Italic c}=0.0000"
set yrange [0:450]
set xrange [0:1]
set format x "%.1f"
set xtics 0.1
set xlabel "(Ba_{/Times-Italic x}Sr_{1-{/Times-Italic x}})TiO_3"
set ylabel "{/Times-Italic T} [K]"
set label 1 at 0.1,310 "cubic (paraelectric)"
set label 2 at 0.6,230 "tetragonal"   rotate by 30
set label 3 at 0.6,175 "orthorhombic" rotate by 25
set label 4 at 0.5, 70 "rhombohedral"
plot 'Tc.dat' using 1:(($2+$3)/2) t '' w lp lt 3 pt 4 ps 2 lw 2,\
     'Tc.dat' using 1:(($4+$5)/2) t '' w lp lt 2 pt 6 ps 2 lw 2,\
     'Tc.dat' using 1:(($6+$7)/2) t '' w lp lt 1 pt 8 ps 2 lw 2
   # 'c0.dat' using 1:(($2+$3)/2) t '' w lp lt 3 pt 5 ps 1 lw 2,\
   # 'c0.dat' using 1:(($4+$5)/2) t '' w lp lt 2 pt 7 ps 1 lw 2,\
   # 'c0.dat' using 1:(($6+$7)/2) t '' w lp lt 1 pt 9 ps 1 lw 2,\
   # 'PhysRevB.54.3151.BST.Lemanov.Fig9.dat' t    'Lemanov {/Times-Italic et al.}' w lp lt 4 pt 1 lw 2,\
   # 'PhysRevB.65.224104.BST.Fig10.dat'      t 'M\351noret {/Times-Italic et al.}' w lp lt 7 pt 2 lw 2
set output
!epstopdf Tc.eps
#Local variables:
#  compile-command: "gnuplot Tc.gp"
#End:
