# -*-Makefile-*- for feram
# Time-stamp: <2015-04-20 07:30:24 takeshi>
# Author: Takeshi NISHIMATSU
##
FC=@FC@
F77=$(FC)
AM_FFLAGS=@FCFLAGS@
bin_PROGRAMS = feram \
               feram_diagonalize15x15 \
               feram_displacement \
               feram_eigenvalues2j \
               feram_fftw_wisdom \
               feram_distribution3d2ppm \
               feram_frozen_phonon_Gamma \
               feram_frozen_phonon_X \
               feram_random_field_generator
check_PROGRAMS = fft_check marsaglia_tsang_uni64_check marsaglia_tsang_uni64_timing rgb_check wave_check date_and_time_check
TESTS = $(check_PROGRAMS) marsaglia_tsang_uni64_check.gp wave_check.gp defects_maker_check.sh elastocaloric770K_check.sh

feram_MODULES = param_module.F coord_module.F energy_module.F
feram_SRCS = average_module.F \
	dVddi-dipole-dipole.F \
	dVddi-homo-coupling.F \
	dVddi_inho_coupling.F \
	dVddi-unharmonic.F \
	dVdac.F \
	date_and_time_module.f \
	decay-functions.f \
	acouFFT.F \
	dipoFFT.F \
	dipole-dipole-long-range.F \
	dipole-dipole-short-range.F \
	dipole-dipole.F \
	elastic.F \
	f90_wisdom.f \
	feram.F \
	feram_common.F \
	fft_3d_3x3upper_r2c.F \
	hysteresis_loop.F \
	initialize_E_field.F \
	initialize-dipoR.F \
	kinetic_energy_dipo.F \
	kinetic_energy_acou.F \
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
	print-eigenvalues.F \
	velocity_scaling.F \
	wave_module.F \
	write_system.F
feram_SOURCES = $(feram_MODULES) $(feram_SRCS)

feram_fftw_wisdom_SOURCES = feram_fftw_wisdom.F

feram_diagonalize15x15_SOURCES = feram_diagonalize15x15.F

feram_displacement_SOURCES = feram_displacement.F

feram_distribution3d2ppm_SOURCES = feram_distribution3d2ppm.F rgb_module.f

feram_eigenvalues2j_SOURCES = feram_eigenvalues2j.F msg.F param_module.F

feram_frozen_phonon_Gamma_SOURCES = feram_frozen_phonon_Gamma.F

feram_frozen_phonon_X_SOURCES = feram_frozen_phonon_X.F

rgb_check_SOURCES = rgb_check.f rgb_module.f

date_and_time_check_SOURCES = date_and_time_check.f date_and_time_module.f

marsaglia_tsang_uni64_check_SOURCES  = marsaglia_tsang_uni64_check.F  marsaglia_tsang_uni64_module.f

marsaglia_tsang_uni64_timing_SOURCES = marsaglia_tsang_uni64_timing.f marsaglia_tsang_uni64_module.f

feram_random_field_generator_SOURCES = feram_random_field_generator.F marsaglia_tsang_uni64_module.f

wave_check_SOURCES = wave_check.f wave_module.F

fft_check_SOURCES = fft_check.F f90_wisdom.f

CLEANFILES = *.mod *.lst *.dat *.eps *.ps *.pdf *.f90 *.param.gp *.avg rgb_check.ppm feram_mpi $(check_PROGRAMS) \
             defects_maker_check.defects wisdom_new \
             elastocaloric770K_check.lf.log \
             elastocaloric770K_check.lf.log.digest \
             elastocaloric770K_check.vs.log \
             elastocaloric770K_check.vs.log.digest
