#-*-Makefile-*- for examples of feram
# Time-stamp: <2016-04-11 15:10:47 takeshi>
# Author: Takeshi NISHIMATSU
##
bulk32x32x32.dipole-dipole-long.energy.eps: dipole-dipole.gp dipole-dipole-axis.gp bulk32x32x32.dipole-dipole-long.dat
	./$<

bulk32x32x32.dipole-dipole-long.dat: ../feram bulk32x32x32.feram
	$^

clean:
	rm -f bulk*.avg bulk*.log bulk*.param.gp bulk*.eps bulk*.dat dipole-dipole-long.eps
