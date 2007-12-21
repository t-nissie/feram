#-*-Makefile-*- for examples of feram
# Time-stamp: <2007-12-20 10:51:27 takeshi>
# Author: Takeshi NISHIMATSU
##
feram.log: externalE.sh ../feram
	./$<

externalE.sh.ps: externalE.sh Makefile
	LANG=C a2ps --prologue=color --portrait --columns=1 \
	--borders=off -f 9.3 --medium=letter --pretty-print=shell -o - $< > $@

clean:
	rm -f *.coord *.dat core* *.eps *.param *.avg *.log *.out *.err *.ps externalE???K???-* externalE???K???+*
