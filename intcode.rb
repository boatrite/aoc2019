class Intcode
  module Opcode
    ADD = 1
    MULT = 2
    HALT = 99
  end

  def initialize(noun, verb)
    @intcode = File.read('./day2input.txt').split(',').map(&:to_i)
    @intcode[1] = noun
    @intcode[2] = verb
    @ip = 0
  end

  def run
    while @intcode[@ip] != Opcode::HALT
      current_opcode = @intcode[@ip]
      execute(current_opcode)
      @ip += 4
    end

    @intcode.first
  end

  def execute(opcode)
    case opcode
    when Opcode::ADD
      @intcode[@intcode.fetch(@ip + 3)] =
        @intcode.fetch(@intcode.fetch(@ip + 1)) + @intcode.fetch(@intcode.fetch(@ip + 2))
    when Opcode::MULT
      @intcode[@intcode.fetch(@ip + 3)] =
        @intcode.fetch(@intcode.fetch(@ip + 1)) * @intcode.fetch(@intcode.fetch(@ip + 2))
    end
  end
end
