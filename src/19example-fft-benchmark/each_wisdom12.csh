#!/bin/csh
##
setenv OMP_NUM_THREADS 12
setenv CPU_MODEL_NAME X5650

../fft_check  100000   32   32   32; mv wisdom_new wisdom.32x32x32.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check   10000   64   64   64; mv wisdom_new wisdom.64x64x64.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check   10000  256   64   32; mv wisdom_new wisdom.256x64x32.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check    1000   16 1024   64; mv wisdom_new wisdom.16x1024x64.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check    1000  128  128  128; mv wisdom_new wisdom.128x128x128.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check     100  256  256  256; mv wisdom_new wisdom.256x256x256.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check     100  128  256 1024; mv wisdom_new wisdom.128x256x1024.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check     100  256  256  512; mv wisdom_new wisdom.256x256x512.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check      50  256  512  512; mv wisdom_new wisdom.256x512x512.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check      50  512  256  512; mv wisdom_new wisdom.512x256x512.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check      50  512  512  512; mv wisdom_new wisdom.512x512x512.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check      50  256  512 1024; mv wisdom_new wisdom.256x512x1024.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check      50 1024  512  256; mv wisdom_new wisdom.1024x512x256.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check      20  512  512 1024; mv wisdom_new wisdom.512x512x1024.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check      10  512 1024 1024; mv wisdom_new wisdom.512x1024x1024.$CPU_MODEL_NAME.$OMP_NUM_THREADS

../fft_check  100000   30   30   30; mv wisdom_new wisdom.30x30x30.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check   50000   48   48   48; mv wisdom_new wisdom.48x48x48.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check   50000   54   54   54; mv wisdom_new wisdom.54x54x54.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check   10000   32   32  243; mv wisdom_new wisdom.32x32x243.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check   10000   72   72   72; mv wisdom_new wisdom.72x72x72.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check   10000   75   75   75; mv wisdom_new wisdom.75x75x75.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check    5000   80   80   80; mv wisdom_new wisdom.80x80x80.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check    5000   81   81   81; mv wisdom_new wisdom.81x81x81.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check    2000   96   96   96; mv wisdom_new wisdom.96x96x96.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check    2000  100  100  100; mv wisdom_new wisdom.100x100x100.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check    1000  120  120  120; mv wisdom_new wisdom.120x120x120.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check     300  240  240  240; mv wisdom_new wisdom.240x240x240.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check     100  243  243  243; mv wisdom_new wisdom.243x243x243.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check     100  300  300  300; mv wisdom_new wisdom.300x300x300.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check     100  320  320  320; mv wisdom_new wisdom.320x320x320.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check      50  360  360  360; mv wisdom_new wisdom.360x360x360.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check      50  400  400  400; mv wisdom_new wisdom.400x400x400.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check      50  405  405  405; mv wisdom_new wisdom.405x405x405.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check      50  432  432  432; mv wisdom_new wisdom.432x432x432.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check      30  500  500  500; mv wisdom_new wisdom.500x500x500.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check      20  600  600  600; mv wisdom_new wisdom.600x600x600.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check      10  720  720  720; mv wisdom_new wisdom.720x720x720.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check      10  729  729  729; mv wisdom_new wisdom.729x729x729.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check      10  800  800  800; mv wisdom_new wisdom.800x800x800.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check      10  810  810  810; mv wisdom_new wisdom.810x810x810.$CPU_MODEL_NAME.$OMP_NUM_THREADS
../fft_check       5  900  900  900; mv wisdom_new wisdom.900x900x900.$CPU_MODEL_NAME.$OMP_NUM_THREADS
