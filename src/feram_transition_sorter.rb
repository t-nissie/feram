#!/usr/bin/env ruby
# feram_transition_sorter.rb
# Time-stamp: <2016-06-30 12:18:02 takeshi>
# Author: Takeshi NISHIMATSU
# Example1: feram_transition_detector.rb 0.05 cooling.avg heating.avg | grep Tc | feram_transition_sorter.rb"
##
c3 = ARGF.gets.strip.split[0]
c2 = ARGF.gets.strip.split[0]
c1 = ARGF.gets.strip.split[0]
h1 = ARGF.gets.strip.split[0]
h2 = ARGF.gets.strip.split[0]
h3 = ARGF.gets.strip.split[0]
printf "%s %s  %s %s  %s %s\n",c1,h1,c2,h2,c3,h3
#local variables:
#  compile-command: "ruby feram_transition_detector.rb 0.05 21example-KNbO3/*ing.avg | grep Tc | ruby feram_transition_sorter.rb"
#End:
