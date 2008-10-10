#-*-Makefile-*- for examples of feram
# Time-stamp: <2008-10-09 21:50:54 t-nissie>
# Author: Takeshi NISHIMATSU
##
feram.log: leapfrog.sh ../../feram
	./$< > $@

%.sh.ps: %.sh
	LANG=C a2ps --prologue=color --portrait --columns=1 \
	--borders=off -f 9.3 --medium=letter --pretty-print=shell -o - $< > $@

clean:
	rm -f *.coord *.dat core* *.param *.log *.out *.err *.ps *.pdf \
	leapfrog0* FILES leapfrog.avg
