#!/usr/bin/env ruby

def digits(x)
  x.to_s.split('').map(&:to_i)
end

input = (130254..678275)
constraint1 = input.select { |x|
  d = digits x
  d[0] == d[1] ||
    d[1] == d[2] ||
    d[2] == d[3] ||
    d[3] == d[4] ||
    d[4] == d[5]
}

constraint2 = constraint1.select { |x|
  d = digits x
  d[0] <= d[1] &&
    d[1] <= d[2] &&
    d[2] <= d[3] &&
    d[3] <= d[4] &&
    d[4] <= d[5]
}
puts constraint2.count
