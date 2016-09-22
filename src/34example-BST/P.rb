#!/usr/bin/env ruby
# feram_transition_sorter.rb
# Author: Takeshi NISHIMATSU
# Example: ruby P.rb Tc.dat > P.dat
##
header = ""
d111 = "# 111\n"
d110 = "# 110\n"
d100 = "# 100\n"
while line = ARGF.gets
  next if line =~ /^\s*#/
  x,c1,h1,c2,h2,c3,h3 = line.strip.split.map{|e| e.to_f}
  t111 =       ((c1+h1)/4).round.to_s
  t110 = ((c1+h1+c2+h2)/4).round.to_s
  t100 = ((c2+h2+c3+h3)/4).round.to_s
  header << sprintf("# %3.1f %s %s %s\n", x,t111,t110,t100)
  d111 << sprintf("%3.1f",x) << File.open("x#{x}/heating.avg").grep(/^\s*#{t111}\./)[0]
  d110 << sprintf("%3.1f",x) << File.open("x#{x}/heating.avg").grep(/^\s*#{t110}\./)[0]
  d100 << sprintf("%3.1f",x) << File.open("x#{x}/heating.avg").grep(/^\s*#{t100}\./)[0]
end
print header
print "##\n"
print d111
print "\n\n"
print d110
print "\n\n"
print d100
