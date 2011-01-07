#!/usr/bin/env ruby
# defects-maker.rb
# Time-stamp: <2011-01-07 18:14:58 takeshi>
# Author: Takeshi NISHIMATSU
# Usage:   ./defects-maker.rb Lx Ly Lz fixed_dipole
# Example: ./defects-maker.rb 16 16 81 '0.00 0.00 0.05'
##
(0...ARGV[0].to_i).each do |ix|
  (0...ARGV[1].to_i).each do |iy|
    printf("%3d %3d %3d   %s\n", ix, iy, rand(ARGV[2].to_i/2), ARGV[3])
  end
end
