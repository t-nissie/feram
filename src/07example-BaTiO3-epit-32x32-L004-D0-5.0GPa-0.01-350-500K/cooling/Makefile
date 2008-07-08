#-*-Makefile-*- for feram
# Time-stamp: <2008-07-05 22:46:38 t-nissie>
# Author: Takeshi NISHIMATSU
##
all: ../../feram
	@echo TRY: submit bl -exec ./foo.sh -n 2 -J $$PWD -N -u t-nissie-antoine@softbank.ne.jp

%.sh.ps: %.sh
	LANG=C a2ps --prologue=color --portrait --columns=1 \
	--borders=off -f 9.3 --medium=letter --pretty-print=shell -o - $< > $@

clean:
	rm -f FILES *.coord *.dat core* *.param *.log *.out *.err *.ps *.pdf \
	*ing???-???K*
