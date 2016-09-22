#!/usr/bin/env ruby
# feram_fcc_maker.rb
# Time-stamp: <2016-04-07 18:36:21 takeshi>
# Author: Takeshi NISHIMATSU
##
Lx     = ARGV[0].to_i
Ly     = ARGV[1].to_i
Lz     = ARGV[2].to_i
a3     = ARGV[3]
a4     = ARGV[4]
(0...Lz).each do |iz|
  (0...Ly).each do |iy|
    (0...Lx).each do |ix|
      if (ix+iy+iz)%2==0
        printf("%3d %3d %3d   %s\n", ix, iy,iz, a3)
      else
        printf("%3d %3d %3d   %s\n", ix, iy,iz, a4)
      end
    end
  end
end
