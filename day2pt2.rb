#!/usr/bin/env ruby

require_relative './intcode'

(0..99).each do |noun|
  (0..99).each do |verb|
    x = Intcode.new(noun, verb).run
    if x == 19690720
      puts "noun: #{noun}, verb: #{verb}, answer: #{100 * noun + verb}"
      exit
    end
  end
end
