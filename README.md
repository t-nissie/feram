feram-0.24.00
=============
Dear current and future feram users,

I released feram-0.24.00.tar.xz from
https://sourceforge.net/projects/loto/files/feram/feram-0.24.00/ .
This is a stable release, I hope.

MD5 (feram-0.24.00.tar.xz) = f86f0df68cc5164de31d920273d427d8

`feram` is a fast molecular dynamics (MD) simulator
for bulk and thin-film ferroelectrics. Its homepage is
http://loto.sourceforge.net/feram/ .

I also released a *slideshare* of 5 pages from
http://www.slideshare.net/TakeshiNishimatsu/feram-20150711slideshare
for this feram-0.24.00. You can download a PDF file from this URL.

Enjoy,

Takeshi

## Changes
From this feram-0.24.00, the default value of padding_y became 1
instead of 3.

From this feram-0.24.00, the in-place FFT is introduced for
two arrays dVdacK->dVdacR (src/dVdac.F, src/leapfrog.F and
src/velocity_scaling.F) and inhoK->inhoR (src/dVddi_inho_coupling.F)
with plans of plan_c2r_3_in and plan_c2r_6_in, respectively.
See src/coord_module.F.

In the feram-0.23.02unstable, there were some changes in the
source code for further speed up.

In the feram-0.23.01unstable, a bug in src/leapfrog.F is fixed and
simulations of thermal conductivity can be done with .defects files.

From the feram-0.23.01unstable, `make check` and `make distcheck`
execute five integration tests for feram with src/zzz*.feram_check.
It is useful for developers. See src/Makefile.am and src/feram_common.F.

From the feram-0.23.00unstable, internal data structure is largely modified.

From the feram-0.23.00unstable, you can do `make check` on Windows.

From the feram-0.23.00unstable, some tools are renamed by
adding feram_ in their heads.

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
    0.24.00 | with              | strange peak
    0.24.00 | without           | OK
