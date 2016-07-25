src/34example-BST
=================
## Generate subdirectories
    ./xmaker.sh

## (Skip it!) How to make and distribute a wisdom file (Optional technique only for experts)
    ../feram_fftw_wisdom 10000 32 32 32 1 FFTW_PATIENT
    mv wisdom_new wisdom
    for d in x[01]*; do cp wisdom $d; done

## Submit jobs in IMR (for example)
    cd x0.0
    for x in `seq -w 0.0 0.1 1.0`; do cd ../x$x && submit SC general -pt 16 -exec cooling.csh -J cooling-$x && submit SC general -pt 16 -exec heating.csh -J heating-$x; done

## Make a GIF animation
Plot with GNUPLOT and convert with ImageMagick, then make a GIF animation.
gifsicle(1) from https://www.lcdf.org/gifsicle/ is used.

    for x in `seq -w 0.0 0.1 1.0`; do cd ../x$x; ../polarization.gp; convert -density 100 -flatten polarization_a.eps polarization_a.gif; done
    cd ..
    gifsicle --colors=256 --delay=50 --loop  x*/po*.gif > polarization_animation.gif
    gifview polarization_animation.gif

## Detect transition temperatures
src/feram_transition_detector.rb is a tool to detect transition temperatures.
The first command line argument for it is a threshold value and the value should be adjusted.
With src/feram_transition_sorter.rb, you can make a data file for plotting.
Attached Tc.dat is an example data.

    cd x0.0
    cd ../x0.0/ && ../../feram_transition_detector.rb 0.020 cooling.avg | grep Tc | tee Tmp.dat
    cd ../x0.0/ && ../../feram_transition_detector.rb 0.017 heating.avg | grep Tc | tail -3 | tee -a Tmp.dat
    cat Tmp.dat
    100.00  0.00021  0.02955 -0.00161 Tc
     81.00 -0.00048  0.04517 -0.03750 Tc
     72.00  0.03133  0.04350 -0.04278 Tc
     78.00 -0.04346 -0.00211 -0.04455 Tc
     84.00 -0.00215 -0.00193 -0.05290 Tc
    100.00  0.00180  0.00714 -0.01143 Tc
    ../../feram_transition_sorter.rb Tmp.dat | tee Tc.dat
     72.00  78.00    81.00  84.00   100.00 100.00
    cd ../x0.1/ && ../../feram_transition_detector.rb 0.021 *ing.avg | grep Tc | ../../feram_transition_sorter.rb | tee Tc.dat
             :
    cd ../x1.0/ && ../../feram_transition_detector.rb 0.050 *ing.avg | grep Tc | ../../feram_transition_sorter.rb | tee Tc.dat
    cd ..
    grep ' ' */Tc.dat | sed -e 's%/Tc.dat:%   %'  -e 's%x% %' > Tc.dat
    gnuplot Tc.gp

## Plot x-dependence of polarization
You can automatically plot x-dependence of
polarization |P| with P.rb and P.gp.
Attached P.dat is an example data.

    ruby P.rb Tc.dat > P.dat
    gnuplot P.gp
    gv -watch P.eps
    evince P.pdf

## Optimization in acoustic displacements
Delete `acoustic_mass_amu = 41.67` in cooling.sh and heating.sh.

## Nosé-Poincaré thermostat with optimization in acoustic displacements
Delete `method = 'vs'`.
Repalce `acoustic_mass_amu = 41.67` in cooling.sh and heating.sh with
`Q_Nose = 0.1` and `Q_Nose = 0.01`, respectively.
