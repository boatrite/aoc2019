#!/usr/bin/env ruby

inputs = File.read './day1input.txt'
puts inputs
  .split("\n")
  .map { |line| (line.to_i / 3) - 2 }
  .sum
