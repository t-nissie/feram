#!/usr/bin/env ruby
# slicer40x40.rb
# Time-stamp: <2008-04-13 10:53:01 t-nissie>
# Author: Takeshi NISHIMATSU
# Usage: ./slicer40x40.rb coord-file l d
##
class EPSF
  X_OFFSET =  50
  Y_OFFSET =  150
  X_WIDTH  =  10
  Y_HEIGHT =  10
  def initialize(coord_file, l, d)
    @l=l
    @d=d
    if coord_file =~ /(cooling)/
      @coolheat=$1
    else
      @coolheat='heating'
    end
    if coord_file =~ /\.([0-9][0-9][0-9])K/
      @temperature=$1
    else
      @temperature=0
    end
    @filename = "#{File.basename(coord_file, ".coord")}-slice.eps"
    @epsf = File.open(@filename,"w")
  end

  def header(l_x,l_y)
    @epsf << "%!PS-Adobe-3.0
%%BoundingBox: #{X_OFFSET} #{Y_OFFSET} #{X_OFFSET+X_WIDTH*l_x} #{Y_OFFSET+Y_HEIGHT*l_y}
%%Creator: slicer.rb by Takeshi NISHIMATSU
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

newpath
  40 110  moveto
 420   0 rlineto
   0 480 rlineto
-420   0 rlineto
closepath
stroke

"
  end

  def print(s)
    @epsf << s
  end

  def footer
    @epsf << "0 0 0 setrgbcolor
/Times-Italic findfont 30 scalefont setfont
179 120 moveto (T) show
/Times-Roman  findfont 30 scalefont setfont
179 120 moveto (   = #{@temperature} K) show
/Times-Italic findfont 30 scalefont setfont
57 558 moveto (l               d) show
/Times-Roman  findfont 30 scalefont setfont
57 558 moveto (   = #{@l},) show
205 558 moveto (= #{@d}) show
275 558 moveto (#{@coolheat}) show
showpage\n"
  end
end

coord_file = ARGV[0]
l = ARGV[1].to_i
d = ARGV[2].to_i

epsf = EPSF.new(coord_file, l , d)

l_x = 0
l_y = 0
up_and_down = ""
File.open(coord_file, "r"){|c|
  c.each do |line|
    x,y,z,q_x,q_y,q_z = line.strip.split
      x = x.to_i
      y = y.to_i
      z = z.to_i
    if z == l/2
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
