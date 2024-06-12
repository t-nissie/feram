feram-0.26.05
=============
Dear current and future feram users,

I just released feram-0.26.05.tar.xz from
https://sourceforge.net/projects/loto/files/feram/feram-0.26.05/ .
This is a stable release.

SHA1 (feram-0.26.05.tar.xz) = b2c3b8383c8405a11be40822811db6affd8dbe86

`feram` is a fast molecular dynamics (MD) simulator
for bulk and thin-film ferroelectrics. Its homepage is
http://loto.sourceforge.net/feram/ .

Enjoy,

Takeshi

## Changes
In this feram-0.26.05, a bug in plots of inhomo-K (long-wavelength-approximated
acoustic phonon) along Lambda-axis and S-axis is fixed in src/elastic.F.
This fix does not affect results of MD simulations.
You can check the degeneracy of phonon branches with:

    make check TESTS='dispersion_check.sh dispersion_32x32x32.inhomo-K.gp'
    less   dispersion_32x32x32.inhomo-K.dat
    evince dispersion_32x32x32.inhomo-K.eps

In the feram-0.26.04, author's email address is changed.
Some test scripts are fixed for gnuplot 5.x.
If you are currently using feram-0.26.03, you do not have to update that.

With the feram-0.26.03, you can draw a slice of the
supercell directly by feram. Output file `foo123.nnnnnnnnnn.slice.eps`
is the visualized slice of a film at z=Lz/4, at the nnnnnnnnnn-th
iteration and at every `n_coord_freq` iterations.
Output of this .slice.eps file can be suppressed with
`slice_directory = 'never'` in the .feram input file.

In the feram-0.26.02, some bugs and typos are fixed.
For example, src/24example-BaTiO3-new-param-heating-cooling/polarization.gp .

In the feram-0.26.01, some bugs and typos are fixed.

From the feram-0.26.00, you can use .modulation input file.
You can simulate (Ba,Sr)TiO3, now.
See files in feram-0.26.00/src/34example-BST/.
See http://arxiv.org/abs/1608.06433 also.

In the feram-0.26.00, a bug in feram-0.24.02 of plot_dispersion is fixed.

From this feram-0.26.00, a .dipoRavg file will be written in the end.

## Tips for *.slice.eps
### animation
convert(1) of http://www.imagemagick.org
gifsicle(1) and figview(1) of https://www.lcdf.org/gifsicle/ are useful.

    $ for e in *.eps; do convert -density 40 -flatten $e `basename $e .eps`.gif; done
    $ gifsicle --delay=5 *.slice.gif > animation.gif

### color to black-and-white
Edit .eps files directly,
or you can edit src/coord_module.F or src/feram_slicer.rb .

    --- color.slice.eps	2016-10-21 21:19:02.000000000 +0900
    +++ bw.slice.eps	2016-10-21 21:21:39.000000000 +0900
    @@ -25,7 +25,7 @@
       0    y_height LineWidth20 sub rlineto
       x_width LineWidth20 sub neg 0 rlineto
      closepath
    - 1 0 0 setrgbcolor
    + 0.5 setgray
      LineWidth setlinewidth
      stroke
     } def
    @@ -42,7 +42,7 @@
       0    y_height LineWidth sub rlineto
       x_width LineWidth sub neg 0 rlineto
       closepath
    -  0 0 1 setrgbcolor fill
    +  0.0 setgray fill
     } def
     0 0 Down
     1 0 Down


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
