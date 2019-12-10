#!/usr/bin/env ruby

require 'colorize'

# input = '0222112222120000'
# width = 2
# height = 2

input = File.read("./day8input.txt").strip
width = 25
height = 6
picture = Array.new(height * width) { 2 }

layers = input.
  chars.
  map(&:to_i).
  each_slice(width * height).
  to_a.
  reverse
decoded = layers.reduce(picture) { |picture, layer|
  layer.each_with_index do |x, i|
    picture[i] = x == 2 ? picture.fetch(i) : x
  end
  picture
}

decoded.each_slice(width).each do |row|
  puts row.map { |pixel|
    case pixel
    when 0, 2
      pixel.to_s.black.on_black
    when 1
      pixel.to_s.white.on_white
    end
  }.join
end
