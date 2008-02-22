#!/usr/bin/env gnuplot
# Time-stamp: <2008-02-22 10:07:52 takeshi>
# Author: Takeshi NISHIMATSU
# ref_1: R. D. King-Smith and David Vanderbilt: PRB vol.49 p.5828 (1994)
##
set encoding iso_8859_1
#set grid
set bmargin 4
set xrange [0:0.20]
set xtics 0.1
set ytics 0.02
set format x "%.1f"
set format y "%.2f"

set key 0.125,-0.013
set yrange [-0.06:0.0]

set terminal postscript portrait enhanced dashed color 'Times-Roman' 12
set output  'all-potential-surface-110.ps'
set multiplot

set ylabel '{/Times-Italic E} [eV / unit cell]'
epitE0=0.024003715545

set size   0.54, 0.27
set title 'epitaxially constraint film'
set label 1  "(a) {/Times-Italic l} = 15,  {/Times-Italic d} = 1" at 0.08, -0.007 font "Times-Roman,14"
set origin 0.00, 0.74
set xlabel ''
plot \
     'epit-L015-D1-110k0.0000.dat' u 1:($3-epitE0) t '(000)'         w l lt 1,\
     'epit-L015-D1-110k0.0833.dat' u 1:($3-epitE0) t '(1/12 1/12 0)' w l lt 4,\
     'epit-L015-D1-110k0.2500.dat' u 1:($3-epitE0) t '(1/4 1/4 0)'   w l lt 9,\
     'epit-L015-D1-110k0.1250.dat' u 1:($3-epitE0) t '(1/8 1/8 0)'   w l lt 5,\
     'epit-L015-D1-110k0.1667.dat' u 1:($3-epitE0) t '(1/6 1/6 0)'   w l lt 8

    #'epit-L015-D1-110k0.0417.dat' u 1:($3-epitE0) t '(1/24 1/24 0)' w l lt 2,\
    #'epit-L015-D1-110k0.0625.dat' u 1:($3-epitE0) t '(1/16 1/16 0)' w l lt 3,\

set size   0.54, 0.241
set title ''
set label 1  "(b) {/Times-Italic l} = 31,  {/Times-Italic d} = 1" at 0.08, -0.007 font "Times-Roman,14"
set origin 0.00, 0.555
set xlabel ''
plot \
     'epit-L031-D1-110k0.2500.dat' u 1:($3-epitE0) t '(1/4 1/4 0)'   w l lt 9,\
     'epit-L031-D1-110k0.0000.dat' u 1:($3-epitE0) t '(000)'         w l lt 1,\
     'epit-L031-D1-110k0.1667.dat' u 1:($3-epitE0) t '(1/6 1/6 0)'   w l lt 8,\
     'epit-L031-D1-110k0.0417.dat' u 1:($3-epitE0) t '(1/24 1/24 0)' w l lt 2,\
     'epit-L031-D1-110k0.1250.dat' u 1:($3-epitE0) t '(1/8 1/8 0)'   w l lt 5,\
     'epit-L031-D1-110k0.0625.dat' u 1:($3-epitE0) t '(1/16 1/16 0)' w l lt 3,\
     'epit-L031-D1-110k0.0833.dat' u 1:($3-epitE0) t '(1/12 1/12 0)' w l lt 4

set label 1  "(c) {/Times-Italic l} = 127,  {/Times-Italic d} = 1" at 0.07, -0.007 font "Times-Roman,14"
set origin 0.00, 0.37
set xlabel ''
plot \
     'epit-L127-D1-110k0.1667.dat' u 1:($3-epitE0) t '(1/6 1/6 0)'   w l lt 8,\
     'epit-L127-D1-110k0.1250.dat' u 1:($3-epitE0) t '(1/8 1/8 0)'   w l lt 5,\
     'epit-L127-D1-110k0.0833.dat' u 1:($3-epitE0) t '(1/12 1/12 0)' w l lt 4,\
     'epit-L127-D1-110k0.0625.dat' u 1:($3-epitE0) t '(1/16 1/16 0)' w l lt 3,\
     'epit-L127-D1-110k0.0417.dat' u 1:($3-epitE0) t '(1/24 1/24 0)' w l lt 2,\
     'epit-L127-D1-110k0.0000.dat' u 1:($3-epitE0) t '(000)'         w l lt 1

