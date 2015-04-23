#!/usr/bin/env ruby
# feram_coord2dist.rb
# Time-stamp: <2015-04-23 17:40:43 takeshi>
# Author: Takeshi NISHIMATSU
# Usage: ./feram_coord2dist.rb --help
#        ./feram_coord2dist.rb -r 0.5 -s 0.1 coord_file1 coord_file2 coord_file3 ...
##

# Default values
range =  0.4
step  =  0.01

# Command arguments
require "optparse"
opts = OptionParser.new
opts.on("-r RANGE","--range RANGE",
        "Distribution will be counted from -RANGE to REANGE"){|v| range = v.to_f}
opts.on("-s STEP","--step STEP",
        "Distribution will be counted in STEP"){|v| step=v.to_f}
opts.parse!(ARGV)

# Prepare three arrays
n=(2*range/step).floor+1
ary_x = Array.new(n, 0)
ary_y = Array.new(n, 0)
ary_z = Array.new(n, 0)

# Read from files
ARGF.each {|line|
  x,y,z,q_x,q_y,q_z = line.strip.split
  ix = ((q_x.to_f+range+step/2)/step).floor
  iy = ((q_y.to_f+range+step/2)/step).floor
  iz = ((q_z.to_f+range+step/2)/step).floor
  ary_x[ix] += 1 if (0...n).include?(ix)
  ary_y[iy] += 1 if (0...n).include?(iy)
  ary_z[iz] += 1 if (0...n).include?(iz)
}

# Write to STDOUT
u = -range
n.times{|i|
  printf("%9.5f %10d %10d %10d\n", u,ary_x[i],ary_y[i],ary_z[i])
  u += step
}

#Local variables:
#  compile-command: "ruby feram_coord2dist.rb -r 0.5 -s 0.1 feram_coord2dist.coord > feram_coord2dist.dist && cat feram_coord2dist.dist"
#End:
