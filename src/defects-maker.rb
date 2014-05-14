#!/usr/bin/env ruby
# defects-maker.rb
# Time-stamp: <2014-05-14 18:39:41 takeshi>
# Author: Takeshi NISHIMATSU
# Usage:   ./defects-maker.rb Lx Ly Lz fixed_dipole n_defects [seed]
# Example: ./defects-maker.rb 16 16 81 '0.00 0.00 0.05' 100
# Example: ./defects-maker.rb 16 16 81 'rand 0.05'      100 2134567890
##
randp, absu = ARGV[3].strip.split

if ARGV[5] then
  srand(ARGV[5].to_i)
else
  srand(1234567890)
end

(1..ARGV[4].to_i).each do |ix|
  if randp=='rand' then
    z   = rand(-1.0..1.0)
    phi = rand(0...2*Math::PI)
    u=sprintf("%10.5f%10.5f%10.5f", absu.to_f * Math::sqrt(1.0-z**2) * Math::cos(phi),
                                    absu.to_f * Math::sqrt(1.0-z**2) * Math::sin(phi),
                                    absu.to_f * z )
  else
    u=ARGV[3]
  end

  printf("%3d %3d %3d   %s\n", rand(ARGV[0].to_i),
                               rand(ARGV[1].to_i),
                               rand(ARGV[2].to_i), u)
end
