# hl-hysteresis.gp
# Time-stamp: <2015-05-14 13:08:08 t-nissie>
# Author: Takeshi NISHIMATSU
# Usage$ for hl in *.hl; do gnuplot -e hl=\"$hl\" hl-hysteresis.gp; done
##
#set encoding iso_8859_1
set notitle
set grid
set terminal postscript portrait solid color 'Times-Roman' 20
set output hl.".eps"
set xrang [-900:900]
set key bottom right
maxy=35.0
set yrang [-maxy:maxy]
set xlabel '{/Times-Italic E} [kV/cm]'
set ylabel '{/Times-Italic P_z} [{/Symbol m}C / cm^{2}]'
#set format y "%.2f"
set xtics 200
c=1.6e3*9.956/3.94**3
vertical_line=sprintf("< (echo 0 %.2f; echo 0 %.2f)", -maxy, maxy)

plot vertical_line title '' w l lt 3,\
     0             title '' w l lt 3,\
     hl using ( $5*100000.0):( $14*c) title hl w l lt 1 lw 1

set output
#Local variables:
#  compile-command: "for hl in *.hl; do gnuplot -e hl=\\\"$hl\\\" hl-hysteresis.gp; done"
#End:
