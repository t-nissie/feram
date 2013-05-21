#-*-Makefile-*- Example of leapfrog MD simulations with feram
# Time-stamp: <2013-05-21 10:27:58 takeshi>
# Author: Takeshi NISHIMATSU
##
all: leapfrog.sh ../../feram
	./$<

%.sh.ps: %.sh
	LANG=C a2ps --prologue=color --portrait --columns=1 \
	--borders=off -f 9.3 --medium=letter --pretty-print=shell -o - $< > $@

clean:
	rm -f *.coord *.dat core* *.param.gp *.log *.out *.err *.ps *.pdf \
	leapfrog0* leapfrog.avg
