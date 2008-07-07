#-*-Makefile-*- for examples of feram
# Time-stamp: <2008-07-07 19:49:43 takeshi>
# Author: Takeshi NISHIMATSU
##
feram.log: externalE.sh ../feram
	./$<

externalE.sh.ps: externalE.sh Makefile
	LANG=C a2ps --prologue=color --portrait --columns=1 \
	--borders=off -f 9.3 --medium=letter --pretty-print=shell -o - $< > $@

clean:
	rm -f *.coord *.dat core* *.param externalE[12345]*.avg *.log *.out *.err *.ps \
	externalE???K???-* externalE???K???+* FILES
