#!/usr/bin/env ruby

require_relative './intcode'


Inputter = Struct.new(:value) do
  def gets
    value
  end
end

intcode = File.read("day5input.txt").split(",").map(&:to_i)
inputter = Inputter.new("1\n")
Intcode.new(intcode, nil, nil, inputter).run
