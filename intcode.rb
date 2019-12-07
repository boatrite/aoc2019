class Intcode
  module Opcode
    ADD = 1
    MULT = 2
    INPUT = 3
    OUTPUT = 4
    HALT = 99
  end

  def initialize(intcode, noun = nil, verb = nil)
    @intcode = intcode
    @intcode[1] = noun if noun
    @intcode[2] = verb if verb
    @ip = 0
  end

  def run
    while @intcode[@ip] != Opcode::HALT
      current_opcode = @intcode[@ip]
      move_count = execute(current_opcode)
      @ip += move_count
    end
    @intcode
  end

  def execute(opcode)
    case opcode
    when Opcode::ADD
      param1_address = @intcode.fetch(@ip + 1)
      param2_address = @intcode.fetch(@ip + 2)
      dest_address = @intcode.fetch(@ip + 3)
      @intcode[dest_address] =
        @intcode.fetch(param1_address) + @intcode.fetch(param2_address)
      4
    when Opcode::MULT
      param1_address = @intcode.fetch(@ip + 1)
      param2_address = @intcode.fetch(@ip + 2)
      dest_address = @intcode.fetch(@ip + 3)
      @intcode[dest_address] =
        @intcode.fetch(param1_address) * @intcode.fetch(param2_address)
      4
    when Opcode::INPUT
      value = gets.chomp.to_i
      dest_address = @intcode.fetch(@ip + 1)
      @intcode[dest_address] = value
      2
    when Opcode::OUTPUT
      output_address = @intcode.fetch(@ip + 1)
      output_value = @intcode.fetch(output_address)
      puts output_value
      2
    when Opcode::HALT
      0
    end
  end
end
