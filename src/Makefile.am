#-*-Makefile-*- for feram
# Time-stamp: <2011-10-24 12:30:21 takeshi>
# Author: Takeshi NISHIMATSU
##
FC=@FC@
F77=$(FC)
AM_FFLAGS=@FCFLAGS@
bin_PROGRAMS = feram diagonalize15x15 displacement eigenvalues2j frozen_phonon_Gamma frozen_phonon_X marsaglia_tsang_uni64_check

feram_MODULES = param_module.F coord_module.F energy_module.F
feram_SRCS = average_module.F \
	dVddi-dipole-dipole.F \
	dVddi-homo-coupling.F \
	dVddi-unharmonic.F \
	dVddi_E_field.F \
	date_and_time2message.F \
	decay-functions.f \
	dipoFFT.F \
	dipole-dipole-long-range.F \
	dipole-dipole-short-range.F \
	dipole-dipole.F \
	elastic.F \
	feram.F \
	feram_common.F \
	fft.F \
	hysteresis_loop.F \
	initialize_E_field.F \
	initialize-dipoR.F \
	leapfrog.F \
	read_defects_u.F \
	marsaglia_tsang_uni64_module.f \
	mirror.F \
	mirror_force_mirror.F \
	molecular-dynamics.F \
	msg.F \
	nose-poincare.F \
	optimize-homo-strain.F \
	optimize-inho-strain.F \
	potentials.F \
	print-eigenvalues.F
feram_SOURCES = $(feram_MODULES) $(feram_SRCS)
feram_LDADD = $(LDADD) ../libblaslapack/libblaslapack.a $(LIBBUILT_IN_FFT_A)
feram_DEPENDENCIES =   ../libblaslapack/libblaslapack.a $(LIBBUILT_IN_FFT_A)

diagonalize15x15_SOURCES = diagonalize15x15.F
diagonalize15x15_LDADD = $(LDADD) ../libblaslapack/libblaslapack.a
diagonalize15x15_DEPENDENCIES =   ../libblaslapack/libblaslapack.a

displacement_SOURCES = displacement.F

eigenvalues2j_SOURCES = eigenvalues2j.F msg.F param_module.F
eigenvalues2j_LDADD = $(LDADD) ../libblaslapack/libblaslapack.a
eigenvalues2j_DEPENDENCIES =   ../libblaslapack/libblaslapack.a

frozen_phonon_Gamma_SOURCES = frozen_phonon_Gamma.F
frozen_phonon_Gamma_LDADD = $(LDADD) ../libblaslapack/libblaslapack.a
frozen_phonon_Gamma_DEPENDENCIES =   ../libblaslapack/libblaslapack.a

frozen_phonon_X_SOURCES = frozen_phonon_X.F
frozen_phonon_X_LDADD = $(LDADD) ../libblaslapack/libblaslapack.a
frozen_phonon_X_DEPENDENCIES =   ../libblaslapack/libblaslapack.a

marsaglia_tsang_uni64_check_SOURCES = marsaglia_tsang_uni64_check.F marsaglia_tsang_uni64_module.f
TESTS = marsaglia_tsang_uni64_check

CLEANFILES = *.mod *.ps *.pdf
EXTRA_DIST = define.h \
cross-section-dVddi.sh \
cross-section-p.sh \
cross-section-q.sh \
decay-test.gp \
defects-maker.rb \
epit.gp \
inhomo-K.gp \
plot.gp \
slicer.rb \
splot.gp \
feram_mpi.F \
03example-BaTiO3-bulk-phase-transition \
10example-PbTiO3-DDB2short \
11example-BaTiO3-new-hysteresis-loop \
15example-BaTiO3-new-param-defects

../libblaslapack/libblaslapack.a:
	cd ../libblaslapack && $(MAKE)

../libbuilt_in_fft/libbuilt_in_fft.a:
	cd ../libbuilt_in_fft && $(MAKE)

