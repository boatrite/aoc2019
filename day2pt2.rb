#!/usr/bin/env ruby

require_relative './intcode'

(0..99).each do |noun|
  (0..99).each do |verb|
    intcode = File.read('./day2input.txt').split(',').map(&:to_i)
    x = Intcode.new(intcode, noun, verb).run.first
    if x == 19690720
      puts "noun: #{noun}, verb: #{verb}, answer: #{100 * noun + verb}"
      exit
    end
  end
end