EXTRA_DIST = define.h \
cross-section-dVddi.sh \
cross-section-p.sh \
cross-section-q.sh \
cholesky_d.f \
coord2dist.rb \
decay-test.gp \
defects_maker.rb \
defects_maker_check.gp \
defects_maker_check.sh \
defects_maker_check_sphere.gp \
elastocaloric770K_check.csh \
elastocaloric770K_check.sh \
elastocaloric770K_check.txt \
elastocaloric770K_check.lf.feram \
elastocaloric770K_check.vs.feram \
epit.gp \
fft_check.Makefile.FX10-frtpx-fftw3_omp \
fft_check.Makefile.Intel-gfortran-fftw3_omp \
fft_check.Makefile.Intel-ifort-MKL \
fft_check.Makefile.Intel-ifort-fftw3_omp \
fft_check.Makefile.SR16000-ofort90-fftw \
fft_check.Makefile.SR16000-ofort90-matmpp \
fft_check.Makefile.SR16000-xlf90_r-fftw_xlc \
fft_check.html \
inhomo-K.gp \
plot.gp \
slicer.rb \
splot.gp \
feram_mpi.F \
marsaglia_tsang_uni64_check.gp \
wave_check.gp \
03example-BaTiO3-bulk-phase-transition \
08example-BaTiO3-dispersion \
09example-BaTiO3-bulk-leap-frog \
10example-PbTiO3-DDB2short \
17example-PbTiO3-100-900K \
18example-benchmark \
19example-fft-benchmark \
20example-BaTiO3-new-param-pyro \
21example-KNbO3 \
22example-BaTiO3-new-param-hl \
23example-BaTiO3-new-param-hl-film-acoustic-mass \
24example-BaTiO3-new-param-heating-cooling \
25example-BaTiO3-read-quadratic \
26example-BaTiO3-acoustic-MD \
27example-BaTiO3-new-param-E_wave \
28example-PbTiO3-elastocaloric-770K \
29example-BaTiO3-new-param-defects \
30example-BaTiO3-new-param-ramping-off

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

feram_common.o:                 param_module.o coord_module.o date_and_time_module.o f90_wisdom.o define.h
decay-functions.o param_module.o feram_diagonalize15x15.o: define.h
feram.o feram_mpi.o dipole-dipole.o mirror.o read_defects_u.o elastic.o write_system.o dipoFFT.o acouFFT.o:\
                                param_module.o coord_module.o define.h
initialize_E_field.o:           param_module.o coord_module.o define.h wave_module.o
initialize-dipoR.o dVddi-unharmonic.o leapfrog.o optimize-homo-strain.o optimize-homo-strain.o optimize-inho-strain.o:\
                energy_module.o param_module.o coord_module.o
dVddi_inho_coupling.o energy_module.o dVdac.o: \
                                param_module.o coord_module.o
molecular-dynamics.o:\
                energy_module.o param_module.o coord_module.o average_module.o wave_module.o
dVddi-homo-coupling.o dVddi-unharmonic.o kinetic_energy_dipo.o kinetic_energy_acou.o:\
                                param_module.o coord_module.o
initialize-dipoR.o:             param_module.o coord_module.o energy_module.o define.h marsaglia_tsang_uni64_module.o
marsaglia_tsang_uni64_check.o marsaglia_tsang_uni64_timing.o feram_random_field_generator.o: marsaglia_tsang_uni64_module.o
wave_check.o:                   wave_module.o
rgb_check.o:                    rgb_module.o
mirror_force_mirror.o:          param_module.o coord_module.o energy_module.o
nose-poincare.o velocity_scaling.o:\
                                param_module.o coord_module.o energy_module.o kinetic_energy_dipo.o
leapfrog.o:                     param_module.o coord_module.o energy_module.o kinetic_energy_dipo.o define.h
hysteresis_loop.o:              param_module.o coord_module.o energy_module.o define.h velocity_scaling.o
average_module.o:               param_module.o coord_module.o energy_module.o define.h
coord_module.o:                 param_module.o         define.h
dipole-dipole-long-range.o:     param_module.o         define.h fft_3d_3x3upper_r2c.o
dipole-dipole-short-range.o:    param_module.o         define.h fft_3d_3x3upper_r2c.o
fft_3d_3x3upper_r2c.o:          param_module.o
dVddi-dipole-dipole.o:\
                energy_module.o param_module.o coord_module.o
print-eigenvalues.o feram_eigenvalues2j.o feram_frozen_phonon_Gamma.o feram_frozen_phonon_X.o: define.h
feram_eigenvalues2j.o:          param_module.o define.h
feram_distribution3d2ppm.o:     average_module.o rgb_module.o
fft_check.o: f90_wisdom.o

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

fft_check_mpi.html:  fft_check_mpi.F
	sed -n '/#ifdef FFT_CHECK_MPI_DOCUMENT/,/#endif/p' $< | ulmul2html5 -s ../style.css -n 'Takeshi Nishimatsu' > $@
#diff: param.F
#	diff -u -w $< $(INPUT_FILE) ; true
#	egrep 'read.* DUMMY' $< | cut -b 20- > param.read_dummy
#	diff -u -w param.read_dummy $(INPUT_FILE) ; true
#	egrep "write.*'!" $< | cut -b 21- | sed "s/'$$//" > param.write_dummy
#	diff -u -w param.read_dummy param.write_dummy
