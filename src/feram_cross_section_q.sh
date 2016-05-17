#!/bin/sh
# feram_cross_section_q.sh
# Time-stamp: <2016-05-17 11:33:52 takeshi>
# Author: Takeshi NISHIMATSU
# Usage: ./feram_cross_section_X.sh coord-file [FACTOR] [CONST_Alpha] [Alpha] [ratio] [max_z]
#  (X=q, p, dVddi; Alpha=x,y,z)
# Example1: ./feram_cross_section_q.sh 150K0000000.coord
# Example2: ./feram_cross_section_p.sh 150K0000000.coord 0.5 10
# Example3: /SOMEWHERE/feram_cross_section_q.sh 140K0050000.coord 4.0 10 y 0.9
# Arguments:
#  [FACTOR]      X*[FACTOR] will be the length of each arrow.
#                Default values depend on X=q, p, dVddi.
#  [CONST_Alpha] Visulaize cross sections of alpha=[CONST_Alpha]. Default value: 8.
#  [Alpha]       Alpha=x,y,z. Default value: x.
#  [ratio]       Optional argument to keep the shape of unitcell square exactly.
#                You may want to use this argument when Lx=Ly!=Lz. Default value: 0.7231.
#  [max_z]       It is useful for vertical cross section of a thin-film.
# Caution:
#  Do NOT rename this file!
##
FILENAME=$1
BASENAME=`basename $1 .coord`

case "$0" in
    *feram_cross_section_q.sh)
	EPSFILE=$BASENAME-q
	COLOR='$6'
	FACTOR=5.0 ;;
    *feram_cross_section_p.sh)
	EPSFILE=$BASENAME-p
	COLOR='$9'
	FACTOR=0.2 ;;
    *feram_cross_section_dVddi.sh)
	EPSFILE=$BASENAME-dVddi
	COLOR='$12'
	FACTOR=0.5 ;;
    *feram_cross_section_acouR.sh)
	EPSFILE=$BASENAME-acouR
	COLOR='$15'
	FACTOR=5.0 ;;
esac

if [ ! -r "$1" ]; then
    echo $0: cannot read the file $1.
    exit 1
fi

if [ "$2" ]; then
    FACTOR=$2
fi

if [ "$3" ]; then
    CONST_Alpha=`printf "%4i" $3`
else
    CONST_Alpha='   8'
fi

case "$4" in
    z)
	Alpha=z
	LH='x'
	LV='y'
	H_COORD='$1'
	V_COORD='$2'
        case "$0" in
	    *feram_cross_section_q.sh)
		H_VALUE='$4'
		V_VALUE='$5' ;;
	    *feram_cross_section_p.sh)
		H_VALUE='$7'
		V_VALUE='$8' ;;
	    *feram_cross_section_dVddi.sh)
		H_VALUE='$10'
		V_VALUE='$11';;
	    *feram_cross_section_acouR.sh)
		H_VALUE='$13'
		V_VALUE='$14';;
	esac
	EGREP_ARG="\"^[ 0-9]*[0-9] [ 0-9]*[0-9] $CONST_Alpha \"" ;;
    y)
	Alpha=y
	LH='x'
	LV='z'
	H_COORD='$1'
	V_COORD='$3'
        case "$0" in
	    *feram_cross_section_q.sh)
		H_VALUE='$4'
		V_VALUE='$6' ;;
	    *feram_cross_section_p.sh)
		H_VALUE='$7'
		V_VALUE='$9' ;;
	    *feram_cross_section_dVddi.sh)
		H_VALUE='$10'
		V_VALUE='$12';;
	    *feram_cross_section_acouR.sh)
		H_VALUE='$13'
		V_VALUE='$15';;
	esac
	EGREP_ARG="\"^[ 0-9]*[0-9] $CONST_Alpha [ 0-9]*[0-9] \"" ;;
    *)
	Alpha=x
	LH='y'
	LV='z'
	H_COORD='$2'
	V_COORD='$3'
        case "$0" in
	    *feram_cross_section_q.sh)
		H_VALUE='$5'
		V_VALUE='$6' ;;
	    *feram_cross_section_p.sh)
		H_VALUE='$8'
		V_VALUE='$9' ;;
	    *feram_cross_section_dVddi.sh)
		H_VALUE='$11'
		V_VALUE='$12';;
	    *feram_cross_section_acouR.sh)
		H_VALUE='$14'
		V_VALUE='$15';;
	esac
	EGREP_ARG="\"^$CONST_Alpha [ 0-9]*[0-9] [ 0-9]*[0-9] \"" ;;
esac

if [ "$5" ]; then
    RATIO=$5
else
    RATIO=1.48
fi

if [ "$6" ]; then
    YRANGE="[-0.5:$6-0.5]"
else
    YRANGE="[-0.5:L$LV-0.5]"
fi

EPSFILE=$EPSFILE-$Alpha.eps
H_LABEL="'{/Times-Italic $LH}'"
V_LABEL="'{/Times-Italic $LV}'"

gnuplot <<EOF
call 'param.gp'
set terminal postscript eps enhanced color solid "Times-Roman" 32
set output '$EPSFILE'

set xtics 0.5,1.0
set ytics 0.5,1.0
set xlabel $H_LABEL
set ylabel $V_LABEL
set format x ""
set format y ""
set grid
set size 1,$RATIO
set nokey

set xrange [-0.5:L$LH-0.5]
set yrange $YRANGE

set title '$BASENAME   $Alpha=$CONST_Alpha'
plot \
  '< egrep $EGREP_ARG $FILENAME' \
  using ($H_COORD-$H_VALUE*$FACTOR/2):($V_COORD-$V_VALUE*$FACTOR/2):\
  ($COLOR<0?0:$H_VALUE*$FACTOR):($COLOR<0?0:$V_VALUE*$FACTOR) \
  with vec lt 1 lw 2,\
  '< egrep $EGREP_ARG $FILENAME' \
  using ($H_COORD-$H_VALUE*$FACTOR/2):($V_COORD-$V_VALUE*$FACTOR/2):\
  ($COLOR>0?0:$H_VALUE*$FACTOR):($COLOR>0?0:$V_VALUE*$FACTOR) \
  with vec lt 3 lw 2
EOF
