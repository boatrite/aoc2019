require 'io/console'

class Intcode
  module Opcode
    ADD = 1
    MULT = 2
    INPUT = 3
    OUTPUT = 4
    HALT = 99
  end

  module ParamMode
    POSITION = 0
    IMMEDIATE = 1
  end

  def initialize(intcode, noun = nil, verb = nil, inputter = STDIN, outputter = STDOUT)
    @intcode = intcode
    @intcode[1] = noun if noun
    @intcode[2] = verb if verb
    @ip = 0
    @inputter = inputter
    @outputter = outputter

    @history = [intcode.clone]
    @step = 0
  end

  def run
    while @intcode[@ip] != Opcode::HALT
      current_instruction = @intcode[@ip]
      move_count = execute(current_instruction)
      @ip += move_count

      @step += 1
      @history[@step] = @intcode.clone
    end
    @intcode
  end

  def param_value(index, param_mode)
    case param_mode
    when ParamMode::POSITION
      param_address = @intcode.fetch index
      @intcode.fetch param_address
    when ParamMode::IMMEDIATE
      @intcode.fetch index
    else
      raise "Invalid param mode"
    end
  end

  def print_intcode(intcode)
    intcode.each_slice(30).map { |arr|
      arr.join(", ")
    }.join("\n")
  end

  def debug
    i = -1
    loop do
      command = STDIN.getch
      case command
      when 'q'
        break
      when 'a'
        i -= 1
        i = 0 if i < 0
      when 'd'
        i += 1
        i = @history.length - 1 if i > @history.length - 1
      end

      system 'clear'
      puts "i: #{i}"
      puts print_intcode @history[i]
    end
  end

  def execute(instruction)
    instruction = instruction.to_s.rjust(5, '0')
    opcode = instruction[3..4].to_i
    param_modes = instruction[0..2].split('').map(&:to_i)
    case opcode
    when Opcode::ADD
      param1_value = param_value(@ip + 1, param_modes.fetch(-1))
      param2_value = param_value(@ip + 2, param_modes.fetch(-2))
      dest_address = @intcode.fetch(@ip + 3)
      @intcode[dest_address] = param1_value + param2_value
      4
    when Opcode::MULT
      param1_value = param_value(@ip + 1, param_modes.fetch(-1))
      param2_value = param_value(@ip + 2, param_modes.fetch(-2))
      dest_address = @intcode.fetch(@ip + 3)
      @intcode[dest_address] = param1_value * param2_value
      4
    when Opcode::INPUT
      value = @inputter.gets.chomp.to_i
      dest_address = @intcode.fetch(@ip + 1)
      @intcode[dest_address] = value
      2
    when Opcode::OUTPUT
      output_address = @intcode.fetch(@ip + 1)
      output_value = @intcode.fetch(output_address)
      @outputter.puts output_value
      2
    when Opcode::HALT
      0
    else
      raise "Invalid opcode"
    end
  end
end
