feram-0.24.02
=============
Dear current and future feram users,

I released feram-0.24.02.tar.xz from
https://sourceforge.net/projects/loto/files/feram/feram-0.24.02/ .
This is a stable release, I hope.

MD5 (feram-0.24.02.tar.xz) = 

`feram` is a fast molecular dynamics (MD) simulator
for bulk and thin-film ferroelectrics. Its homepage is
http://loto.sourceforge.net/feram/ .

I also released a *slideshare* of 5 pages from
http://www.slideshare.net/TakeshiNishimatsu/feram-20150711slideshare
for the feram-0.24.??. You can download a PDF file from this URL.

Enjoy,

Takeshi

## Changes
In this feram-0.24.02, I added 2 digits for energies in the .avg file.
See https://sourceforge.net/p/loto/code/2595/ .

In this feram-0.24.02, I added a new test, feram_fftw_SoA.F.
It's just for benchmarks. This change is not important.

In the feram-0.24.01, a bug on writing/reading .coord files is
fixed. See https://sourceforge.net/p/loto/code/2581/ and
https://sourceforge.net/p/loto/code/2582/ .
You can check this fix by counting the number of lines of
resulting *ing.avg files in src/29example-BaTiO3-new-param-defects/.
They must have 651 lines.
    $ pwd
    /SOMEWHERE/src/29example-BaTiO3-new-param-defects
    $ for s in *g.sh; do numactl --cpubind=0 ./$s; done   # It will take 1 week or so.
    $ wc -l *ing.avg
     651 anti-000-cooling.avg
     651 anti-000-heating.avg
     651 anti-070-cooling.avg
               :

Now, feram's development repository came back to
https://sourceforge.net/p/loto/code/HEAD/tree/feram/trunk/ .
https://sourceforge.net/p/loto/code/HEAD/tree/feram/branches/newplan/ was removed.

From the feram-0.24.00, the default value of padding_y became 1
instead of 3.

From the feram-0.24.00, the in-place FFT is introduced for
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
    0.24.0? | with              | strange peak
    0.24.0? | without           | OK
