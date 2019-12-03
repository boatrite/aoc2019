#!/usr/bin/env ruby

def calc_fuel(mass)
  (mass / 3) - 2
end

inputs = File.read './day1input.txt'
puts inputs
  .split("\n")
  .map { |line|
    mass = line.to_i
    fuel = calc_fuel(mass)
    fuel_that_needs_fuel = fuel
    until fuel_that_needs_fuel <= 0
      fuel_for_fuel = calc_fuel(fuel_that_needs_fuel)
      break if fuel_for_fuel <= 0
      fuel += fuel_for_fuel
      fuel_that_needs_fuel = fuel_for_fuel
    end
    fuel
  }
  .sum
