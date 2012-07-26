#!/usr/bin/env gnuplot
# Time-stamp: <2012-07-26 13:42:27 t-nissie>
# Author: Takeshi NISHIMATSU
# for E in `jot - 25 310 5`; do echo "'$Eh.avg' using 1:13:(weight) t '$Eh' smooth acsplines,\\"; done
##
weight=0.0001

set table "atable.dat"
set format x "%5.1f"
set format y "%12.9f"
set samples 651
plot \
'025h.avg' using 1:13:(weight) t '025h' smooth acsplines,\
'030h.avg' using 1:13:(weight) t '030h' smooth acsplines,\
'035h.avg' using 1:13:(weight) t '035h' smooth acsplines,\
'040h.avg' using 1:13:(weight) t '040h' smooth acsplines,\
'045h.avg' using 1:13:(weight) t '045h' smooth acsplines,\
'050h.avg' using 1:13:(weight) t '050h' smooth acsplines,\
'055h.avg' using 1:13:(weight) t '055h' smooth acsplines,\
'060h.avg' using 1:13:(weight) t '060h' smooth acsplines,\
'065h.avg' using 1:13:(weight) t '065h' smooth acsplines,\
'070h.avg' using 1:13:(weight) t '070h' smooth acsplines,\
'075h.avg' using 1:13:(weight) t '075h' smooth acsplines,\
'080h.avg' using 1:13:(weight) t '080h' smooth acsplines,\
'085h.avg' using 1:13:(weight) t '085h' smooth acsplines,\
'090h.avg' using 1:13:(weight) t '090h' smooth acsplines,\
'095h.avg' using 1:13:(weight) t '095h' smooth acsplines,\
'100h.avg' using 1:13:(weight) t '100h' smooth acsplines,\
'105h.avg' using 1:13:(weight) t '105h' smooth acsplines,\
'110h.avg' using 1:13:(weight) t '110h' smooth acsplines,\
'115h.avg' using 1:13:(weight) t '115h' smooth acsplines,\
'120h.avg' using 1:13:(weight) t '120h' smooth acsplines,\
'125h.avg' using 1:13:(weight) t '125h' smooth acsplines,\
'130h.avg' using 1:13:(weight) t '130h' smooth acsplines,\
'135h.avg' using 1:13:(weight) t '135h' smooth acsplines,\
'140h.avg' using 1:13:(weight) t '140h' smooth acsplines,\
'145h.avg' using 1:13:(weight) t '145h' smooth acsplines,\
'150h.avg' using 1:13:(weight) t '150h' smooth acsplines,\
'155h.avg' using 1:13:(weight) t '155h' smooth acsplines,\
'160h.avg' using 1:13:(weight) t '160h' smooth acsplines,\
'165h.avg' using 1:13:(weight) t '165h' smooth acsplines,\
'170h.avg' using 1:13:(weight) t '170h' smooth acsplines,\
'175h.avg' using 1:13:(weight) t '175h' smooth acsplines,\
'180h.avg' using 1:13:(weight) t '180h' smooth acsplines,\
'185h.avg' using 1:13:(weight) t '185h' smooth acsplines,\
'190h.avg' using 1:13:(weight) t '190h' smooth acsplines,\
'195h.avg' using 1:13:(weight) t '195h' smooth acsplines,\
'200h.avg' using 1:13:(weight) t '200h' smooth acsplines,\
'205h.avg' using 1:13:(weight) t '205h' smooth acsplines,\
'210h.avg' using 1:13:(weight) t '210h' smooth acsplines,\
'215h.avg' using 1:13:(weight) t '215h' smooth acsplines,\
'220h.avg' using 1:13:(weight) t '220h' smooth acsplines,\
'225h.avg' using 1:13:(weight) t '225h' smooth acsplines,\
'230h.avg' using 1:13:(weight) t '230h' smooth acsplines,\
'235h.avg' using 1:13:(weight) t '235h' smooth acsplines,\
'240h.avg' using 1:13:(weight) t '240h' smooth acsplines,\
'245h.avg' using 1:13:(weight) t '245h' smooth acsplines,\
'250h.avg' using 1:13:(weight) t '250h' smooth acsplines,\
'255h.avg' using 1:13:(weight) t '255h' smooth acsplines,\
'260h.avg' using 1:13:(weight) t '260h' smooth acsplines,\
'265h.avg' using 1:13:(weight) t '265h' smooth acsplines,\
'270h.avg' using 1:13:(weight) t '270h' smooth acsplines,\
'275h.avg' using 1:13:(weight) t '275h' smooth acsplines,\
'280h.avg' using 1:13:(weight) t '280h' smooth acsplines,\
'285h.avg' using 1:13:(weight) t '285h' smooth acsplines,\
'290h.avg' using 1:13:(weight) t '290h' smooth acsplines,\
'295h.avg' using 1:13:(weight) t '295h' smooth acsplines,\
'300h.avg' using 1:13:(weight) t '300h' smooth acsplines,\
'305h.avg' using 1:13:(weight) t '305h' smooth acsplines,\
'310h.avg' using 1:13:(weight) t '310h' smooth acsplines

