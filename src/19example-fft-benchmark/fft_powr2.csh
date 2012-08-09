#!/bin/csh
setenv OMP_NUM_THREADS 6
taskset -c 0-5 ../fft_check  100000   32   32   32 >> fft_powr2.X5650.1CPU.dat
taskset -c 0-5 ../fft_check   10000   64   64   64 >> fft_powr2.X5650.1CPU.dat
taskset -c 0-5 ../fft_check   10000  256   64   32 >> fft_powr2.X5650.1CPU.dat
taskset -c 0-5 ../fft_check    1000   16 1024   64 >> fft_powr2.X5650.1CPU.dat
taskset -c 0-5 ../fft_check    1000  128  128  128 >> fft_powr2.X5650.1CPU.dat
taskset -c 0-5 ../fft_check     100  256  256  256 >> fft_powr2.X5650.1CPU.dat
taskset -c 0-5 ../fft_check     100  128  256 1024 >> fft_powr2.X5650.1CPU.dat
taskset -c 0-5 ../fft_check     100  256  256  512 >> fft_powr2.X5650.1CPU.dat
taskset -c 0-5 ../fft_check      50  256  512  512 >> fft_powr2.X5650.1CPU.dat
taskset -c 0-5 ../fft_check      50  512  256  512 >> fft_powr2.X5650.1CPU.dat
taskset -c 0-5 ../fft_check      50  512  512  512 >> fft_powr2.X5650.1CPU.dat
taskset -c 0-5 ../fft_check      50  256  512 1024 >> fft_powr2.X5650.1CPU.dat
taskset -c 0-5 ../fft_check      50 1024  512  256 >> fft_powr2.X5650.1CPU.dat
taskset -c 0-5 ../fft_check      50  512  512 1024 >> fft_powr2.X5650.1CPU.dat
taskset -c 0-5 ../fft_check      50  512 1024 1024 >> fft_powr2.X5650.1CPU.dat
taskset -c 0-5 ../fft_check      20 1024 1024 1024 >> fft_powr2.X5650.1CPU.dat

setenv OMP_NUM_THREADS 12
../fft_check  100000   32   32   32 >> fft_powr2.X5650.1node.dat
../fft_check   10000   64   64   64 >> fft_powr2.X5650.1node.dat
../fft_check   10000  256   64   32 >> fft_powr2.X5650.1node.dat
../fft_check    1000   16 1024   64 >> fft_powr2.X5650.1node.dat
../fft_check    1000  128  128  128 >> fft_powr2.X5650.1node.dat
../fft_check     100  256  256  256 >> fft_powr2.X5650.1node.dat
../fft_check     100  128  256 1024 >> fft_powr2.X5650.1node.dat
../fft_check     100  256  256  512 >> fft_powr2.X5650.1node.dat
../fft_check      50  256  512  512 >> fft_powr2.X5650.1node.dat
../fft_check      50  512  256  512 >> fft_powr2.X5650.1node.dat
../fft_check      50  512  512  512 >> fft_powr2.X5650.1node.dat
../fft_check      50  256  512 1024 >> fft_powr2.X5650.1node.dat
../fft_check      50 1024  512  256 >> fft_powr2.X5650.1node.dat
../fft_check      50  512  512 1024 >> fft_powr2.X5650.1node.dat
../fft_check      50  512 1024 1024 >> fft_powr2.X5650.1node.dat
../fft_check      20 1024 1024 1024 >> fft_powr2.X5650.1node.dat
