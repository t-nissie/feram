#!/usr/bin/env ruby
# feram_fcc_maker.rb
# Time-stamp: <2016-04-07 18:15:24 takeshi>
# Author: Takeshi NISHIMATSU
##
Lx     = ARGV[0].to_i
Ly     = ARGV[1].to_i
Lz     = ARGV[2].to_i
Z_star = ARGV[3]
(0...Lz).each do |iz|
  (0...Ly).each do |iy|
    (0...Lx).each do |ix|
      printf("%3d %3d %3d   %s\n", ix, iy,iz, Z_star)
    end
  end
end
