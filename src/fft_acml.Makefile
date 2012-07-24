# -*-Makefile-*- for fft_acml
##
FC=pgf95
FFLAGS=-fastsse -O3 -mp -Minfo=all -Mfree
CPPFLAGS=-DHAVE_LIBACML_MP
LDFLAGS=-L/opt/pgi/linux86-64/2012/acml/5.1.0/libso -lacml_mp

fft_acml: fft_acml.o
	$(FC) $(FFLAGS) -o $@ $^ $(LDFLAGS)
clean:
	rm -f core* fft_acml fft_acml.o
