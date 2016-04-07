# -*-Makefile-*- for src/33example-BaTiO3-9.33-11.33-relaxor/
##
DIR24 = ../24example-BaTiO3-new-param-heating-cooling
all: random orderd orderd.gp
	sed -e 's/10\.33000/9.33 11.33 9.33/'\
            -e 's/cooling/random-cooling/'\
            -e '/fi$$/a ln -sf random $$filename.relaxor' $(DIR24)/cooling.sh > random-cooling.sh
	sed -e 's/10\.33000/9.33 11.33 9.33/'\
            -e 's/heating/random-heating/'\
            -e '/fi$$/a ln -sf random $$filename.relaxor' $(DIR24)/heating.sh > random-heating.sh
	sed -e 's/10\.33000/9.33 11.33 9.33/'\
            -e 's/cooling/orderd-cooling/'\
            -e '/fi$$/a ln -sf orderd $$filename.relaxor' $(DIR24)/cooling.sh > orderd-cooling.sh
	sed -e 's/10\.33000/9.33 11.33 9.33/'\
            -e 's/heating/orderd-heating/'\
            -e '/fi$$/a ln -sf orderd $$filename.relaxor' $(DIR24)/heating.sh > orderd-heating.sh
	chmod 755 *.sh

random: ../feram_defects_maker.rb
	$< 16 16 16 2 2048 2134567890 > $@

orderd: ../feram_fcc_maker.rb
	$< 16 16 16 2 > $@

orgerd.gp: random.gp
	sed -e 's/random/orderd/' $< > $@

clean:
	rm -f *.sh random orderd *K* *.eps *.pdf
