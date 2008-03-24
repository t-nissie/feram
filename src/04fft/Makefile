#-*-Makefile-*- for examples of feram
# Time-stamp: <2008-03-24 19:22:24 takeshi>
# Author: Takeshi NISHIMATSU
##
BASENAME=epit-40x40-L007-D1-5.0GPa-100K

all: feram.log
	./cont.gp
	../slicer.rb $(BASENAME).0001000.coord 3

feram.log: ../feram epit-40x40-L007-D1-5.0GPa-100K
	$^ > $@

clean:
	rm -f epit*.coord *.dat core* *.param *.log *.out *.err *.eps *.avg *.fft
