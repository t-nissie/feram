# -*-Makefile-*-
##
DDB_FILES = perovskite-M_o_DS1_DDB \
            perovskite-R_o_DS1_DDB \
            perovskite-Sigma_o_DS1_DDB \
            perovskite-X_o_DS1_DDB \
            perovskite-Delta_o_DS1_DDB \
            perovskite-T_o_DS1_DDB \
            perovskite-Z_o_DS1_DDB \
            perovskite-Lambda_o_DS1_DDB \
            perovskite-S_o_DS1_DDB

all: perovskite-Gamma_o_DS1_WFK $(DDB_FILES)

perovskite-Gamma_o_DS1_WFK: perovskite-Gamma.files perovskite-Gamma.in 82pb.960808c.mod 22ti.psp.mod 8o.phoney.mod abinis
	./abinis < $< > `basename $< .files`.log

perovskite-%_o_DS1_DDB: perovskite-%.files perovskite-%.in             82pb.960808c.mod 22ti.psp.mod 8o.phoney.mod abinis perovskite-Gamma_o_DS1_WFK
	./abinis < $< > `basename $< .files`.log

diagonalize: perovskite-diagonalize.out
perovskite-diagonalize.out: ../diagonalize15x15 perovskite-Gamma_o_DS1_WFK perovskite-M_o_DS1_DDB perovskite-R_o_DS1_DDB perovskite-Sigma_o_DS1_DDB perovskite-X_o_DS1_DDB
	tail -324 perovskite-Gamma_o_DS3_DDB | $< > $@
	tail -225 perovskite-M_o_DS1_DDB     | $< >> $@
	tail -225 perovskite-R_o_DS1_DDB     | $< >> $@
	tail -225 perovskite-Sigma_o_DS1_DDB | $< >> $@
	tail -225 perovskite-X_o_DS1_DDB     | $< >> $@

merge: perovskite-mrgddb.out
perovskite-mrgddb.out: perovskite-mrgddb.in perovskite-Gamma_o_DS3_DDB $(DDB_FILES)
	./mrgddb < $< | tee perovskite-mrgddb.log

analyze: perovskite-anaddb.out
analyse: perovskite-anaddb.out
perovskite-anaddb.out: perovskite-anaddb.files perovskite-anaddb.in perovskite-mrgddb.out
	./anaddb < $< | tee perovskite-anaddb.log

plot: perovskite-plot_band2eps.freq
perovskite-plot_band2eps.freq: perovskite-plot.files perovskite-plot.in perovskite-mrgddb.out
	./anaddb < $< | tee perovskite-plot.log

eps: perovskite-band2eps.eps
perovskite-band2eps.eps: perovskite-band2eps.files perovskite-band2eps.in perovskite-plot_band2eps.freq
	./band2eps < $< | tee perovskite-band2eps.log

allclean:
	rm -f *.out *.out? *_o_* *_LOG_* *.log *_STATUS* perovskite*.out *.err *.log core
