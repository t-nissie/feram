feram-0.26.00
=============
Dear current and future feram users,

I released feram-0.26.00.tar.xz from
https://sourceforge.net/projects/loto/files/feram/feram-0.26.00/ .
This is a stable release, I hope.

MD5 (feram-0.26.00.tar.xz) = 

`feram` is a fast molecular dynamics (MD) simulator
for bulk and thin-film ferroelectrics. Its homepage is
http://loto.sourceforge.net/feram/ .

I also released a *slideshare* of 5 pages from
http://www.slideshare.net/TakeshiNishimatsu/feram-20150711slideshare
for the feram-0.24.??. You can download a PDF file from this URL.

Enjoy,

Takeshi

## Changes
In this feram-0.26.00, a bug in feram-0.24.02 of plot_dispersion is fixed.

From this feram-0.26.00, you can use .modulation input file.

From this feram-0.26.00, a .dipoRavg file will be written in the end.
Now, feram's development repository came back to
https://sourceforge.net/p/loto/code/HEAD/tree/feram/trunk/ .
https://sourceforge.net/p/loto/code/HEAD/tree/feram/branches/z_star_r/ was removed.

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
