#!/usr/bin/env ruby
#
# TODO. I think I want to go back to the non-recursive way I did this before. I
# think it's simpler... if I can get it to work
#
# Also, idea for getting this to work: Have a special value that the INPUT
# opcode checks, and when it gets that value, it breaks WITHOUT changing the @ip so that
# when `run` is called again, it does the input where it left off.
#
# The idea is that we will use the attr_reader to change the inputter before
# running `run` again, and this will effectively allow us to "pause", compute
# the next input, set it, then use it.

require_relative './intcode'

# intcode_program = [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]
# intcode_program = [3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0]
intcode_program = File.read("./day7input.txt").split(",").map(&:to_i)

class Inputter
  def initialize(phase_setting, previous_amp)
    if previous_amp.nil?
      @inputs = [0, phase_setting]
    else
      @inputs = [previous_amp.call, phase_setting]
    end
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
  def initialize(phase_setting, intcode_program, previous_amp)
    phase_setting = phase_setting
    intcode_program = intcode_program
    previous_amp = previous_amp

    inputter = Inputter.new(phase_setting, previous_amp)
    @outputter = Outputter.new
    @intcode = Intcode.new(intcode_program, nil, nil, inputter, @outputter)
  end

  def call
    @intcode.run
    @outputter.value
  end
end

max_output = [0,1,2,3,4].permutation.map { |phase_settings|
  amp_a = Amplifier.new(phase_settings[0], intcode_program.clone, nil)
  amp_b = Amplifier.new(phase_settings[1], intcode_program.clone, amp_a)
  amp_c = Amplifier.new(phase_settings[2], intcode_program.clone, amp_b)
  amp_d = Amplifier.new(phase_settings[3], intcode_program.clone, amp_c)
  amp_e = Amplifier.new(phase_settings[4], intcode_program.clone, amp_d)
  amp_a.inputter = Inputter.new(phase_settings[0], amp_e)
  amp_e.call
}.max

puts max_output
