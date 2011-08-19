#!/usr/bin/env ruby
optcell=2
direction_x=0
direction_y=0
direction_z=1
ndtset=40
stepA = 0.0015
stepB = 0.0030
stepO =-0.0015

fname = "perovskite-optcell#{optcell}-#{direction_x}#{direction_y}#{direction_z}.in"

File.open(fname, 'w'){|f|
  f.print "optcell #{optcell}
ionmov 2
ntime 60

prtwf 1
getwfk -1
prtden 0

ecut 63.0
ecutsm 3.0
dilatmx 1.2
ixc 23

acell 7.5 7.5 8.5

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
nstep 80
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
#  compile-command: "ruby perovskite-optcell2-001.rb"
#End:
