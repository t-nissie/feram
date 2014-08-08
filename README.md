feram-0.22.04
=============
Dear current and future feram users,

I released feram-0.22.04.tar.xz from
http://sourceforge.net/projects/loto/files/feram/ .

MD5 (feram-0.22.04.tar.xz) = 051e04a5cddd0301df4e8b71b666c402

"feram" is a fast molecular dynamics (MD) simulator
for bulk and thin-film ferroelectrics. Its homepage is
http://loto.sourceforge.net/feram/ .

Enjoy,

Takeshi

## Changes
In this feram-0.22.04, bugs in rnd?.defects files in
src/29example-BaTiO3-new-param-defects/ are fixed.
See feram-0.22.04/src/29example-BaTiO3-new-param-defects/histogram.jpg .

In the feram-0.22.03, bugs in kinetic_energy_dipo.F
and velocity_scaling.F are fixed.
Now, you can safely perform simulations with defects.

From the feram-0.22.02, a new exapmle src/28example-PbTiO3-elastocaloric-770K/
is included in the package. See http://arxiv.org/abs/1404.5459 ,
though we will revise this preprint soon.

From the feram-0.22.01, in a leapfrog method with acoustic_mass_amu,
final temperature is reported form an average of dipolar and acoustic
kinetic energies. See subroutine divide_and_write_Average() in
src/average_module.F.

A new feature is available form the feram-0.22.00,
tags of n_E_wave_period and E_wave_type.
n_E_wave_period is the period of alternating external electric field
which have external_E_field amplitude. Set 'triangular_sin' or
'triangular_cos' to E_wave_type. See example files in
src/27example-BaTiO3-new-param-E_wave/ .


## Known bug
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
