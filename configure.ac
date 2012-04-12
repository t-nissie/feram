dnl -*-Autoconf-*-
dnl configure.ac for feram
dnl Time-stamp: <2012-04-12 14:05:56 user2001>
dnl Author: Takeshi NISHIMATSU

## Initialize.
AC_PREREQ(2.64)
AC_INIT([feram by Takeshi NISHIMATSU],[0.18.05],[t-nissie{at}imr.tohoku.ac.jp],[feram],[http://loto.sourceforge.net/feram/])
AC_CONFIG_SRCDIR(src/feram.F)
AM_INIT_AUTOMAKE([1.11.1 no-dist-gzip dist-xz])
AC_CONFIG_HEADERS([config.h])

## Some OS does not see /usr/local/lib.
LDFLAGS="$LDFLAGS -L/usr/local/lib"

## fftw3.f must be in /usr/include/, /usr/local/include/.
## Or specify the directory explicitly as:
## $ CPPFLAGS=-I/some/wherer ./configure
## AC_CHECK_HEADER(fftw3.f) does not work in Fortran.
CPPFLAGS="$CPPFLAGS -I/usr/include -I/usr/local/include"
AC_ARG_VAR(CPPFLAGS, [C preprocessor (CPP) Flags, e.g. -l<include dir>])

## Checks for some programs.
AC_PROG_INSTALL

## Checks for Fortran compilers.
FCFLAGS_PRESERVE=$FCFLAGS
AC_LANG(Fortran)
AC_PROG_FC(gfortran ifort pgf95 g95 xf90 frt frtpx openf95)
FCFLAGS=$FCFLAGS_PRESERVE
   # Restore FCFLAGS, because AC_PROG_FC() sets FCFLAGS to '-g -O2', '-O2' or '-g' undesirably.

## FCFLAGS and MPIFC:
AC_ARG_VAR(MPIFC, [MPI Fortran compiler command])
case "$FC" in
  g95)
    test -n "$FCFLAGS" || FCFLAGS="-g -Wall -O3 -ffast-math -funroll-loops -pipe"
    ;;
  gfortran*)
    test -n "$FCFLAGS" || FCFLAGS="-g -Wall -O3 -ffast-math -funroll-loops -pipe\
      -ffpe-trap=zero,overflow -fopenmp"
    ;;
  openf95)
    test -n "$FCFLAGS" || FCFLAGS="-g -Wall -O3 -ffast-math -fopenmp"
    ;;
  ifort)
    test -n "$FCFLAGS" || FCFLAGS="-r8 -O3 -warn all -openmp -openmp-report2 -parallel -par-report1"
    ;;
  pgf*)
    test -n "$FCFLAGS" || FCFLAGS="-O3 -mp"
    ;;
  xf90|f90)
    test -n "$FCFLAGS" || FCFLAGS="-64 -Os -parallel=4\
      -uinline=2 -mathinline -COMOUT -exclamation=option -precise -model=K1 -noscope -nolimit -noprefetch -prefetch_zero -loglist"
    test -n "$MPIFC" || MPIFC=mpixf90
    ;;
  frt)
    test -n "$FCFLAGS" || FCFLAGS="-Kimpact -Am -SSL2 -KOMP"
    test -n "$MPIFC" || MPIFC=mpifrt
    ;;
  frtpx)
    test -n "$FCFLAGS" || FCFLAGS="-Kfast,parallel,openmp,preex,array_private,auto -SSL2 -Qt"
    test -n "$MPIFC" || MPIFC=mpifrtpx
    ;;
  *xlf*)
    AC_MSG_ERROR([C preprocessor invoked from IBM XL Fortran cannot process comment lines in define.h and config.h properly, so far.])
    ;;
  *)
    test -n "$FCFLAGS" || FCFLAGS="-O2"
    ;;
esac
test -n "$MPIFC" || MPIFC=mpif90

## AR and RANLIB
case "$host" in
  SR1*)
    AR='ar -X64'
    RANLIB='ranlib -X64'
    ;;
  *)
    AR=ar
    AC_PROG_RANLIB
    ;;
esac

