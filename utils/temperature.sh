#!/bin/sh
t=50
while [ $t -le 170 ]; do
    directory=`printf "%3.3i" $t`K
    mkdir --verbose $directory 
    sed -e "s/.*temperature \[K\]/$t.0/" temperature.in > $directory/$directory.in
    ../feram < $directory/$directory.in > $directory/feram.out
    t=`expr $t + 5`
done