# all: plot.ps # 300K0000000.ps decay-test.ps

# feram.out: $(INPUT_FILE) feram
# 	./feram < $< | tee $@

# crosssection: crosssection.gp
# 	gnuplot $<

# decay-test: decay-test.o decay-functions.o
# 	$(FC) $(FFLAGS) -o $@ $^

# decay-test.ps: decay-test.gp decay-test feram.out
# 	gnuplot $<

elastic.o: $(srcdir)/elastic.F
	$(PPF77COMPILE:-Os=-O3) -c -o $@ $<

feram_mpi$(EXEEXT): $(srcdir)/feram_mpi.F $(feram_OBJECTS) $(feram_DEPENDENCIES)
	mpif90 $(DEFS) $(DEFAULT_INCLUDES) $(INCLUDES) $(AM_CPPFLAGS) $(CPPFLAGS) \
	       $(AM_FFLAGS) $(FFLAGS) -c $(srcdir)/feram_mpi.F
	mpif90 $(AM_FFLAGS) $(FFLAGS) $(AM_LDFLAGS) $(LDFLAGS) -o $@ $(feram_OBJECTS:feram.o=feram_mpi.o) $(feram_LDADD) $(LIBS)

feram_common.o: param_module.o coord_module.o date_and_time2message.o
decay-functions.o param_module.o:             define.h
feram.o potentials.o dipole-dipole.o:\
                                param_module.o coord_module.o define.h
initialize-dipoR.o dVddi-unharmonic.o leapfrog.o \
optimize-homo-strain.o:energy_module.o param_module.o coord_module.o
energy_module.o: param_module.o coord_module.o
optimize-homo-strain.o:energy_module.o param_module.o coord_module.o
optimize-inho-strain.o:energy_module.o param_module.o coord_module.o
molecular-dynamics.o:  energy_module.o param_module.o coord_module.o average_module.o
mirror.o dipoFFT.o dVddi-homo-coupling.o dVddi-unharmonic.o potential.o:\
                                param_module.o coord_module.o
initialize_E_field.o read_defects_u.o elastic.o:\
                                param_module.o coord_module.o define.h
initialize-dipoR.o:             param_module.o coord_module.o energy_module.o define.h marsaglia_tsang_uni64_module.o
nose-poincare.o leapfrog.o mirror_force_mirror.o dVddi_E_field.o:\
                                param_module.o coord_module.o energy_module.o
hysteresis_loop.o average_module.o:\
                                param_module.o coord_module.o energy_module.o define.h
coord_module.o fft.o:           param_module.o         define.h
dipole-dipole-long-range.o:     param_module.o         define.h fft.o
dipole-dipole-short-range.o:    param_module.o                  fft.o
dVddi-dipole-dipole.o: energy_module.o param_module.o coord_module.o          fft.o
print-eigenvalues.o eigenvalues2j.o frozen_phonon_Gamma.o frozen_phonon_X.o: define.h
eigenvalues2j.o: param_module.o

pdf: feram.pdf coord_module.pdf param_module.pdf
.ps.pdf:
	ps2pdf -sPAPERSIZE=a4 $< $@

.F.ps:
	a2ps --prologue=color --portrait --columns=1 --margin=3 \
	--borders=off \
	-f 9.7 --pretty-print=for90-free -o - $< > $@

.f.ps:
	a2ps --prologue=color --portrait --columns=1 --margin=3 \
	--borders=off \
	-f 11.0 --pretty-print=for90-free -o - $< > $@

#diff: param.F
#	diff -u -w $< $(INPUT_FILE) ; true
#	egrep 'read.* DUMMY' $< | cut -b 20- > param.read_dummy
#	diff -u -w param.read_dummy $(INPUT_FILE) ; true
#	egrep "write.*'!" $< | cut -b 21- | sed "s/'$$//" > param.write_dummy
#	diff -u -w param.read_dummy param.write_dummy
