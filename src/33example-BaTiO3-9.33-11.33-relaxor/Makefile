# -*-Makefile-*-
##
DIR24 = ../24example-BaTiO3-new-param-heating-cooling
all:
	sed -e 's/10\.33000/9.33 11.33 9.33/' -e '/fi$$/a ln -sf relaxor $$filename.relaxor' $(DIR24)/cooling.sh > cooling.sh
	sed -e 's/10\.33000/9.33 11.33 9.33/' -e '/fi$$/a ln -sf relaxor $$filename.relaxor' $(DIR24)/heating.sh > heating.sh
	chmod 755 cooling.sh heating.sh
	../feram_defects_maker.rb 16 16 16 2 2048 2134567890 > relaxor
clean:
	rm -f cooling.sh heating.sh relaxor *K*
