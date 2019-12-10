#!/usr/bin/env ruby

# input = '123456789012'
input = File.read("./day8input.txt").strip
width = 25
height = 6
layers = input.
  chars.
  map(&:to_i).
  each_slice(width * height).
  to_a
require "pry"; binding.pry

count = -> (num, layer) {
  layer.count { |x| x == num }
}
count_zeros = count.curry[0]
count_ones = count.curry[1]
count_twos = count.curry[2]

layer = layers.min_by(&count_zeros)
puts count_ones[layer] * count_twos[layer]
