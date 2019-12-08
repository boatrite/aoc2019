require_relative "../intcode"

RSpec.describe Intcode do
  let(:inputter_class) {
    Struct.new(:value) do
      def gets
        value
      end
    end
  }

  let(:outputter_class) {
    Struct.new(:value) do
      def puts(x)
        self.value = x
      end
    end
  }

  it 'inputter' do
    inputter = inputter_class.new '3'
    expect(inputter.gets).to eq '3'
  end

  it 'outputter' do
    outputter = outputter_class.new
    outputter.puts '3'
    expect(outputter.value).to eq '3'
  end

  describe '#run' do
    it 'works for day 2 examples' do
      expect(Intcode.new([1,9,10,3,2,3,11,0,99,30,40,50]).run)
        .to eq [3500,9,10,70,2,3,11,0,99,30,40,50]

      expect(Intcode.new([1,0,0,0,99]).run)
        .to eq [2,0,0,0,99]

      expect(Intcode.new([2,3,0,3,99]).run)
        .to eq [2,3,0,6,99]

      expect(Intcode.new([2,4,4,5,99,0]).run)
        .to eq [2,4,4,5,99,9801]

      expect(Intcode.new([1,1,1,4,99,5,6,0,99]).run)
        .to eq [30,1,1,4,2,5,6,0,99]

      expect(Intcode.new(File.read("day2input.txt").split(",").map(&:to_i), 12, 2).run.first)
        .to eq 4570637
    end

    it 'day2pt2 executes correctly' do
      output = `./day2pt2.rb`
      expect(output).to eq "noun: 54, verb: 85, answer: 5485\n"
    end

    it 'input & output opcodes' do
      inputter = inputter_class.new "1234\n"
      outputter = outputter_class.new
      Intcode.new([3,0,4,0,99], nil, nil, inputter, outputter).run
      expect(outputter.value).to eq 1234
    end

    it 'works for day 5 examples' do
      expect(Intcode.new([1002,4,3,4,33]).run)
        .to eq [1002,4,3,4,99]
    end

    it 'day5 executes correctly' do
      output = `./day5.rb`
      expect(output).to eq <<~OUTPUT
        0
        0
        0
        0
        0
        0
        0
        0
        0
        13346482
      OUTPUT
    end

    context 'EQUALS opcode' do
      it 'position mode works' do
        inputter = inputter_class.new "8\n"
        outputter = outputter_class.new
        Intcode.new([3,9,8,9,10,9,4,9,99,-1,8], nil, nil, inputter, outputter).run
        expect(outputter.value).to eq 1

        inputter = inputter_class.new "7\n"
        outputter = outputter_class.new
        Intcode.new([3,9,8,9,10,9,4,9,99,-1,8], nil, nil, inputter, outputter).run
        expect(outputter.value).to eq 0
      end

      it 'immediate mode works' do
        inputter = inputter_class.new "8\n"
        outputter = outputter_class.new
        Intcode.new([3,3,1108,-1,8,3,4,3,99], nil, nil, inputter, outputter).run
        expect(outputter.value).to eq 1

        inputter = inputter_class.new "7\n"
        outputter = outputter_class.new
        Intcode.new([3,3,1108,-1,8,3,4,3,99], nil, nil, inputter, outputter).run
        expect(outputter.value).to eq 0
      end
    end

    context 'LESS_THAN opcode' do
      it 'position mode works' do
        inputter = inputter_class.new "8\n"
        outputter = outputter_class.new
        Intcode.new([3,9,7,9,10,9,4,9,99,-1,8], nil, nil, inputter, outputter).run
        expect(outputter.value).to eq 0

        inputter = inputter_class.new "7\n"
        outputter = outputter_class.new
        Intcode.new([3,9,7,9,10,9,4,9,99,-1,8], nil, nil, inputter, outputter).run
        expect(outputter.value).to eq 1
      end

      it 'immediate mode works' do
        inputter = inputter_class.new "8\n"
        outputter = outputter_class.new
        Intcode.new([3,3,1107,-1,8,3,4,3,99], nil, nil, inputter, outputter).run
        expect(outputter.value).to eq 0

        inputter = inputter_class.new "7\n"
        outputter = outputter_class.new
        Intcode.new([3,3,1107,-1,8,3,4,3,99], nil, nil, inputter, outputter).run
        expect(outputter.value).to eq 1
      end
    end
  end
end
