# -*-Makefile-*-
##
all: perovskite-Gamma_o_DS1_WFK \
     perovskite-M_o_DS1_DDB \
     perovskite-R_o_DS1_DDB \
     perovskite-Sigma_o_DS1_DDB \
     perovskite-X_o_DS1_DDB

perovskite-Gamma_o_DS1_WFK: perovskite-Gamma.files perovskite-Gamma.in 82pb.960808c.mod 22ti.psp.mod 8o.phoney.mod abinis
	./abinis < $< > `basename $< .files`.log

perovskite-%_o_DS1_DDB: perovskite-%.files perovskite-%.in pot_A pot_B pot_O abinis perovskite-Gamma_o_DS1_WFK
	./abinis < $< > `basename $< .files`.log

diagonalize: ../diagonalize15x15 all
	tail -324 perovskite-Gamma_o_DS3_DDB | $<
	tail -225 perovskite-M_o_DS1_DDB     | $<
	tail -225 perovskite-R_o_DS1_DDB     | $<
	tail -225 perovskite-Sigma_o_DS1_DDB | $<
	tail -225 perovskite-X_o_DS1_DDB     | $<

allclean:
	rm -f *.out *.out? *_o_* *_LOG_* *.log *_STATUS* *.out *.err *.log core
