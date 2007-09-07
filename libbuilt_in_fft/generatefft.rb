#!/usr/bin/env ruby
# generatefft.rb
# Fortran FFT source code generator
# Time-stamp: <2007-06-05 17:10:52 t-nissie>
# Author: Takeshi NISHIMATSU
# Reference1: Haruhiko Okumura: C-gengo niyoru saishin algorithm jiten
#             (New Algorithm handbook in C language) (Gijyutsu hyouron
#             sha, Tokyo, 1991) [in Japanese]
# Reference2: Akira Nukada: FFTSS
#             http://ssi.is.s.u-tokyo.ac.jp/fftss/index.html.en
#             http://ssi.is.s.u-tokyo.ac.jp/CREST_2nd_symposium/FFTSS.pdf
#
##
require 'complex'
PI       = 3.14159265358979323846
SQRT_1_2 = 0.70710678118654752440

def Array.new_bit_reverse(n)
  # Example (n=8) i : 0 1 2 3 4 5 6 7
  #   bit_reverse[i]: 0 4 2 6 1 5 3 7
  bit_reverse = Array.new(n)
  n2 = n / 2
  i = 0
  j = 0
  while true do
    bit_reverse[i] = j
    i += 1
    break if i==n
    k = n2
    while k<=j do
      j -= k
      k = k / 2
    end
    j = j + k
  end
  return bit_reverse
end

def Array.new_cos_sin_table(n)
  cos_sin_table = Array.new(n)
  n2 = n / 2
  n4 = n / 4
  n8 = n / 8
  t = Math::sin( PI / n )
  dc = 2 * t * t
  ds = Math::sqrt( dc * (2.0 - dc) )
  t = 2 * dc
  cos_sin_table[n4] = Complex(0.0, 1.0)
  cos_sin_table[0]  = Complex(1.0, 0.0)
  c = 1.0
  s = 0.0
  (1...n8).each{|i|
    c = c - dc
    dc = dc + t*c
    s = s + ds
    ds = ds - t*s
    cos_sin_table[i]    = Complex(c,s)
    cos_sin_table[n4-i] = Complex(s,c)
  }
  cos_sin_table[n8] = Complex(SQRT_1_2,SQRT_1_2) if n8 != 0
  (0...n4).each {|i| cos_sin_table[n2-i] = - cos_sin_table[i].conjugate}
  (0...n2).each {|i| cos_sin_table[i+n2] = - cos_sin_table[i]}
  return cos_sin_table
end

class Complex
  def to_fortran
    "(#{real}d0,#{image}d0)"
  end
end


def fft_generator(n,mode) # mode = fwd, inv
  bit_reverse = Array.new_bit_reverse(n)
  cos_sin_table = Array.new_cos_sin_table(n)

  subroutine = "fft1d_#{mode}_"+sprintf("%4.4i",n)
  filename = subroutine + ".f"
  File.open(filename,"w"){|f|
    f.print "subroutine #{subroutine}(c,increment)
  implicit none
  complex*16, intent(inout) :: c(0:*)
  integer,    intent(in)    :: increment
  complex*16  tmp\n"

    (0...n).each do |i|
      j = bit_reverse[i]
      if i<j then
        f.print "  tmp = c(#{i}*increment)\n"
        f.print "  c(#{i}*increment) = c(#{j}*increment)\n"
        f.print "  c(#{j}*increment) = tmp\n"
      end
    end

    k = 1
    while k < n
      h = 0
      k2 = k + k
      d = n / k2
      (0...k).each do |j|
        omega = cos_sin_table[h]
        omega = omega.conjugate if mode == "fwd"
        i=j
        while i<n
          ik = i + k
          f.print "  tmp = #{omega.to_fortran} * c(#{ik}*increment)\n"
          f.print "  c(#{ik}*increment) = c(#{i}*increment) - tmp\n"
          f.print "  c(#{i }*increment) = c(#{i}*increment) + tmp\n"
          i += k2
        end
        h = h + d
      end
      k = k2
    end
    f.print "end subroutine #{subroutine}\n"
  }
end

n = ARGV[0].to_i
unless [2,4,8,16,32,64,128,256,512,1024].include?(n)
  raise("n, the first command-line argument, must be one of 2,4,8,16,32,64,128,256,512,1024.")
end

mode = ARGV[1] || mode = "fwd"
unless ["fwd", "inv"].include?(mode)
  raise('mode, the second command-line argument, must "fwd" or "inv".')
end

fft_generator(n,mode)

=begin

  end subroutine fft1d
=end