set label 1  "(d) {/Times-Italic l} = 255,  {/Times-Italic d} = 1" at 0.07, -0.007 font "Times-Roman,14"
set origin 0.00, 0.185
set xlabel ''
plot \
     'epit-L255-D1-110k0.1667.dat' u 1:($3-epitE0) t '(1/6 1/6 0)'   w l lt 8,\
     'epit-L255-D1-110k0.1250.dat' u 1:($3-epitE0) t '(1/8 1/8 0)'   w l lt 5,\
     'epit-L255-D1-110k0.0833.dat' u 1:($3-epitE0) t '(1/12 1/12 0)' w l lt 4,\
     'epit-L255-D1-110k0.0625.dat' u 1:($3-epitE0) t '(1/16 1/16 0)' w l lt 3,\
     'epit-L255-D1-110k0.0417.dat' u 1:($3-epitE0) t '(1/24 1/24 0)' w l lt 2,\
     'epit-L255-D1-110k0.0000.dat' u 1:($3-epitE0) t '(000)'         w l lt 1

set label 1  "(e) {/Times-Italic d} = 0" at 0.08, -0.007 font "Times-Roman,14"
set origin 0.00, 0.0
set xlabel '{/Times-Italic u_z} [\305]'
plot \
     'epit-L008-D0-110k0.1667.dat' u 1:($3-epitE0) t '(1/6 1/6 0)'   w l lt 8,\
     'epit-L008-D0-110k0.1250.dat' u 1:($3-epitE0) t '(1/8 1/8 0)'   w l lt 5,\
     'epit-L008-D0-110k0.0833.dat' u 1:($3-epitE0) t '(1/12 1/12 0)' w l lt 4,\
     'epit-L008-D0-110k0.0625.dat' u 1:($3-epitE0) t '(1/16 1/16 0)' w l lt 3,\
     'epit-L008-D0-110k0.0417.dat' u 1:($3-epitE0) t '(1/24 1/24 0)' w l lt 2,\
     'epit-L008-D0-110k0.0000.dat' u 1:($3-epitE0) t '(000)'         w l lt 1

#---------------------------------------------------------------------------------------------------
set ylabel ''
filmE0=-0.025324240381

set size   0.52, 0.27
set title '"free" film'
set label 1  "(f) {/Times-Italic l} = 15,  {/Times-Italic d} = 1" at 0.08, -0.05 font "Times-Roman,14"
set origin 0.47, 0.74
set xlabel ''
plot \
     'film-L015-D1-110k0.0000.dat' u 1:($3-filmE0) t '(000)'         w l lt 1,\
     'film-L015-D1-110k0.0833.dat' u 1:($3-filmE0) t '(1/12 1/12 0)' w l lt 4,\
     'film-L015-D1-110k0.2500.dat' u 1:($3-filmE0) t '(1/4 1/4 0)'   w l lt 9,\
     'film-L015-D1-110k0.1250.dat' u 1:($3-filmE0) t '(1/8 1/8 0)'   w l lt 5,\
     'film-L015-D1-110k0.1667.dat' u 1:($3-filmE0) t '(1/6 1/6 0)'   w l lt 8

