#!/usr/bin/env ruby

require_relative './intcode'

intcode = File.read('./day2input.txt').split(',').map(&:to_i)
noun = 12
verb = 2
puts Intcode.new(intcode, noun, verb).run.first
