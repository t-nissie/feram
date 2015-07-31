#!/usr/bin/env ruby
# feram_slicer.rb
# Time-stamp: <2015-04-23 14:45:18 takeshi>
# Author: Takeshi NISHIMATSU
# Usage: ./feram_slicer.rb coord-file [const_z]
##
class EPSF
  X_OFFSET =  50
  Y_OFFSET =  50
  X_WIDTH  =  10
  Y_HEIGHT =  10
  def initialize(coord_file, const_z)
    @filename = "#{File.basename(coord_file, ".coord")}-slice-z#{sprintf("%.3i",const_z)}.eps"
    @epsf = File.open(@filename,"w")
  end

  def header(l_x,l_y)
    @epsf << "%!PS-Adobe-3.0
%%BoundingBox: #{X_OFFSET} #{Y_OFFSET} #{X_OFFSET+X_WIDTH*l_x} #{Y_OFFSET+Y_HEIGHT*l_y}
%%Creator: feram_slicer.rb by Takeshi NISHIMATSU
%%Orientation: Portrait
%%Title: slice.eps
%%EndComments
/x_offset  #{X_OFFSET} def
/y_offset  #{Y_OFFSET} def
/x_width    #{X_WIDTH} def
/y_height   #{Y_HEIGHT} def
/LineWidth   1 def
/LineWidth20 LineWidth 2.0 mul def
/LineWidth15 LineWidth 1.5 mul def
/LineWidth05 LineWidth 0.5 mul def

/Up {
 newpath
  exch
  x_width  mul x_offset add
  exch
  y_height mul y_offset add
  moveto
  LineWidth dup rmoveto
  x_width LineWidth20 sub     0 rlineto
  0    y_height LineWidth20 sub rlineto
  x_width LineWidth20 sub neg 0 rlineto
 closepath
 1 0 0 setrgbcolor
 LineWidth setlinewidth
 stroke
} def

/Down {
 newpath
  exch
  x_width  mul x_offset add
  exch
  y_height mul y_offset add
  moveto
  LineWidth05 dup rmoveto
  x_width LineWidth sub     0 rlineto
  0    y_height LineWidth sub rlineto
  x_width LineWidth sub neg 0 rlineto
  closepath
  0 0 1 setrgbcolor fill
} def
"
  end

  def print(s)
    @epsf << s
  end

  def footer
    @epsf << "showpage\n"
  end
end

coord_file = ARGV[0]
if ARGV[1]
  const_z = ARGV[1].to_i
else
  const_z = 6
end

epsf = EPSF.new(coord_file, const_z)

l_x = 0
l_y = 0
up_and_down = ""
File.open(coord_file, "r"){|c|
  c.each do |line|
    x,y,z,q_x,q_y,q_z = line.strip.split
      x = x.to_i
      y = y.to_i
      z = z.to_i
    if z == const_z
      l_x = x if x > l_x
      l_y = y if y > l_y
      if q_z.to_f>0.0
        up_and_down << "#{x} #{y} Up\n"
      else
        up_and_down << "#{x} #{y} Down\n"
      end
    end
  end
}
l_x+=1
l_y+=1

epsf.header(l_x,l_y)
epsf.print(up_and_down)
epsf.footer
