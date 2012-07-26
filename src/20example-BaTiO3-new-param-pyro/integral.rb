#!/usr/bin/env ruby
# Usage: ./integral.rb 50 310 250.5
##
int=0.0
open("T"+ARGV[2]+".dat","r"){|a|
  last_e = 0.0
  last_duzdT = 0.0
  while line=a.gets
    e, t, duzdT = line.split(nil)

    e = e.to_f
    duzdT = duzdT.to_f

    if ARGV[0].to_f<e && e<=ARGV[1].to_f then
      int += (duzdT+last_duzdT)*(e-last_e)/2
    end

    last_e = e
    last_duzdT = duzdT
  end
}
printf("%s %20.10f\n",ARGV[2],int)
