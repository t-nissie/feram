#!/bin/sh
##
for T in `jot - 250.5 899.5 1`; do grep "^ $T" *h.duzdT | sed -e 's/h\.duzdT://' > T$T.dat; done

rm -f E*.dat

for T in `jot - 250.5 899.5 1`; do ./integral.rb  60 310 $T >> E060-310.dat ; done
for T in `jot - 250.5 899.5 1`; do ./integral.rb 110 310 $T >> E110-310.dat ; done
for T in `jot - 250.5 899.5 1`; do ./integral.rb 160 310 $T >> E160-310.dat ; done
for T in `jot - 250.5 899.5 1`; do ./integral.rb 210 310 $T >> E210-310.dat ; done
for T in `jot - 250.5 899.5 1`; do ./integral.rb 260 310 $T >> E260-310.dat ; done

for T in `jot - 250.5 899.5 1`; do ./integral.rb 160 260 $T >> E160-260.dat ; done
for T in `jot - 250.5 899.5 1`; do ./integral.rb 110 210 $T >> E110-210.dat ; done
for T in `jot - 250.5 899.5 1`; do ./integral.rb  60 160 $T >> E060-160.dat ; done
