feram-0.26.01
=============
Dear current and future feram users,

I released feram-0.26.01.tar.xz from
https://sourceforge.net/projects/loto/files/feram/feram-0.26.01/ .
This is a stable release, I hope.

MD5 (feram-0.26.01.tar.xz) = 3f4ff69d9f189cf7c9b45bbfeab0f100

`feram` is a fast molecular dynamics (MD) simulator
for bulk and thin-film ferroelectrics. Its homepage is
http://loto.sourceforge.net/feram/ .

Enjoy,

Takeshi

## Changes
In this feram-0.26.01, some bugs and typos are fixed.

In the feram-0.26.00, a bug in feram-0.24.02 of plot_dispersion is fixed.

From the feram-0.26.00, you can use .modulation input file.
You can simulate (Ba,Sr)TiO3, now.
See files in feram-0.26.00/src/34example-BST/.
I will put our paper on arXiv as soon as possible.

From this feram-0.26.00, a .dipoRavg file will be written in the end.

## Known bug
OpenMP-parallelization does not work efficiently over two or
more NUMA chips of Intel Xeon CPUs which is released after
2011 (Sandy Bridge, Ivy Bridge, Haswell, Broadwell, ...).
Execute feram within single chip by using numactl(8) command.

Intel Fortran (ifort) cannot make a fast executable,
because there is no optimized fftw_plan_many_dft_r2c() nor
ftw_plan_many_dft_c2r() in Intel Math Kernel Library (MKL), so far.

Hysteresis loop calculations of **film** goes wrong.
A strange peak appears in the beginning.
See src/23example-BaTiO3-new-param-hl-film-acoustic-mass/.
Bulk calculations go very fine.

    Version | acoustic_mass_amu | Good or N.G.
    ------- | ----------------- | ------------
    0.20.00 | with              | strange peak
    0.20.00 | without           | Good
    0.21.04 | with              | strange peak
    0.21.04 | without           | Good
    0.22.00 | with              | strange peak
    0.22.00 | without           | Good
    0.22.01 | with              | strange peak
    0.22.01 | without           | Good
    0.22.02 | with              | strange peak
    0.22.02 | without           | Good
    0.22.03 | with              | paraelectric
    0.22.03 | without           | paraelectric
    0.22.04 | with              | paraelectric
    0.22.04 | without           | paraelectric
    0.22.05 | with              | strange peak
    0.22.05 | without           | OK
    0.22.06 | with              | strange peak
    0.22.06 | without           | OK
    0.23.0? | with              | strange peak
    0.23.0? | without           | OK
    0.24.0? | with              | strange peak
    0.24.0? | without           | OK
    0.26.0? | with              | strange peak
    0.26.0? | without           | OK
