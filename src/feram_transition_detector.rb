#!/usr/bin/env ruby
# feram_transition_detector.rb
# Time-stamp: <2016-06-29 11:54:24 takeshi>
# Author: Takeshi NISHIMATSU
# Usage:    ./feram_transition_detector.rb threshold file(s)
# Example1: ./feram_transition_detector.rb 0.05 cooling.avg
# Example2: ./feram_transition_detector.rb 0.05 21example-KNbO3/*ing.avg | grep Tc
##
threshold = ARGV.shift.to_f

last_x = Float::MAX
last_y = Float::MAX
last_z = Float::MAX
ARGF.each do |line|
  ary = line.strip.split
  temperature = ary[0].to_f
  current_x = ary[10].to_f
  current_y = ary[11].to_f
  current_z = ary[12].to_f
  last_x = current_x if ARGF.file.lineno == 1
  last_y = current_y if ARGF.file.lineno == 1
  last_z = current_z if ARGF.file.lineno == 1
  if (current_x-last_x).abs > threshold ||
     (current_y-last_y).abs > threshold ||
     (current_z-last_z).abs > threshold then
    flag = " Tc"
  else
    flag = ""
  end
  printf("%6.2f%9.5f%9.5f%9.5f%s\n",temperature,current_x,current_y,current_z,flag)
  last_x = current_x
  last_y = current_y
  last_z = current_z
end
#local variables:
#  compile-command: "ruby feram_transition_detector.rb 0.05 21example-KNbO3/*ing.avg | grep Tc"
#End:
