#!/usr/bin/env ruby

require_relative './intcode'

noun = 12
verb = 2
puts Intcode.new(noun, verb).run
