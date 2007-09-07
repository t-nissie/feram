#!/usr/bin/env ruby
# Time-stamp: <2005-09-16 12:34:09 t-nissie>
# Author: Takeshi NISHIMATSU
##
find_out=`find . -name feram.out`

find_out.each do |filename|
  temperature = filename.chomp.sub(/\.\//,"").sub(/K\/.*$/,"")
  tail_out=`tail #{filename}`
  tail_out.each do |line|
    if line =~ /avg%strain\s+([.\-\+\w]+)\s+([.\-\+\w]+)\s+([.\-\+\w]+)\s+([.\-\+\w]+)\s+([.\-\+\w]+)\s+([.\-\+\w]+)/
      eta123 = [$1.to_f, $2.to_f, $3.to_f].sort
      eta456 = [$4.to_f, $5.to_f, $6.to_f].sort
      print "#{temperature} #{eta123[0]} #{eta123[1]} #{eta123[2]} #{eta456[0]} #{eta456[1]} #{eta456[2]}\n"
    end
  end
end
