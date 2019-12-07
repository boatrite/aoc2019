require_relative "../intcode"

RSpec.describe Intcode do
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
  end
end
