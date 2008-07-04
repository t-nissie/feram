#!/usr/bin/env ruby
# histogram.rb
# Time-stamp: <2008-07-04 19:34:14 takeshi>
# Author: Takeshi NISHIMATSU
##
hx={}
hy={}
hz={}
while line=ARGF.gets
  ix, iy, iz, ux, uy, uz = line.strip.split

  ux=sprintf("%.2f", ux)
  ux="0.00" if ux=="-0.00"
  if hx[ux]
    hx[ux]=hx[ux]+1
  else
    hx[ux]=1
  end

  uy=sprintf("%.2f", uy)
  uy="0.00" if uy=="-0.00"
  if hy[uy]
    hy[uy]=hy[uy]+1
  else
    hy[uy]=1
  end

  uz=sprintf("%.2f", uz)
  uz="0.00" if uz=="-0.00"
  if hz[uz]
    hz[uz]=hz[uz]+1
  else
    hz[uz]=1
  end
end

u=-0.25
while u<=0.251
  printf("%5.2f%8i%8i%8i\n", u, hx[sprintf("%.2f", u)], hy[sprintf("%.2f", u)], hz[sprintf("%.2f", u)])
  u += 0.01
end