unset table

!./atable.rb

a0      =   3.98597
Z_star  =  10.33000
c=1.6e3*Z_star/a0**3

set terminal postscript portrait enhanced dash color 'Times-Roman' 14
set encoding iso_8859_1
set output 'atable3.eps'
set multiplot
#set title "`basename $PWD`" font 'Times-Roman, 18'
set xrange [200:900]
set lmargin 10

width=0.8
T_label=800
set origin 0.0, 0.5
set label 2 at T_label,40 '(a)' font 'Times-Roman,20'
set format x ""
set format y "%.0f"
set ylabel '{/Times-Italic P_z} [{/Symbol m}C cm^{-2}]'
set size width, 0.5
set key outside above vertical maxrows 8
plot '300h.avg' using 1:($13*c):(weight) t '300 kV/cm' smooth acsplines w l lt 1, '300h.avg' using 1:($13*c) t '' w d lt 1 lw 2,\
     '275h.avg' using 1:($13*c):(weight) t '275 kV/cm' smooth acsplines w l lt 2, '275h.avg' using 1:($13*c) t '' w d lt 2 lw 2,\
     '250h.avg' using 1:($13*c):(weight) t '250 kV/cm' smooth acsplines w l lt 3, '250h.avg' using 1:($13*c) t '' w d lt 3 lw 2,\
     '225h.avg' using 1:($13*c):(weight) t '225 kV/cm' smooth acsplines w l lt 4, '225h.avg' using 1:($13*c) t '' w d lt 4 lw 2,\
     '200h.avg' using 1:($13*c):(weight) t '200 kV/cm' smooth acsplines w l lt 5, '200h.avg' using 1:($13*c) t '' w d lt 5 lw 2,\
     '175h.avg' using 1:($13*c):(weight) t '175 kV/cm' smooth acsplines w l lt 7, '175h.avg' using 1:($13*c) t '' w d lt 7 lw 2,\
     '150h.avg' using 1:($13*c):(weight) t '150 kV/cm' smooth acsplines w l lt 8, '150h.avg' using 1:($13*c) t '' w d lt 8 lw 2,\
     '125h.avg' using 1:($13*c):(weight) t '125 kV/cm' smooth acsplines w l lt 9, '125h.avg' using 1:($13*c) t '' w d lt 9 lw 2,\
     '100h.avg' using 1:($13*c):(weight) t '100 kV/cm' smooth acsplines w l lt 1, '100h.avg' using 1:($13*c) t '' w d lt 1 lw 2,\
     '075h.avg' using 1:($13*c):(weight) t ' 75 kV/cm' smooth acsplines w l lt 2, '075h.avg' using 1:($13*c) t '' w d lt 2 lw 2,\
     '050h.avg' using 1:($13*c):(weight) t ' 50 kV/cm' smooth acsplines w l lt 3, '050h.avg' using 1:($13*c) t '' w d lt 3 lw 2,\
     '025h.avg' using 1:($13*c):(weight) t ' 25 kV/cm' smooth acsplines w l lt 4, '025h.avg' using 1:($13*c) t '' w d lt 4 lw 2,\
     '000h.avg' using 1:(-$11*c) t 'heat, 0 kV/cm' w l lt 1,\
     '000c.avg' using 1:(-$11*c) t 'cool, 0 kV/cm' w l lt 3       # choose $11, $12, $13, -$11, -$12 or $13

