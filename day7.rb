#!/usr/bin/env ruby

require_relative './intcode'

# intcode_program = [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]
# intcode_program = [3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0]
intcode_program = File.read("./day7input.txt").split(",").map(&:to_i)

class Inputter
  def initialize(phase_setting, input_signal)
    @inputs = [input_signal, phase_setting].map { |x| "#{x}\n" }
  end

  def gets
    x = @inputs.pop
    raise "Nothing to pop" if x.nil?
    x
  end
end

Outputter = Struct.new(:value) do
  def puts(x)
    self.value = x
  end
end

class Amplifier
  def self.call(phase_setting, input_signal, intcode_program)
    inputter = Inputter.new(phase_setting, input_signal)
    outputter = Outputter.new
    intcode = Intcode.new(intcode_program, nil, nil, inputter, outputter)
    intcode.run
    outputter.value
  end
end

max_output = [0,1,2,3,4].permutation.map { |phase_settings|
  signal = 0
  signal = Amplifier.call phase_settings[0], signal, intcode_program.clone
  signal = Amplifier.call phase_settings[1], signal, intcode_program.clone
  signal = Amplifier.call phase_settings[2], signal, intcode_program.clone
  signal = Amplifier.call phase_settings[3], signal, intcode_program.clone
  signal = Amplifier.call phase_settings[4], signal, intcode_program.clone
}.max

puts max_output
