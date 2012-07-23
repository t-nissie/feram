# -*-Makefile-*- for fft_check
##
FC=pgf90
FFLAGS=-fastsse -O3 -mp -Minfo=all -Mfree
CPPFLAGS=-DHAVE_LIBACML_MP
LDFLAGS=-L/home/t-nissie/Linux-x86_64/opt/acml5.1.0/pgi64_mp/lib -L/opt/pgi/linux86-64/12.2/libso -lacml_mp

fft_check: fft_check.o
	$(FC) $(FFLAGS) -o $@ $^ $(LDFLAGS)
clean:
	rm -f core* fft_check fft_check.o