set origin 0.0, 0.23
set label 2 at T_label,-0.2 '(b)' font 'Times-Roman,20'
set format x ""
set format y "%.1f"
set ylabel 'd{/Times-Italic P_z} / d{/Times-Italic T}  [{/Symbol m}C cm^{-2} K^{-1}]'
set size width, 0.30
set yrange [-1.0:0.1]
set ytics 0.2
set nokey
set format x "%.0f"
set xlabel 'Temperature [K]'
plot 0 t '' w l lt 6,\
     '300h.duzdT' using 1:($2*c) t '' w l lt 1,\
     '275h.duzdT' using 1:($2*c) t '' w l lt 2,\
     '250h.duzdT' using 1:($2*c) t '' w l lt 3,\
     '225h.duzdT' using 1:($2*c) t '' w l lt 4,\
     '200h.duzdT' using 1:($2*c) t '' w l lt 5,\
     '175h.duzdT' using 1:($2*c) t '' w l lt 7,\
     '150h.duzdT' using 1:($2*c) t '' w l lt 8,\
     '125h.duzdT' using 1:($2*c) t '' w l lt 9,\
     '100h.duzdT' using 1:($2*c) t '' w l lt 1,\
     '075h.duzdT' using 1:($2*c) t '' w l lt 2,\
     '050h.duzdT' using 1:($2*c) t '' w l lt 3,\
     '025h.duzdT' using 1:($2*c) t '' w l lt 4

set nomultiplot
set output 'DeltaT.eps'
set multiplot

!./datamaker.sh

# 5.84 g/cm3 . 0.434 J/gK
Cv=2.53
set yrange [0:7]
set ytics 1

set size width, 0.28
set origin 0.0, 0.3
set format x ""
set format y "%1.0f"
set noxlabel
set ylabel '{/Symbol D}{/Times-Italic T} [K]'
#set yrange [0:0.14]
set label 2 at T_label,6.0 '(a)' font 'Times-Roman,20'
set key at 380,6.7
plot 'E060-310.dat' u 1:(-$2*$1*c/Cv/1000) t ' 60 {/Symbol \274} 310 kV/cm' w l,\
     'E110-310.dat' u 1:(-$2*$1*c/Cv/1000) t '110 {/Symbol \274} 310 kV/cm' w l,\
     'E160-310.dat' u 1:(-$2*$1*c/Cv/1000) t '160 {/Symbol \274} 310 kV/cm' w l,\
     'E210-310.dat' u 1:(-$2*$1*c/Cv/1000) t '210 {/Symbol \274} 310 kV/cm' w l,\
     'E260-310.dat' u 1:(-$2*$1*c/Cv/1000) t '260 {/Symbol \274} 310 kV/cm' w l

set origin 0.0, 0.0
set format x "%.0f"
set format y "%1.0f"
set xlabel 'Temperature [K]'
set ylabel '{/Symbol D}{/Times-Italic T} [K]'
set size width, 0.32
#set autoscale y
#set yrange [0:0.14]
set label 2 at T_label,6.0 '(b)' font 'Times-Roman,20'
plot 'E060-160.dat' u 1:(-$2*$1*c/Cv/1000) t ' 60 {/Symbol \274} 160 kV/cm' w l,\
     'E110-210.dat' u 1:(-$2*$1*c/Cv/1000) t '110 {/Symbol \274} 210 kV/cm' w l,\
     'E160-260.dat' u 1:(-$2*$1*c/Cv/1000) t '160 {/Symbol \274} 260 kV/cm' w l,\
     'E210-310.dat' u 1:(-$2*$1*c/Cv/1000) t '210 {/Symbol \274} 310 kV/cm' w l


set nomultiplot
set output 'T999.9.eps'

set origin 0.0, 0.0
set size width, 0.315
set nolabel 1
set nolabel 2

set autoscale x
set yrange [-1.0:0.1]
set ytics 0.2
set format y "%1.1f"
set key inside right bottom  maxrows 0

set xlabel '{/Times-Italic E_z} [kV/cm]'
set ylabel 'd{/Times-Italic P_z} / d{/Times-Italic T}  [{/Symbol m}C cm^{-2} K^{-1}]'

plot 'T350.5.dat' using 1:($3*c) t                     '350.5 K' w l lt 1,\
     'T450.5.dat' using 1:($3*c) t                     '450.5 K' w l lt 2,\
     'T500.5.dat' using 1:($3*c) t                     '500.5 K' w l lt 3,\
     'T550.5.dat' using 1:($3*c) t '{/Times-Italic T} = 550.5 K' w l lt 4,\
     'T600.5.dat' using 1:($3*c) t                     '600.5 K' w l lt 5,\
     'T650.5.dat' using 1:($3*c) t                     '650.5 K' w l lt 7,\
     'T700.5.dat' using 1:($3*c) t                     '700.5 K' w l lt 8
set output

#Local variables:
#  compile-command: "gnuplot atable3.gp"
#End:
