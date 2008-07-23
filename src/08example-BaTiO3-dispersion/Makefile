#-*-Makefile-*- for examples of feram
# Time-stamp: <2008-07-23 19:08:57 takeshi>
# Author: Takeshi NISHIMATSU
##
bulk32x32x32.dipole-dipole-long.energy.eps: dipole-dipole.gp dipole-dipole-axis.gp bulk32x32x32.dipole-dipole-long.dat
	./$<

bulk32x32x32.dipole-dipole-long.dat: ../feram bulk32x32x32
	$^

clean:
	rm -f bulk32x32x32.* dipole-dipole-long.eps
