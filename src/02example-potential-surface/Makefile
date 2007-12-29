#-*-Makefile-*- for examples of feram
# Time-stamp: <2007-12-28 16:53:03 takeshi>
# Author: Takeshi NISHIMATSU
##
feram.log: externalE.sh ../feram
	./$<

externalE.sh.ps: externalE.sh Makefile
	LANG=C a2ps --prologue=color --portrait --columns=1 \
	--borders=off -f 9.3 --medium=letter --pretty-print=shell -o - $< > $@

clean:
	rm -f feram.* *.ps *.pdf *lambda*.dat
