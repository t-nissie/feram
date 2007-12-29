#!/usr/bin/env gnuplot
# Time-stamp: <07/12/29 10:15:23 takeshi>
# Author: Takeshi NISHIMATSU
# ref_1: R. D. King-Smith and David Vanderbilt: PRB vol.49 p.5828 (1994)
##
set grid
set bmargin 4
set xrange [0:0.20]
set ytics 0.01
set format x "%.2f"
set format y "%.2f"

set ylabel '{/Times-Italic E} [eV / unit cell]'
set key bottom left
set yrange [-0.06:0.0]

set terminal postscript portrait enhanced dashed color 'Times-Roman' 12
set output  'all-potential-surface.ps'
set multiplot

epitE0=0.024003715545

set label 1  "(a) {/Times-Italic l} = 15,  {/Times-Italic d} = 1" at 0.085, -0.007 font "Times-Roman,16"
set origin 0.0, 0.745
set size   0.6, 0.241
set xlabel ''
plot 'epit-L015-D1-lambda002.dat' u 1:($3-epitE0) t '{/Symbol l} =  2'             w lp,\
     'epit-L015-D1-lambda004.dat' u 1:($3-epitE0) t '{/Symbol l} =  4'             w lp,\
     'epit-L015-D1-lambda008.dat' u 1:($3-epitE0) t '{/Symbol l} =  8'             w lp,\
     'epit-L015-D1-lambda016.dat' u 1:($3-epitE0) t '{/Symbol l} = 16'             w lp,\
     'epit-L015-D1-lambda000.dat' u 1:($3-epitE0) t '{/Symbol l} = {/Symbol \245}' w lp

# set label 1  "(b) {/Times-Italic l} = 31,  {/Times-Italic d} = 1" at 0.085, -0.007 font "Times-Roman,16"
# set key 0.045, -0.024 spacing 1.3
# set origin 0.0, 0.52
# set size   0.6, 0.28
# set xlabel ''
# set yrange [-0.05:0.0]
# plot 'stripe.16x16-31-01-0.01-5GPa-wl002.dat' u 1:($2-epitE0) t '{/Symbol l} =  2'             w lp,\
#      'stripe.16x16-31-01-0.01-5GPa-wl004.dat' u 1:($2-epitE0) t '{/Symbol l} =  4'             w lp,\
#      'stripe.16x16-31-01-0.01-5GPa-wl008.dat' u 1:($2-epitE0) t '{/Symbol l} =  8'             w lp,\
#      'stripe.16x16-31-01-0.01-5GPa-wl016.dat' u 1:($2-epitE0) t '{/Symbol l} = 16'             w lp,\
#      'stripe.16x16-31-01-0.01-5GPa-wlINF.dat' u 1:($2-epitE0) t '{/Symbol l} = {/Symbol \245}' w lp

# set label 1  "(c) {/Times-Italic l} = 127,  {/Times-Italic d} = 1" at 0.085, -0.007 font "Times-Roman,16"
# set key 0.045, -0.033 spacing 1.3
# set origin 0.0, 0.255
# set size   0.6, 0.32
# set xlabel ''
# set yrange [-0.060:0.0]
# plot 'stripe.16x16-127-01-0.01-5GPa-wl002.dat' u 1:($2-epitE0) t '{/Symbol l} =  2'             w lp,\
#      'stripe.16x16-127-01-0.01-5GPa-wl004.dat' u 1:($2-epitE0) t '{/Symbol l} =  4'             w lp,\
#      'stripe.16x16-127-01-0.01-5GPa-wl008.dat' u 1:($2-epitE0) t '{/Symbol l} =  8'             w lp,\
#      'stripe.16x16-127-01-0.01-5GPa-wl016.dat' u 1:($2-epitE0) t '{/Symbol l} = 16'             w lp,\
#      'stripe.16x16-127-01-0.01-5GPa-wlINF.dat' u 1:($2-epitE0) t '{/Symbol l} = {/Symbol \245}' w lp

# set label 1  "(d) {/Times-Italic l} = {/Symbol \245}" at 0.085, -0.007 font "Times-Roman,16"
# set key 0.045, -0.033 spacing 1.3
# set origin 0.0,-0.01
# set size   0.6, 0.32
# set xlabel '{/Times-Italic u_z} [@^{/Symbol \ \260}A]'
# set yrange [-0.060:0.0]
# plot 'stripe.16x16-256-00-0.01-5GPa-wl002.dat' u 1:($2-epitE0) t '{/Symbol l} =  2'             w lp,\
#      'stripe.16x16-256-00-0.01-5GPa-wl004.dat' u 1:($2-epitE0) t '{/Symbol l} =  4'             w lp,\
#      'stripe.16x16-256-00-0.01-5GPa-wl008.dat' u 1:($2-epitE0) t '{/Symbol l} =  8'             w lp,\
#      'stripe.16x16-256-00-0.01-5GPa-wl016.dat' u 1:($2-epitE0) t '{/Symbol l} = 16'             w lp,\
#      'stripe.16x16-256-00-0.01-5GPa-wlINF.dat' u 1:($2-epitE0) t '{/Symbol l} = {/Symbol \245}' w lp


#Local variables:
#  compile-command: "gnuplot all-potential-surface.gp && kill -HUP `pgrep gv`"
#End:
