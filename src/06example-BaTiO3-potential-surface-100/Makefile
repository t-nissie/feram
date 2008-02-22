#-*-Makefile-*- for examples of feram
# Time-stamp: <2008-02-22 14:21:49 takeshi>
# Author: Takeshi NISHIMATSU
##
all: potential-surface-100.sh
	sh $<

potential-surface-100.sh: ../05example-BaTiO3-potential-surface-110/potential-surface-110.sh Makefile
	sed -e 's/-110/-100/' -e 's/$$k_stripe $$k_stripe 0.0/$$k_stripe 0.0       0.0/' $< > $@

all-potential-surface-100.ps: all-potential-surface-100.gp
	./$<

clean:
	rm -f feram.* *.ps *.pdf *110k*.dat
