#!/usr/bin/env ruby
# histogram.rb
# Time-stamp: <2012-08-11 18:32:14 t-nissie>
# Author: Takeshi Nishimatsu
##
require "optparse"

# defaults
histogram_begin =  0.0
histogram_end   = 10.0
histogram_step  =  1.0
column = 1

opts = OptionParser.new
opts.program_name = $0
opts.on("-b BEGIN_OF_HISTOGRAM", "--begin BEGIN_OF_HISTOGRAM",
        "Minimum begin value of histogram."){|v| histogram_begin = v.to_f}
opts.on("-e END_OF_HISTOGRAM", "--end END_OF_HISTOGRAM",
        "Maximum end value of histogram."){|v| histogram_end = v.to_f}
opts.on("-s STEP_OF_HISTOGRAM", "--step STEP_OF_HISTOGRAM",
        "Step value of histogram."){|v| histogram_step = v.to_f}
opts.on("-c COLUMN_NUMBER","--column COLUMN_NUMBER", "column number for histogram"){|v| column=v.to_i}
opts.on_tail("-h", "--help", "Show this message."){puts opts.to_s.sub(/options/,'options] [filename'); exit}
opts.parse!(ARGV)

histogram = Array.new(((histogram_end-histogram_begin)/histogram_step).ceil,0)

ARGF.each do |line|
  cols = line.strip.split
  k = ((cols[column-1].to_f-histogram_begin)/histogram_step).round
  if 0<=k and k<histogram.size
    histogram[k] += 1
  end
end

histogram.each_with_index do |h,i|
  printf("%16.7f%10d\n", histogram_begin+histogram_step*i, h)
end
