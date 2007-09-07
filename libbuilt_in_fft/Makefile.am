#-*-Makefile-*-
# Time-stamp: <2007-06-06 21:39:47 t-nissie>
# Author: Takeshi NISHIMATSU
##
FC=@FC@
F77=$(FC)
AM_FFLAGS=@FCFLAGS@
noinst_LIBRARIES = libbuilt_in_fft.a
EXTRA_DIST = generatefft.rb test_fft1d.f test_fft3d.f
ALL_FFT1D = \
fft1d_fwd_0002.f \
fft1d_fwd_0004.f \
fft1d_fwd_0008.f \
fft1d_fwd_0016.f \
fft1d_fwd_0032.f \
fft1d_fwd_0064.f \
fft1d_fwd_0128.f \
fft1d_fwd_0256.f \
fft1d_fwd_0512.f \
fft1d_inv_0002.f \
fft1d_inv_0004.f \
fft1d_inv_0008.f \
fft1d_inv_0016.f \
fft1d_inv_0032.f \
fft1d_inv_0064.f \
fft1d_inv_0128.f \
fft1d_inv_0256.f \
fft1d_inv_0512.f
libbuilt_in_fft_a_SOURCES = $(ALL_FFT1D) fft1d.f fft3d.f

CLEANFILES = core core.* *.o test_fft1d test_fft3d

test: test_fft1d test_fft3d
	./$<   2
	./$<   4
	./$<   8
	./$<  16
	./$<  32
	./$<  64
	./$< 128
	./$< 256
	./$< 512
	time ./test_fft3d

test_fft1d: test_fft1d.o libbuilt_in_fft.a
	$(FC) $(AM_FFLAGS) -o $@ $^

test_fft3d: test_fft3d.o libbuilt_in_fft.a
	$(FC) $(AM_FFLAGS) -o $@ $^

fft1d_fwd_0002.f: generatefft.rb
	ruby $<    2 fwd
fft1d_fwd_0004.f: generatefft.rb
	ruby $<    4 fwd
fft1d_fwd_0008.f: generatefft.rb
	ruby $<    8 fwd
fft1d_fwd_0016.f: generatefft.rb
	ruby $<   16 fwd
fft1d_fwd_0032.f: generatefft.rb
	ruby $<   32 fwd
fft1d_fwd_0064.f: generatefft.rb
	ruby $<   64 fwd
fft1d_fwd_0128.f: generatefft.rb
	ruby $<  128 fwd
fft1d_fwd_0256.f: generatefft.rb
	ruby $<  256 fwd
fft1d_fwd_0512.f: generatefft.rb
	ruby $<  512 fwd

fft1d_inv_0002.f: generatefft.rb
	ruby $<    2 inv
fft1d_inv_0004.f: generatefft.rb
	ruby $<    4 inv
fft1d_inv_0008.f: generatefft.rb
	ruby $<    8 inv
fft1d_inv_0016.f: generatefft.rb
	ruby $<   16 inv
fft1d_inv_0032.f: generatefft.rb
	ruby $<   32 inv
fft1d_inv_0064.f: generatefft.rb
	ruby $<   64 inv
fft1d_inv_0128.f: generatefft.rb
	ruby $<  128 inv
fft1d_inv_0256.f: generatefft.rb
	ruby $<  256 inv
fft1d_inv_0512.f: generatefft.rb
	ruby $<  512 inv
