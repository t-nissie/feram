#!/usr/bin/env ruby
optcell=0
direction_x=1
direction_y=1
direction_z=0
ndtset=20
stepA = 0.00015
stepB = 0.00060
stepO =-0.00030

fname = "perovskite-optcell#{optcell}-#{direction_x}#{direction_y}#{direction_z}.in"

File.open(fname, 'w'){|f|
  f.print "optcell #{optcell}
ionmov 2
ntime 15

prtwf 1
getwfk -1
prtden 0

ecut 63.0
ecutsm 3.0
dilatmx 1.1
ixc 3

acell 3*7.4419883555

rprim  1 0 0
       0 1 0
       0 0 1

#Definition of the atom types
ntypat 3
znucl 56 22 8

#Definition of the atoms
natom 5
typat 1*1 1*2 3*3

#Definition of the k-point grid
kptopt 1
ngkpt  8 8 8
nshiftk 1
shiftk 0.5 0.5 0.5

#Definition of the SCF procedure
nstep 45
toldff 5.0d-7
diemac 12.0

ndtset #{ndtset}
"

  (1..ndtset).each{|i|
    f.print "
xred#{i}
    #{0.0+stepA*i*direction_x} #{0.0+stepA*i*direction_y} #{0.0+stepA*i*direction_z}
    #{0.5+stepB*i*direction_x} #{0.5+stepB*i*direction_y} #{0.5+stepB*i*direction_z}
    #{0.0+stepO*i*direction_x} #{0.5+stepO*i*direction_y} #{0.5+stepO*i*direction_z}
    #{0.5+stepO*i*direction_x} #{0.0+stepO*i*direction_y} #{0.5+stepO*i*direction_z}
    #{0.5+stepO*i*direction_x} #{0.5+stepO*i*direction_y} #{0.0+stepO*i*direction_z}
"
  }
}

#Local variables:
#  compile-command: "ruby perovskite-optcell0-110.rb"
#End:
