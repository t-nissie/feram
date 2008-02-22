#-*-Makefile-*- for examples of feram
# Time-stamp: <2008-02-22 14:13:48 takeshi>
# Author: Takeshi NISHIMATSU
##
all: potential-surface-100.sh
	sh $<

potential-surface-100.sh: ../05example-BaTiO3-potential-surface-110/potential-surface-110.sh
	sed -e 's/110/100/' $< > $@

all-potential-surface-100.ps: all-potential-surface-100.gp
	./$<

clean:
	rm -f feram.* *.ps *.pdf *110k*.dat
