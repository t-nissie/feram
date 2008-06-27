#-*-Makefile-*- for examples of feram
# Time-stamp: <2008-01-21 15:06:51 takeshi>
# Author: Takeshi NISHIMATSU
##
feram.log: externalE.sh ../feram
	./$<

%.sh.ps: %.sh
	LANG=C a2ps --prologue=color --portrait --columns=1 \
	--borders=off -f 9.3 --medium=letter --pretty-print=shell -o - $< > $@

clean:
	rm -f *.coord *.dat core* *.param *.log *.out *.err *.ps *.pdf \
	*ing???-???K*