set size   0.52, 0.241
set title ''
set label 1  "(g) {/Times-Italic l} = 31,  {/Times-Italic d} = 1" at 0.08, -0.007 font "Times-Roman,14"
set origin 0.47, 0.555
set xlabel ''
plot \
     'film-L031-D1-110k0.2500.dat' u 1:($3-filmE0) t '(1/4 1/4 0)'   w l lt 9,\
     'film-L031-D1-110k0.0000.dat' u 1:($3-filmE0) t '(000)'         w l lt 1,\
     'film-L031-D1-110k0.1667.dat' u 1:($3-filmE0) t '(1/6 1/6 0)'   w l lt 8,\
     'film-L031-D1-110k0.0417.dat' u 1:($3-filmE0) t '(1/24 1/24 0)' w l lt 2,\
     'film-L031-D1-110k0.1250.dat' u 1:($3-filmE0) t '(1/8 1/8 0)'   w l lt 5,\
     'film-L031-D1-110k0.0625.dat' u 1:($3-filmE0) t '(1/16 1/16 0)' w l lt 3,\
     'film-L031-D1-110k0.0833.dat' u 1:($3-filmE0) t '(1/12 1/12 0)' w l lt 4

set label 1  "(h) {/Times-Italic l} = 127,  {/Times-Italic d} = 1" at 0.07, -0.007 font "Times-Roman,14"
set origin 0.47, 0.37
set xlabel ''
plot \
     'film-L127-D1-110k0.1667.dat' u 1:($3-filmE0) t '(1/6 1/6 0)'   w l lt 8,\
     'film-L127-D1-110k0.1250.dat' u 1:($3-filmE0) t '(1/8 1/8 0)'   w l lt 5,\
     'film-L127-D1-110k0.0833.dat' u 1:($3-filmE0) t '(1/12 1/12 0)' w l lt 4,\
     'film-L127-D1-110k0.0625.dat' u 1:($3-filmE0) t '(1/16 1/16 0)' w l lt 3,\
     'film-L127-D1-110k0.0417.dat' u 1:($3-filmE0) t '(1/24 1/24 0)' w l lt 2,\
     'film-L127-D1-110k0.0000.dat' u 1:($3-filmE0) t '(000)'         w l lt 1

set label 1  "(i) {/Times-Italic l} = 255,  {/Times-Italic d} = 1" at 0.07, -0.007 font "Times-Roman,14"
set origin 0.47, 0.185
set xlabel ''
plot \
     'epit-L255-D1-110k0.1667.dat' u 1:($3-epitE0) t '(1/6 1/6 0)'   w l lt 8,\
     'epit-L255-D1-110k0.1250.dat' u 1:($3-epitE0) t '(1/8 1/8 0)'   w l lt 5,\
     'epit-L255-D1-110k0.0833.dat' u 1:($3-epitE0) t '(1/12 1/12 0)' w l lt 4,\
     'epit-L255-D1-110k0.0625.dat' u 1:($3-epitE0) t '(1/16 1/16 0)' w l lt 3,\
     'epit-L255-D1-110k0.0417.dat' u 1:($3-epitE0) t '(1/24 1/24 0)' w l lt 2,\
     'epit-L255-D1-110k0.0000.dat' u 1:($3-epitE0) t '(000)'         w l lt 1

set label 1  "(j) {/Times-Italic d} = 0" at 0.08, -0.007 font "Times-Roman,14"
set origin 0.47, 0.0
set xlabel '{/Times-Italic u_z} [\305]'
plot \
     'film-L008-D0-110k0.1667.dat' u 1:($3-filmE0) t '(1/6 1/6 0)'   w l lt 8,\
     'film-L008-D0-110k0.1250.dat' u 1:($3-filmE0) t '(1/8 1/8 0)'   w l lt 5,\
     'film-L008-D0-110k0.0833.dat' u 1:($3-filmE0) t '(1/12 1/12 0)' w l lt 4,\
     'film-L008-D0-110k0.0625.dat' u 1:($3-filmE0) t '(1/16 1/16 0)' w l lt 3,\
     'film-L008-D0-110k0.0417.dat' u 1:($3-filmE0) t '(1/24 1/24 0)' w l lt 2,\
     'film-L008-D0-110k0.0000.dat' u 1:($3-filmE0) t '(000)'         w l lt 1

set nomultiplot
set output
!ps2pdf -sPAPERSIZE=letter all-potential-surface-110.ps > all-potential-surface-110.pdf

#Local variables:
#  compile-command: "gnuplot all-potential-surface.gp && kill -HUP `pgrep gv`"
#End:
