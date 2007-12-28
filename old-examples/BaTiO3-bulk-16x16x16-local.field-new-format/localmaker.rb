#!/usr/bin/env ruby
(0...16).each do |iz|
  (0...16).each do |iy|
    (0...16).each do |ix|
      printf("%3i%3i%3i   0.000  0.000  0.005\n", ix, iy, iz)
    end
  end
end
