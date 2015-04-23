#!/usr/bin/env gnuplot
# feram_defects_maker_check_sphere.gp
# Time-stamp: <2015-04-23 11:55:31 takeshi>
# Author: Takeshi NISHIMATSU
# Usage: gnuplot -e 'basename="feram_defects_maker_check"; binwidth=1.8' feram_defects_maker_check_sphere.gp
##
set title 'randomly placed points on a sphere'
set terminal postscript portrait color dashed "Times-Roman" 24
defects_file = basename.".defects"
set output basename."_sphere.eps"
set nokey
set border 0
set noxtics
set noytics
set noztics
set arrow 1 from -binwidth,0,0 to binwidth,0,0 lt 1 lc 7 lw 3
set arrow 2 from 0,-binwidth,0 to 0,binwidth,0 lt 1 lc 7 lw 3
set arrow 3 from 0,0,-binwidth to 0,0,binwidth lt 1 lc 7 lw 3
set size 1.0,0.77
splot defects_file using 4:5:6 with dots
set output
