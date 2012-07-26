#!/usr/bin/env ruby
# Usage: ./atable.rb
##
open("atable.dat","r"){|a|
  while true
    exit unless a.gets   # skip a line
    a.gets   # skip a line
    dmy1, dmy2, dmy3, title = a.gets.split(nil)
    a.gets   # skip a line
    open(title.gsub(/"/,'')+".duzdT", "w"){|o|
      temperature, uz = a.gets.split(nil)
      while true
        temperature_next, uz_next = a.gets.split(nil)
        break unless uz_next
        o.printf("%7.2f%14.9f\n", (temperature.to_f+temperature_next.to_f)/2,  (uz_next.to_f-uz.to_f)/(temperature_next.to_f-temperature.to_f))
        temperature  = temperature_next
        uz           = uz_next
      end
    }
  end
}
