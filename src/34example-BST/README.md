src/34example-BST
=================
## Generate subdirectories
    ./xmaker.sh

## Submit jobs in IMR
    cd x0.0
    for x in `seq -w 0.0 0.1 1.0`; do cd ../x$x && submit SC general -pt 16 -exec cooling.csh -J cooling-$x && submit SC general -pt 16 -exec heating.csh -J heating-$x; done

## Plot with GNUPLOT and convert with ImageMagick:
    for x in `seq -w 0.0 0.1 1.0`; do cd ../x$x; ../polarization.gp; convert -density 100 -flatten polarization_a.eps polarization_a.gif; done
    cd ..
    gifsicle --colors=256 --delay=30 --loop  x*/po*.gif > polarization_animation.gif

## Detect transition temperatures
    cd x0.0
    cd ../x0.0/ && ../../feram_transition_detector.rb 0.017 *ing.avg | grep Tc | ../../feram_transition_sorter.rb | tee Tc.dat
    cd ../x0.1/ && ../../feram_transition_detector.rb 0.021 *ing.avg | grep Tc | ../../feram_transition_sorter.rb | tee Tc.dat
             :
    cd ../x1.0/ && ../../feram_transition_detector.rb 0.021 *ing.avg | grep Tc | ../../feram_transition_sorter.rb | tee Tc.dat
    cd ..
    grep ' [01]' */Tc.dat | sed -e 's%/Tc.dat:%   %'  -e 's%x% %' > Tc.dat
    gnuplot Tc.gp

## Optimization in acoustic displacements
Delete `acoustic_mass_amu = 41.67` in cooling.sh and heating.sh.

## Nosé-Poincaré thermostat with optimization in acoustic displacements
Delete `method = 'vs'`.
Repalce `acoustic_mass_amu = 41.67` in cooling.sh and heating.sh with
`Q_Nose = 0.1` and `Q_Nose = 0.01`, respectively.
