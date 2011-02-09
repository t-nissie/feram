#!/usr/bin/env ruby
# defects-maker.rb
# Time-stamp: <2011-02-09 19:16:33 takeshi>
# Author: Takeshi NISHIMATSU
# Usage:   ./defects-maker.rb Lx Ly Lz fixed_dipole n_defects
# Example: ./defects-maker.rb 16 16 81 '0.00 0.00 0.05' 100
# Example: ./defects-maker.rb 16 16 81 'rand 0.05' 100
##
(1..ARGV[4].to_i).each do |ix|
  randp, absu = ARGV[3].strip.split

  if randp=='rand' then
    absu = absu.to_f
    theta=Math::PI*rand()
    phi=2*Math::PI*rand()
    u=sprintf("%10.5f%10.5f%10.5f", absu*Math::sin(theta)*Math::cos(phi),
                                    absu*Math::sin(theta)*Math::sin(phi),
                                    absu*Math::cos(theta) )
  else
    u=ARGV[3]
  end

  printf("%3d %3d %3d   %s\n", rand(ARGV[0].to_i),
                               rand(ARGV[1].to_i),
                               rand(ARGV[2].to_i), u)
end