## FFT library
case "$host" in
  SR1*)
    AC_DEFINE([HITACHI_SR], [1], [HITACHI SR11000 and SR16000])
    AC_MSG_NOTICE([We use MATRIX/MPP (matmpp) library of HITACHI SR11000 or SR16000.])
    LDFLAGS="$LDFLAGS -L/opt/hitachi/matmpp/lib"
    AC_CHECK_LIB(matmpp, HDFZ7M,,
                 AC_MSG_ERROR([You need MATRIX/MPP (matmpp) library. See config.log.]))
    ;;
  *)
    AC_ARG_WITH(fft,[AS_HELP_STRING([--with-fft=ARG],[FFT library.
                                     ARG must be one of
                                     fftw3 (default, fast),
                                     mkl (Intel MKL, FFTW3 wrappers to Intel MKL functions),
                                     ssl2 (Fujitsu SSL II),
                                     acml (AMD Core Math Library, slow), or
                                     no (use the built-in minimal FFT, slow).])])
    case "$with_fft" in
      fftw* | yes | "")
        AC_CHECK_LIB(fftw3, dfftw_execute,,
                     [AC_MSG_ERROR([You need FFTW3 library, i.e. libfftw3. See config.log.])])
        AC_CHECK_LIB(fftw3_omp, dfftw_init_threads,,
                     [AC_MSG_ERROR([You need FFTW3 library compiled with --enable-openmp, i.e. libfftw3_omp. See config.log.])])
        ;;
      mkl)
        AC_CHECK_LIB(mkl_core, dfftw_execute,[AC_DEFINE([HAVE_LIBFFTW3]) LIBS="-lmkl_core -lmkl_intel_thread -lmkl_gf_lp64 $LIBS"],
                     AC_MSG_ERROR([You need Intel Math Kernel Library (MKL). See config.log.]),[-lmkl_intel_thread -lmkl_gf_lp64])
        ;;
      ssl2)
        ;;
      acml*)
        AC_CHECK_LIB(acml_mp, ZFFT3D,, AC_MSG_ERROR([You need ACML. See config.log.]))
        ;;
      no)
        AC_DEFINE([BUILT_IN_FFT], [1], [Use the built-in minimal FFT])
        LIBBUILT_IN_FFT_A=../libbuilt_in_fft/libbuilt_in_fft.a
        ;;
      *)
        AC_MSG_ERROR([Unknown FFT library: $with_fft])
        ;;
    esac
esac

## LAPACK
AC_ARG_WITH(lapack,[AS_HELP_STRING([--with-lapack=ARG],[LAPACK library.
                                     ARG must be one of
                                     lapack (default),
                                     mkl (Intel MKL),
                                     ssl2 (Fujitsu SSL II),
                                     acml (AMD Core Math Library, slow).])])
case "$with_lapack" in
  lapack | yes | "")
    AC_CHECK_LIB(blas,  dsymv,,AC_MSG_ERROR([You need  BLAS  library. See config.log.]))
    AC_CHECK_LIB(lapack,dsyev,,AC_MSG_ERROR([You need LAPACK library. See config.log.]))
    ;;
  mkl)
    case "$LIBS" in
      *mkl_gf_lp64*)
        AC_MSG_NOTICE([lapack... It seems that MKL is already putted into LIBS.])
        ;;
      *)
        AC_MSG_NOTICE([lapack... Put MKL into LIBS.])
        LIBS="-lmkl_core -lmkl_intel_thread -lmkl_gf_lp64 $LIBS"
        ;;
    esac
    ;;
  ssl2)
    ;;
  acml*)
    ;;
  *)
    AC_MSG_ERROR([Unknown LAPACK library: $with_lapack])
    ;;
esac

## fixed-form or free-form
FCFLAGS_FIXEDFORM=$FCFLAGS
case "$FC" in
  g95|gfortran*)
    FCFLAGS="$FCFLAGS -ffree-form -ffree-line-length-none"
    ;;
  frt*)
    FCFLAGS="$FCFLAGS -Free"
    ;;
  openf95)
    FCFLAGS="$FCFLAGS -freeform"
    ;;
  *)
    AC_FC_FREEFORM()
    ;;
esac

## Finalize.
AC_SUBST(CPPFLAGS)
AC_SUBST(FCFLAGS_FIXEDFORM)
AC_SUBST(AR)
AC_SUBST(RANLIB)
AC_SUBST(LIBBUILT_IN_FFT_A)

AC_CONFIG_FILES([Makefile
             doc/Makefile
 libbuilt_in_fft/Makefile
      parameters/Makefile
             src/Makefile])
AC_OUTPUT
