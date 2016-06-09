#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# feram_modulation_maker.rb
# Time-stamp: <2016-06-09 18:28:33 takeshi>
# Author: Takeshi NISHIMATSU
# Usage:   ./feram_modulation_maker.rb Lx Ly Lz ratio [seed]
# Example: ./feram_modulation_maker.rb 16 16 16 0.5 2134567890
##
include Math
Lx = ARGV[0].to_i
Ly = ARGV[1].to_i
Lz = ARGV[2].to_i
ratio = ARGV[3].to_f

if ARGV[4] then
  srand(ARGV[4].to_i)
else
  srand(1234567890)
end

ary = Array.new(Lx).map!{Array.new(Ly).map!{Array.new(Lz,-1)}}

(Lx*Ly*Lz*ratio).to_i.times do
  begin
    ix=rand(Lx)
    iy=rand(Ly)
    iz=rand(Lz)
  end until ary[ix][iy][iz]<0
  ary[ix][iy][iz] = 1
end

(0...Lz).each do |iz|
  (0...Ly).each do |iy|
    (0...Lx).each do |ix|
      sum = 0
      (0..1).each do |dz|
        (0..1).each do |dy|
          (0..1).each do |dx|
            sum += ary[(ix+dx)%Lx][(iy+dy)%Ly][(iz+dz)%Lz]
          end
        end
      end
      printf("%3d %3d %3d   %2d\n", ix,iy,iz, sum)
    end
  end
end
