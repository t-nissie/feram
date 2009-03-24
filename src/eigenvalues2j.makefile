#-*-Makefile-*- for eigenvalues2j
# Time-stamp: <2009-03-24 23:32:58 takeshi>
# Author: Takeshi NISHIMATSU
##
BASENAME = bulk32x32x32

eigenvalues2j.eps: eigenvalues2j.gp $(BASENAME).dipole-dipole-long+short.dat
	./$<

$(BASENAME).dipole-dipole-long+short.dat: feram $(BASENAME)
	./$< $(BASENAME)

clean:
	rm -f $(BASENAME).* eigenvalues2j.eps
