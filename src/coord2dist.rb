#!/usr/bin/env ruby
# coord2dist.rb
# Time-stamp: <2012-03-17 15:42:01 takeshi>
# Author: Takeshi NISHIMATSU
# Usage: ./coord2dist.rb coord-file [min] [max] [step]
##

# Default values
min  = -0.4
max  =  0.4
step =  0.01

coord_file = ARGV[0]
min  = ARGV[1].to_f if ARGV[1]
max  = ARGV[2].to_f if ARGV[2]
step = ARGV[3].to_f if ARGV[3]

n=((max-min)/step).floor+1
ary_x = Array.new(n, 0)
ary_y = Array.new(n, 0)
ary_z = Array.new(n, 0)

File.open(coord_file, "r"){|c|
  c.each do |line|
    x,y,z,q_x,q_y,q_z = line.strip.split
    ix = ((q_x.to_f-min+step/2)/step).floor
    iy = ((q_y.to_f-min+step/2)/step).floor
    iz = ((q_z.to_f-min+step/2)/step).floor
    ary_x[ix] += 1 if (0...n).include?(ix)
    ary_y[iy] += 1 if (0...n).include?(iy)
    ary_z[iz] += 1 if (0...n).include?(iz)
  end
}

filename = File.basename(coord_file, ".coord")+".dist"
File.open(filename, "w"){|c|
  u = min
  n.times{|i|
    c.printf("%8.5f %10d %10d %10d\n", u,ary_x[i],ary_y[i],ary_z[i])
    u += step
  }
}

#Local variables:
#  compile-command: "ruby coord2dist.rb coord2dist.coord -0.5 0.5 0.1 && cat coord2dist.dist"
#End:
