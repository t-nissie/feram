#-*-Makefile-*- for feram
# Time-stamp: <2009-02-26 14:56:17 t-nissie>
# Author: Takeshi NISHIMATSU
##
FC=@FC@
F77=$(FC)
AM_FFLAGS=@FCFLAGS@
bin_PROGRAMS = feram diagonalize15x15 DDB2short frozen_phonon_Gamma frozen_phonon_X

feram_MODULES = param_module.F coord_module.F energy_module.F
feram_SRCS = average_module.F \
	cholesky_z.f \
	cholesky_d.f \
	dVddi-dipole-dipole.F \
	dVddi-homo-coupling.F \
	dVddi-unharmonic.F \
	dVddi_E_field.F \
	decay-functions.f \
	dipoFFT.F \
	dipole-dipole-long-range.F \
	dipole-dipole-short-range.F \
	dipole-dipole.F \
	elastic.F \
	feram.F \
	fft.F \
	hysteresis_loop.F \
	initialize_E_field.F \
	initialize-dipoR.F \
	leapfrog.F \
	make-mass-matrix.F \
	mirror.F \
	mirror_force_mirror.F \
	molecular-dynamics.F \
	msg.F \
	normal.F \
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

DDB2short_SOURCES = DDB2short.F msg.F param_module.F
DDB2short_LDADD = $(LDADD) ../libblaslapack/libblaslapack.a
DDB2short_DEPENDENCIES =   ../libblaslapack/libblaslapack.a

frozen_phonon_Gamma_SOURCES = frozen_phonon_Gamma.F
frozen_phonon_Gamma_LDADD = $(LDADD) ../libblaslapack/libblaslapack.a
frozen_phonon_Gamma_DEPENDENCIES =   ../libblaslapack/libblaslapack.a

frozen_phonon_X_SOURCES = frozen_phonon_X.F
frozen_phonon_X_LDADD = $(LDADD) ../libblaslapack/libblaslapack.a
frozen_phonon_X_DEPENDENCIES =   ../libblaslapack/libblaslapack.a

CLEANFILES = *.mod *.ps *.pdf
EXTRA_DIST = define.h \
cross-section-dVddi.sh \
cross-section-p.sh \
cross-section-q.sh \
decay-test.gp \
epit.gp \
inhomo-K.gp \
plot.gp \
slicer.rb \
splot.gp \
01example-BaTiO3-epit-hysteresis-loop \
03example-BaTiO3-bulk-phase-transition \
07example-BaTiO3-epit-32x32-L004-D0-5.0GPa-0.01-350-500K \
08example-BaTiO3-dispersion \
09example-BaTiO3-bulk-leap-frog \
10example-PbTiO3-DDB2short \
11example-BaTiO3-new-hysteresis-loop

../libblaslapack/libblaslapack.a:
	cd ../libblaslapack && $(MAKE)

../libbuilt_in_fft/libbuilt_in_fft.a:
	cd ../libbuilt_in_fft && $(MAKE)

cholesky_d.f: cholesky_z.f
	sed -e 's/complex\*16/real*8/' -e 's/_z/_d/' $< > $@

# all: plot.ps # 300K0000000.ps decay-test.ps

# feram.out: $(INPUT_FILE) feram
# 	./feram < $< | tee $@

# crosssection: crosssection.gp
# 	gnuplot $<

# hensachi: hensachi.o normal.o
# 	$(FC) $(FFLAGS) -o $@ $^ $(LIBS)

# decay-test: decay-test.o decay-functions.o
# 	$(FC) $(FFLAGS) -o $@ $^

# decay-test.ps: decay-test.gp decay-test feram.out
# 	gnuplot $<

feram.o: param_module.o coord_module.o
normal.o decay-functions.o param_module.o:             define.h
feram.o potentials.o dipole-dipole.o:\
                                param_module.o coord_module.o define.h
initialize-dipoR.o dVddi-unharmonic.o leapfrog.o \
optimize-homo-strain.o:energy_module.o param_module.o coord_module.o
energy_module.o: param_module.o coord_module.o
optimize-homo-strain.o:energy_module.o param_module.o coord_module.o cholesky_d.o
optimize-inho-strain.o:energy_module.o param_module.o coord_module.o cholesky_z.o
molecular-dynamics.o:  energy_module.o param_module.o coord_module.o average_module.o
dipoFFT.o elastic.o dVddi-homo-coupling.o dVddi-unharmonic.o make-mass-matrix.o potential.o:\
                                param_module.o coord_module.o
initialize_E_field.o:           param_module.o coord_module.o define.h
initialize-dipoR.o average_module.o:\
                                param_module.o coord_module.o energy_module.o define.h
nose-poincare.o leapfrog.o mirror_force_mirror.o:\
                                param_module.o coord_module.o energy_module.o
coord_module.o:                 param_module.o         define.h
mirror.o fft.o:                 param_module.o
dipole-dipole-long-range.o:     param_module.o         define.h fft.o
dipole-dipole-short-range.o:    param_module.o                  fft.o
dVddi-dipole-dipole.o: energy_module.o param_module.o coord_module.o          fft.o
print-eigenvalues.o DDB2short.o frozen_phonon_Gamma.o frozen_phonon_X.o: define.h

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

dist-hook:
	cd $(distdir)/01example-BaTiO3-epit-hysteresis-loop && $(MAKE) clean
