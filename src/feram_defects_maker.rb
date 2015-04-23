#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# defects_maker.rb
# Time-stamp: <2014-06-21 14:12:39 takeshi>
# Author: Takeshi NISHIMATSU
# Reference: 渡辺宙志 (Hiroshi Watanabe): 『一様乱数を使う (Using RNG)』
#            http://apollon.issp.u-tokyo.ac.jp/~watanabe/pdf/prob.pdf [in Japanese]
# Usage:   ./defects_maker.rb Lx Ly Lz fixed_dipole n_defects [seed]
# Example: ./defects_maker.rb 16 16 81 '0.00 0.00 0.05' 100
# Example: ./defects_maker.rb 16 16 81 'rand 0.05'      100 2134567890
##
include Math
Lx = ARGV[0].to_i
Ly = ARGV[1].to_i
Lz = ARGV[2].to_i
randp, absu = ARGV[3].strip.split

if ARGV[5] then
  srand(ARGV[5].to_i)
else
  srand(1234567890)
end

ary = Array.new(Lx).map!{Array.new(Ly).map!{Array.new(Lz,true)}}

ARGV[4].to_i.times do
  if randp=='rand' then
    z   = rand(-1.0..1.0)
    phi = rand(0...2*PI)
    u=sprintf("%10.5f%10.5f%10.5f", absu.to_f * sqrt(1.0-z**2) * cos(phi),
                                    absu.to_f * sqrt(1.0-z**2) * sin(phi),
                                    absu.to_f * z )
  else
    u=ARGV[3]
  end

  ix=0
  iy=0
  iz=0
  begin
    ix=rand(Lx)
    iy=rand(Ly)
    iz=rand(Lz)
  end until ary[ix][iy][iz]
  ary[ix][iy][iz] = false

  printf("%3d %3d %3d   %s\n", ix,
                               iy,
                               iz, u)
end
