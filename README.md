feram-0.23.00unstable
=====================
Dear current and future feram users,

I released feram-0.23.00unstable.tar.xz from
http://sourceforge.net/projects/loto/files/feram/ .
Please note that version 0.23.?? will be UNSTABLE experimental releases.

MD5 (feram-0.23.00unstable.tar.xz) = 

`feram` is a fast molecular dynamics (MD) simulator
for bulk and thin-film ferroelectrics. Its homepage is
http://loto.sourceforge.net/feram/ .

Enjoy,

Takeshi

## Changes
From this feram-0.23.00unstable, internal data structure is largely modified.
You may be able to speed up your calculations with the `padding_y` tag.
It is developed under a branch of subversion,
https://sourceforge.net/p/loto/code/HEAD/tree/feram/branches/newplan/ .
See README.en or README.ja and src/coord_module.F.

From this feram-0.23.00unstable, you can do `make check` on Windows.

A bug in src/27example-BaTiO3-new-param-E_wave/generator.sh is fixed.
You can generate some input files automatically now.

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
    0.23.00 | with              | strange peak
    0.23.00 | without           | OK
