#-*-Makefile-*- for examples of feram
# Time-stamp: <2014-10-15 19:02:45 t-nissie>
# Author: Takeshi NISHIMATSU
##
bulk32x32x32.dipole-dipole-long.energy.eps: dipole-dipole.gp dipole-dipole-axis.gp bulk32x32x32.dipole-dipole-long.dat
	./$<

bulk32x32x32.dipole-dipole-long.dat: ../feram bulk32x32x32.feram
	$^

clean:
	rm -f bulk32x32x32.avg bulk32x32x32.log bulk32x32x32.param.gp bulk32x32x32.*.eps bulk32x32x32.*.dat dipole-dipole-long.eps
