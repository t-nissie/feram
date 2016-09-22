#!/usr/bin/env ruby
# feram_transition_sorter.rb
# Time-stamp: <2016-07-19 11:08:36 t-nissie>
# Author: Takeshi NISHIMATSU
# Example1: feram_transition_detector.rb 0.05 cooling.avg heating.avg | grep Tc | feram_transition_sorter.rb"
##
c3 = ARGF.gets.strip.split[0].to_f
c2 = ARGF.gets.strip.split[0].to_f
c1 = ARGF.gets.strip.split[0].to_f
h1 = ARGF.gets.strip.split[0].to_f
h2 = ARGF.gets.strip.split[0].to_f
h3 = ARGF.gets.strip.split[0].to_f
raise RuntimeError, "Too many (>6) lines in input." if ARGF.gets
printf "%6.2f %6.2f   %6.2f %6.2f   %6.2f %6.2f\n",c1,h1,c2,h2,c3,h3
#local variables:
#  compile-command: "ruby feram_transition_detector.rb 0.05 21example-KNbO3/*ing.avg | grep Tc | ruby feram_transition_sorter.rb"
#End:
