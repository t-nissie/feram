# -*-Makefile-*- for feram
# Time-stamp: <2012-09-14 16:28:00 takeshi>
# Author: Takeshi NISHIMATSU
##
FC=@FC@
F77=$(FC)
AM_FFLAGS=@FCFLAGS@
bin_PROGRAMS = feram diagonalize15x15 displacement coord2deviation eigenvalues2j frozen_phonon_Gamma frozen_phonon_X
EXTRA_PROGRAMS = marsaglia_tsang_uni64_check marsaglia_tsang_uni64_timing fft_check
TESTS = $(EXTRA_PROGRAMS) marsaglia_tsang_uni64_check.gp

feram_MODULES = param_module.F coord_module.F energy_module.F
feram_SRCS = average_module.F \
	dVddi-dipole-dipole.F \
	dVddi-homo-coupling.F \
	dVddi-unharmonic.F \
	date_and_time2message.F \
	decay-functions.f \
	dipoFFT.F \
	dipole-dipole-long-range.F \
	dipole-dipole-short-range.F \
	dipole-dipole.F \
	elastic.F \
	f90_wisdom.f \
	feram.F \
	feram_common.F \
	fft.F \
	fft_3d_3x3upper_r2c.F \
	hysteresis_loop.F \
	initialize_E_field.F \
	initialize-dipoR.F \
	kinetic_energy.F \
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
	print-eigenvalues.F \
	velocity_scaling.F
feram_SOURCES = $(feram_MODULES) $(feram_SRCS)

diagonalize15x15_SOURCES = diagonalize15x15.F

displacement_SOURCES = displacement.F

coord2deviation_SOURCES = coord2deviation.F

eigenvalues2j_SOURCES = eigenvalues2j.F msg.F param_module.F

frozen_phonon_Gamma_SOURCES = frozen_phonon_Gamma.F

frozen_phonon_X_SOURCES = frozen_phonon_X.F

marsaglia_tsang_uni64_check_SOURCES  = marsaglia_tsang_uni64_check.F  marsaglia_tsang_uni64_module.f

marsaglia_tsang_uni64_timing_SOURCES = marsaglia_tsang_uni64_timing.f marsaglia_tsang_uni64_module.f

fft_check_SOURCES = fft.F fft_check.F f90_wisdom.f

CLEANFILES = *.mod *.lst *.ps *.pdf *.f90 feram_mpi
EXTRA_DIST = define.h \
cross-section-dVddi.sh \
cross-section-p.sh \
cross-section-q.sh \
coord2dist.rb \
decay-test.gp \
defects-maker.rb \
epit.gp \
fft_acml.f \
fft_acml.Makefile \
fft_check.Makefile.Intel-gfortran-fftw3_omp \
fft_check.Makefile.Intel-ifort-MKL \
fft_check.Makefile.SR16000-ofort90-fftw \
fft_check.Makefile.SR16000-ofort90-matmpp \
fft_check.html \
inhomo-K.gp \
plot.gp \
slicer.rb \
splot.gp \
feram_mpi.F \
03example-BaTiO3-bulk-phase-transition \
10example-PbTiO3-DDB2short \
11example-BaTiO3-new-hysteresis-loop \
15example-BaTiO3-new-param-defects \
17example-PbTiO3-100-900K \
18example-benchmark \
19example-fft-benchmark \
20example-BaTiO3-new-param-pyro \
21example-KNbO3

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
	$(MPIFC) $(DEFS) $(DEFAULT_INCLUDES) $(INCLUDES) $(AM_CPPFLAGS) $(CPPFLAGS) \
	         $(AM_FFLAGS) $(FFLAGS) -c $(srcdir)/feram_mpi.F
	$(MPIFC) $(AM_FFLAGS) $(FFLAGS) $(AM_LDFLAGS) $(LDFLAGS) -o $@ $(feram_OBJECTS:feram.o=feram_mpi.o) $(LIBS)

feram_common.o:                 param_module.o coord_module.o date_and_time2message.o f90_wisdom.o define.h
decay-functions.o param_module.o diagonalize15x15.o: define.h
feram.o feram_mpi.o potentials.o dipole-dipole.o mirror.o initialize_E_field.o read_defects_u.o elastic.o:\
                                param_module.o coord_module.o define.h
initialize-dipoR.o dVddi-unharmonic.o leapfrog.o optimize-homo-strain.o:\
                energy_module.o param_module.o coord_module.o
energy_module.o:                param_module.o coord_module.o
optimize-homo-strain.o optimize-inho-strain.o:\
                energy_module.o param_module.o coord_module.o
molecular-dynamics.o:\
                energy_module.o param_module.o coord_module.o average_module.o
dVddi-homo-coupling.o dVddi-unharmonic.o potential.o kinetic_energy.o:\
                                param_module.o coord_module.o
initialize-dipoR.o:             param_module.o coord_module.o energy_module.o define.h marsaglia_tsang_uni64_module.o
marsaglia_tsang_uni64_check.o marsaglia_tsang_uni64_timing.o:                          marsaglia_tsang_uni64_module.o
mirror_force_mirror.o:          param_module.o coord_module.o energy_module.o
nose-poincare.o velocity_scaling.o:\
                                param_module.o coord_module.o energy_module.o kinetic_energy.o
leapfrog.o:                     param_module.o coord_module.o energy_module.o kinetic_energy.o define.h
hysteresis_loop.o:              param_module.o coord_module.o energy_module.o define.h velocity_scaling.o
average_module.o:               param_module.o coord_module.o energy_module.o define.h
coord_module.o:                 param_module.o         define.h
dipole-dipole-long-range.o:     param_module.o         define.h fft_3d_3x3upper_r2c.o
dipole-dipole-short-range.o:    param_module.o         define.h fft_3d_3x3upper_r2c.o
fft_3d_3x3upper_r2c.o:          param_module.o                fft.o  define.h
dVddi-dipole-dipole.o:\
                energy_module.o param_module.o coord_module.o fft.o
dipoFFT.o:                      param_module.o coord_module.o fft.o define.h
print-eigenvalues.o eigenvalues2j.o frozen_phonon_Gamma.o frozen_phonon_X.o: define.h
eigenvalues2j.o:                param_module.o define.h
fft.o: define.h
fft_check.o: fft.o f90_wisdom.o

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

fft_check.html:  fft_check.F
	sed -n '/#ifdef FFT_CHECK_DOCUMENT/,/#endif/p' $< | ulmul2html5 -s ../style.css -n 'Takeshi Nishimatsu' \
	| sed -e 's%\.\./INSTALL%<a href="../INSTALL.html">../INSTALL</a>%' > $@
#diff: param.F
#	diff -u -w $< $(INPUT_FILE) ; true
#	egrep 'read.* DUMMY' $< | cut -b 20- > param.read_dummy
#	diff -u -w param.read_dummy $(INPUT_FILE) ; true
#	egrep "write.*'!" $< | cut -b 21- | sed "s/'$$//" > param.write_dummy
#	diff -u -w param.read_dummy param.write_dummy
