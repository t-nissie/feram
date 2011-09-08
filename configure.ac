dnl -*-Autoconf-*-
dnl configure.ac for feram
dnl Time-stamp: <2011-09-08 12:28:11 takeshi>
dnl Author: Takeshi NISHIMATSU

## Initialize.
AC_PREREQ(2.61)
AC_INIT([feram by Takeshi NISHIMATSU],[0.15.02],[takeshi{at}physics.rutgers.edu],[feram])
AC_CONFIG_SRCDIR(src/feram.F)
AM_INIT_AUTOMAKE
AC_CONFIG_HEADERS([config.h])

## Some OS does not see /usr/local/lib.
LDFLAGS="$LDFLAGS -L/usr/local/lib"

## fftw3.f must be in /usr/include/, /usr/local/include/.
## Or specify the directory explicitly as:
## $ CPPFLAGS=-I/some/wherer ./configure
## AC_CHECK_HEADER(fftw3.f) does not work in Fortran.
CPPFLAGS="$CPPFLAGS -I/usr/include -I/usr/local/include"

## Checks for some programs.
AC_PROG_INSTALL

## OpenMP
AC_ARG_ENABLE(openmp,[AS_HELP_STRING([--disable-openmp],[disable OpenMP (default enabled)])])

## Checks for Fortran compilers.
FCFLAGS_PRESERVE=$FCFLAGS
AC_LANG(Fortran)
AC_PROG_FC(gfortran ifort pgf95 g95 xf90)
FCFLAGS=$FCFLAGS_PRESERVE
   # Restore FCFLAGS, because AC_PROG_FC() sets FCFLAGS to '-g -O2', '-O2' or '-g' undesirably.

## Desired FCFLAGS are:
case "$FC" in
  g95)
    test -n "$FCFLAGS" || FCFLAGS="-g -Wall -O3 -ffast-math -funroll-loops -pipe"
    ;;
  gfortran)
    test -n "$FCFLAGS" || FCFLAGS="-g -Wall -O3 -ffast-math -funroll-loops -pipe\
      -ffpe-trap=zero,overflow"
    if test "$enable_openmp" != "no"; then
      FCFLAGS="$FCFLAGS -fopenmp"
    fi
    ;;
  ifort)
    test -n "$FCFLAGS" || FCFLAGS="-r8 -O3 -warn all"
    if test "$enable_openmp" != "no"; then
      FCFLAGS="$FCFLAGS -openmp -openmp-report2 -parallel -par-report1"
    fi
    ;;
  pgf*)
    test -n "$FCFLAGS" || FCFLAGS="-O3"
    if test "$enable_openmp" != "no"; then
      FCFLAGS="$FCFLAGS -mp"
    fi
    ;;
  xf90)
    test -n "$FCFLAGS" || FCFLAGS="-64 -Os -parallel=4\
      -uinline=2 -mathinline -COMOUT -exclamation=option -precise -model=K1 -noscope -nolimit -noprefetch -prefetch_zero -loglist"
    ;;
  frt)
    test -n "$FCFLAGS" || FCFLAGS="-Kimpact -Am"
    if test "$enable_openmp" != "no"; then
      FCFLAGS="$FCFLAGS -KOMP"
    fi
    ;;
  *xlf*)
    AC_MSG_ERROR([C preprocessor invoked from IBM XL Fortran cannot process comment lines in define.h and config.h properly, so far.])
    ;;
  *)
    test -n "$FCFLAGS" || FCFLAGS="-O2"
    ;;
esac

## AR and RANLIB
if test "$host" == SR11000; then
  AR='ar -X64'
  RANLIB='ranlib -X64'
else
  AR=ar
  AC_PROG_RANLIB
fi

## FFT library
case "$host" in
  SR11000)
    AC_DEFINE([SR11000], [1], [HITACHI SR11000 Series Super Technical Server])
    AC_MSG_NOTICE([We use MATRIX/MPP (matmpp) library of SR11000.])
    LDFLAGS="$LDFLAGS -L/opt/hitachi/matmpp/lib"
    AC_CHECK_LIB(matmpp, HDFZ7M,,
                 AC_MSG_ERROR([You need MATRIX/MPP (matmpp) library. See config.log.]))
    ;;
  *)
    AC_ARG_WITH(fft,[AS_HELP_STRING([--with-fft=ARG],[FFT library.
                                     ARG must be one of
                                     fftw3 (default, fast),
                                     mkl (Intel MKL, FFTW3 wrappers to Intel MKL functions),
                                     acml (AMD Core Math Library, slow), or
                                     no (use the built-in minimal FFT, slow).])])
    case "$with_fft" in
      fftw* | yes | "")
        AC_CHECK_LIB(fftw3, dfftw_execute,,
                     AC_MSG_ERROR([You need FFTW library. See config.log.]))
        ;;
      mkl)
        AC_CHECK_LIB(mkl_core, dfftw_execute,[AC_DEFINE([HAVE_LIBFFTW3]) LIBS="-lmkl_core -lmkl_intel_thread -lmkl_gf_lp64 $LIBS"],
                     AC_MSG_ERROR([You need Intel Math Kernel Library (MKL). See config.log.]),[-lmkl_intel_thread -lmkl_gf_lp64])
        ;;
      acml*)
        if test "$enable_openmp" == "no"; then
          AC_CHECK_LIB(acml,    ZFFT3D,, AC_MSG_ERROR([You need ACML. See config.log.]))
        else
          AC_CHECK_LIB(acml_mp, ZFFT3D,, AC_MSG_ERROR([You need ACML. See config.log.]))
        fi
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

## Detailed message
AC_ARG_ENABLE(detailed_messages,[AS_HELP_STRING([--disable-detailed-messages],[disable detailed messages (default enabled)])])
case "$enable_detailed_messages" in
  no)
    AC_MSG_NOTICE([Detailed messages will NOT be printed.])
    ;;
  *)
    AC_DEFINE([DETAILED_MESSAGES], [1], [Detailed messages will be printed.])
    ;;
esac

## fixed-form or free-form
FCFLAGS_FIXEDFORM=$FCFLAGS
case "$FC" in
  g95|gfortran)
    FCFLAGS="$FCFLAGS -ffree-form -ffree-line-length-none"
    ;;
  frt)
    FCFLAGS="$FCFLAGS -Free"
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
   libblaslapack/Makefile
 libbuilt_in_fft/Makefile
      parameters/Makefile
             src/Makefile])
AC_OUTPUT
