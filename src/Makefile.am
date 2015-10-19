# -*-Makefile-*- for feram
# Time-stamp: <2015-10-19 22:27:27 takeshi>
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
dist_bin_SCRIPTS = feram_coord2dist.rb \
                   feram_cross_section_dVddi.sh \
                   feram_cross_section_p.sh \
                   feram_cross_section_q.sh \
                   feram_defects_maker.rb \
                   feram_fcc_maker.rb \
                   feram_slicer.rb
check_PROGRAMS = feram_fftw_SoA marsaglia_tsang_uni64_check marsaglia_tsang_uni64_timing rgb_check wave_check date_and_time_check msg_check
TESTS = feram_fftw_wisdom $(check_PROGRAMS) marsaglia_tsang_uni64_check.gp wave_check.gp feram_defects_maker_check.sh \
         zzz16.feram_check \
         zzzgap.feram_check \
         zzzlf.feram_check \
         zzznp.feram_check \
         zzzvs.feram_check
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
	read_Z_star.F \
	marsaglia_tsang_uni64_module.f \
	mirror.F \
	mirror_force_mirror.F \
	molecular-dynamics.F \
	msg_module.F \
	nose-poincare.F \
	optimize-homo-strain.F \
	optimize-inho-strain.F \
	print-eigenvalues.F \
	velocity_scaling.F \
	wave_module.F \
	write_system.F
feram_SOURCES = $(feram_MODULES) $(feram_SRCS)

feram_fftw_wisdom_SOURCES = feram_fftw_wisdom.F feram_fftw_wisdom_timing.F feram_fftw_wisdom_out.F feram_fftw_wisdom_in.F

feram_fftw_SoA_SOURCES    = feram_fftw_SoA.F    feram_fftw_wisdom_timing.F feram_fftw_SoA_out.F    feram_fftw_SoA_in.F

feram_diagonalize15x15_SOURCES = feram_diagonalize15x15.F

feram_displacement_SOURCES = feram_displacement.F

feram_distribution3d2ppm_SOURCES = feram_distribution3d2ppm.F rgb_module.f

feram_eigenvalues2j_SOURCES = feram_eigenvalues2j.F msg_module.F param_module.F

feram_frozen_phonon_Gamma_SOURCES = feram_frozen_phonon_Gamma.F

feram_frozen_phonon_X_SOURCES = feram_frozen_phonon_X.F

rgb_check_SOURCES = rgb_check.f rgb_module.f

date_and_time_check_SOURCES = date_and_time_check.f date_and_time_module.f

marsaglia_tsang_uni64_check_SOURCES  = marsaglia_tsang_uni64_check.F  marsaglia_tsang_uni64_module.f

marsaglia_tsang_uni64_timing_SOURCES = marsaglia_tsang_uni64_timing.f marsaglia_tsang_uni64_module.f

feram_random_field_generator_SOURCES = feram_random_field_generator.F marsaglia_tsang_uni64_module.f

wave_check_SOURCES = wave_check.f wave_module.F

msg_check_SOURCES = msg_check.F msg_module.F

CLEANFILES = *.mod *.lst *.dat *.eps *.ps *.pdf *.f90 *.param.gp *.avg rgb_check.ppm feram_mpi $(check_PROGRAMS) \
             zzz*.log zzz16.*.coord zzzgap.*.fft \
             feram_defects_maker_check.defects wisdom_new wisdom_SoA \
             elastocaloric770K_check.lf.log \
             elastocaloric770K_check.lf.log.digest \
             elastocaloric770K_check.vs.log \
             elastocaloric770K_check.vs.log.digest \
             msg_check.output
EXTRA_DIST = define.h \
feram_cross_section_dVddi.sh \
feram_cross_section_p.sh \
decay-test.gp \
feram_defects_maker_check.gp \
feram_defects_maker_check.sh \
feram_defects_maker_check_sphere.gp \
elastocaloric770K_check.csh \
elastocaloric770K_check.sh \
elastocaloric770K_check.txt \
elastocaloric770K_check.lf.feram \
elastocaloric770K_check.vs.feram \
epit.gp \
inhomo-K.gp \
plot.gp \
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
30example-BaTiO3-new-param-ramping-off \
31example-BaTiO3-new-param-thermal-conductivity \
32example-BaTiO3-old-64x64x1024-benchmark \
zzz16.feram_check \
zzzgap.feram_check \
zzzlf.feram_check \
zzznp.feram_check \
zzzvs.feram_check

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

feram_common.o:                 param_module.o coord_module.o date_and_time_module.o define.h
decay-functions.o param_module.o feram_diagonalize15x15.o: define.h
feram.o feram_mpi.o:            param_module.o coord_module.o define.h
dipole-dipole.o mirror.o read_defects_u.o read_Z_star.o elastic.o write_system.o dipoFFT.o acouFFT.o:\
                                param_module.o coord_module.o define.h               msg_module.o
initialize_E_field.o:           param_module.o coord_module.o define.h wave_module.o msg_module.o
dVddi_inho_coupling.o dVdac.o kinetic_energy_acou.o:\
                                param_module.o coord_module.o
molecular-dynamics.o:           param_module.o coord_module.o energy_module.o average_module.o wave_module.o msg_module.o
dVddi-homo-coupling.o dVddi-unharmonic.o kinetic_energy_dipo.o energy_module.o:\
                                param_module.o coord_module.o msg_module.o
initialize-dipoR.o:             param_module.o coord_module.o energy_module.o define.h marsaglia_tsang_uni64_module.o msg_module.o
marsaglia_tsang_uni64_check.o marsaglia_tsang_uni64_timing.o feram_random_field_generator.o: marsaglia_tsang_uni64_module.o
wave_check.o:                   wave_module.o
rgb_check.o:                    rgb_module.o
nose-poincare.o velocity_scaling.o:\
                                param_module.o coord_module.o energy_module.o kinetic_energy_dipo.o msg_module.o
leapfrog.o:                     param_module.o coord_module.o energy_module.o kinetic_energy_dipo.o define.h
hysteresis_loop.o:              param_module.o coord_module.o energy_module.o define.h msg_module.o velocity_scaling.o
dVddi-dipole-dipole.o optimize-homo-strain.o:\
                                param_module.o coord_module.o energy_module.o          msg_module.o
mirror_force_mirror.o dVddi-unharmonic.o optimize-homo-strain.o optimize-inho-strain.o:\
                                param_module.o coord_module.o energy_module.o
dipole-dipole-long-range.o dipole-dipole-short-range.o:\
                                param_module.o         define.h fft_3d_3x3upper_r2c.o  msg_module.o
fft_3d_3x3upper_r2c.o:          param_module.o
feram_frozen_phonon_Gamma.o feram_frozen_phonon_X.o: define.h
feram_eigenvalues2j.o:          param_module.o define.h msg_module.o
feram_distribution3d2ppm.o:     average_module.o rgb_module.o
feram_fftw_wisdom.o:            feram_fftw_wisdom_timing.o feram_fftw_wisdom_out.o feram_fftw_wisdom_in.o
feram_fftw_SoA.o:               feram_fftw_wisdom_timing.o feram_fftw_SoA_out.o feram_fftw_SoA_in.o
msg_check.o:                    msg_module.o
msg_module.o:                       define.h
param_module.o print-eigenvalues.o: define.h msg_module.o
coord_module.o:                     define.h msg_module.o param_module.o
average_module.o:                   define.h msg_module.o param_module.o energy_module.o

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
