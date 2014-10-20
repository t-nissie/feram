dnl -*-Autoconf-*-
dnl configure.ac for feram
dnl Time-stamp: <2014-10-21 05:57:24 takeshi>
dnl Author: Takeshi NISHIMATSU

## Initialize.
AC_PREREQ(2.69)
AC_INIT([feram by Takeshi NISHIMATSU],[0.22.05],[t-nissie{at}imr.tohoku.ac.jp],[feram],[http://loto.sourceforge.net/feram/])
AC_CONFIG_SRCDIR(src/feram.F)
AM_INIT_AUTOMAKE([1.14.1 no-dist-gzip dist-xz])
AC_CONFIG_HEADERS([config.h])

## fftw3.f must be in /usr/include/, /usr/local/include/.
## Or specify the directory explicitly as:
## $ ./configure CPPFLAGS=-I/some/where
## AC_CHECK_HEADER(fftw3.f) does not work in Fortran.
CPPFLAGS="$CPPFLAGS -I/usr/include -I/usr/local/include"
AC_ARG_VAR(CPPFLAGS, [C preprocessor (CPP) Flags, e.g. -I<include dir>])

## Checks for some programs.
AC_PROG_INSTALL

## Checks for Fortran compilers.
FCFLAGS_PRESERVE=$FCFLAGS
AC_LANG(Fortran)
AC_PROG_FC(gfortran ifort frt frtpx xlf90_r xlf95_r)
FCFLAGS=$FCFLAGS_PRESERVE
   # Restore FCFLAGS, because AC_PROG_FC() sets FCFLAGS to '-g -O2', '-O2' or '-g' undesirably.

## FCFLAGS and MPIFC:
AC_ARG_VAR(MPIFC, [MPI Fortran compiler command])
case "$FC" in
  gfortran*)
    test -n "$FCFLAGS" || FCFLAGS="-g -Wall -O3 -funroll-loops -pipe -ffpe-trap=zero,overflow -fopenmp"
    gfortran --version | head -1 | grep -v 4.8.0 || AC_MSG_ERROR([Do NOT use gfortran 4.8.0. Use 4.8.1 or higher. See http://gcc.gnu.org/bugzilla/show_bug.cgi?id=56696 .])
    ;;
  ifort)
    test -n "$FCFLAGS" || FCFLAGS="-r8 -O3 -warn all -openmp -openmp-report2 -parallel -par-report1"
    ;;
  frt)
    test -n "$FCFLAGS" || FCFLAGS="-Kimpact -Am -SSL2 -KOMP"
    test -n "$MPIFC" || MPIFC=mpifrt
    ;;
  frtpx)
    test -n "$FCFLAGS" || FCFLAGS="-Kfast,parallel,openmp,preex,array_private,auto,ocl -SSL2 -Qt"
    test -n "$MPIFC" || MPIFC=mpifrtpx
    ;;
  xlf*)
    test -n "$FCFLAGS" || FCFLAGS="-q64 -O4 -qsmp=omp -qinfo=all"
    test -n "$MPIFC" || MPIFC=mp"$FC"
    LDFLAGS="$LDFLAGS -Wl,-blpdata -Wl,-bmaxdata:90000000000"
    ;;
  *)
    test -n "$FCFLAGS" || FCFLAGS="-O2"
    ;;
esac
test -n "$MPIFC" || MPIFC=mpif90

## FFT library
AC_ARG_WITH(fft,[AS_HELP_STRING([--with-fft=ARG],[FFT library.
                                   ARG must be one of
                                   fftw3_omp (default, fast),
                                   fftw3_threads,
                                   mkl (Intel MKL, FFTW3 wrappers to Intel MKL functions),
                                   ssl2 (Fujitsu SSL II), or
                                   no (error).])])
case "$with_fft" in
  fftw3_omp | fftw | fftw3 | yes | "")
    AC_CHECK_LIB(fftw3, dfftw_execute,,
                 [AC_MSG_ERROR([You need FFTW3 library, i.e. libfftw3. See config.log.])])
    AC_CHECK_LIB(fftw3_omp, dfftw_init_threads,,
                 [AC_MSG_ERROR([You need FFTW3 library compiled with --enable-openmp, i.e. libfftw3_omp. See config.log.])])
    ;;
  fftw3_threads)
    AC_CHECK_LIB(fftw3, dfftw_execute,,
                 [AC_MSG_ERROR([You need FFTW3 library, i.e. libfftw3. See config.log.])])
    AC_CHECK_LIB(fftw3_threads, dfftw_init_threads,,
                 [AC_MSG_ERROR([You need FFTW3 library compiled with --enable-threads, i.e. libfftw3_threads. See config.log.])])
    ;;
  mkl)
    AC_CHECK_LIB(mkl_gf_lp64, dfftw_execute,[AC_DEFINE([HAVE_LIBFFTW3]) LIBS="-lmkl_core -lmkl_intel_thread -lmkl_gf_lp64 $LIBS"],
                 AC_MSG_ERROR([You need Intel Math Kernel Library (MKL). See config.log.]),[-lmkl_core -lmkl_intel_thread])
    ;;
  ssl2)
    ;;
  cufft*)
    AC_CHECK_LIB(libcufft, cufftPlan3d,, AC_MSG_ERROR([You need CUFFT. See config.log.]))
    ;;
  no)
    AC_MSG_ERROR([You need an FFT library.])
    ;;
  *)
    AC_MSG_ERROR([Unknown FFT library: $with_fft])
    ;;
esac

## LAPACK
AC_ARG_WITH(lapack,[AS_HELP_STRING([--with-lapack=ARG],[LAPACK library.
                                     ARG must be one of
                                     lapack (default),
                                     mkl (Intel MKL),
                                     ssl2 (Fujitsu SSL II).])])
case "$with_lapack" in
  lapack | yes | "")
    AC_CHECK_LIB(blas,  dsymv,,[AC_CHECK_LIB(f77blas,  dsymv,,AC_MSG_ERROR([You need  BLAS  library. See config.log.]))])
    AC_CHECK_LIB(lapack,dsyevx,,AC_MSG_ERROR([You need LAPACK library. See config.log.]))
    ;;
  essl)
    AC_CHECK_LIB(esslsmp,dsyevx,,AC_MSG_ERROR([You need ESSL library for LAPACK subroutines. See config.log.]))
    ;;  
  mkl)
    case "$LIBS" in
      *mkl_gf_lp64*)
        AC_MSG_NOTICE([lapack... It seems that there is -lmkl_gf_lp64 already in LIBS.])
        ;;
      *)
        AC_MSG_NOTICE([lapack... Add -lmkl_core -lmkl_intel_thread -lmkl_gf_lp64 at the tail of LIBS.])
        LIBS="$LIBS -lmkl_core -lmkl_intel_thread -lmkl_gf_lp64"
        ;;
    esac
    ;;
  ssl2)
    ;;
  *)
    AC_MSG_ERROR([Unknown LAPACK library: $with_lapack])
    ;;
esac

## free-form
case "$FC" in
  gfortran*)
    FCFLAGS="$FCFLAGS -ffree-form -ffree-line-length-none"
    ;;
  frt*)
    FCFLAGS="$FCFLAGS -Free"
    ;;
  xlf*)
    FCFLAGS="$FCFLAGS -qfree=f90"
    ;;
  *)
    AC_FC_FREEFORM()
    ;;
esac

## Finalize.
AC_SUBST(CPPFLAGS)

AC_CONFIG_FILES([Makefile
             doc/Makefile
      parameters/Makefile
             src/Makefile])
AC_OUTPUT
