#-*-Makefile-*- for examples of feram
# Time-stamp: <2014-10-15 18:44:13 t-nissie>
# Author: Takeshi NISHIMATSU
##
bulk32x32x32.dipole-dipole-long.energy.eps: dipole-dipole.gp dipole-dipole-axis.gp bulk32x32x32.dipole-dipole-long.dat
	./$<

bulk32x32x32.dipole-dipole-long.dat: ../feram bulk32x32x32.feram
	$^

clean:
	rm -f bulk32x32x32.* dipole-dipole-long.eps
