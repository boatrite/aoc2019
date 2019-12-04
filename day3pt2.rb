#!/usr/bin/env ruby
require 'colorize'
require 'io/console'
require 'json'

# first_wire_input = 'R8,U5,L5,D3'
# second_wire_input = 'U7,R6,D4,L4'

first_wire_input, second_wire_input = File.read('./day3input.txt').split("\n")

# first_wire_input = 'R75,D30,R83,U83,L12,D49,R71,U7,L72'
# second_wire_input = 'U62,R66,U55,R34,D71,R55,D58,R83'

def expand(wire_input)
  wire_input
    .split(",")
    .flat_map { |command|
      direction = command[0]
      count = command[1..-1].to_i
      [direction] * count
    }
end

first_wire_expansion = expand first_wire_input
second_wire_expansion = expand second_wire_input

def transform_to_coordinates(wire_expansion)
  scan_acc = { x: 0, y: 0 }
  wire_expansion.map { |direction|
    case direction
    when 'R'
      scan_acc[:x] += 1
    when 'L'
      scan_acc[:x] -= 1
    when 'U'
      scan_acc[:y] -= 1
    when 'D'
      scan_acc[:y] += 1
    end
    scan_acc.clone
  }
end

first_wire_coords = transform_to_coordinates(first_wire_expansion)
second_wire_coords = transform_to_coordinates(second_wire_expansion)

def grid_display(grid)
  grid.map { |row|
    row.join('')
  }.join("\n")
end

def print(coords1, coords2)
  max_x = (coords1 + coords2).map { |h| h[:x] }.max
  min_x = (coords1 + coords2).map { |h| h[:x] }.min
  max_y = (coords1 + coords2).map { |h| h[:y] }.max
  min_y = (coords1 + coords2).map { |h| h[:y] }.min

  grid_width = 51
  grid_height = 51
  grid_row = Array.new(grid_width, '.')
  default_grid = []
  grid_height.times do |i|
    default_grid[i] = grid_row.clone
  end

  center_x = grid_width / 2
  center_y = grid_height / 2
  default_grid[center_y][center_x] = 'o'

  grids = [default_grid.clone]
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
      i = grids.length - 1 if i > grids.length - 1
    when 'r'
      i += 1
      if i > [coords1.length, coords2.length].min - 1
        break
      end
      grids[i] = JSON.parse(grids[i - 1].to_json)
      ones_coord = coords1[i]
      twos_coord = coords2[i]
      one_y = center_y + ones_coord[:y]
      one_x = center_x + ones_coord[:x]
      two_y = center_y + twos_coord[:y]
      two_x = center_x + twos_coord[:x]
      # This isn't quite right.
      # Intersections can happen even if they don't happen at the same time
      if one_y == two_y && one_x == two_x
        grids[i][one_y][one_x] = 'X'.colorize(:green)
      else
        grids[i][one_y][one_x] = '*'.colorize(:red)
        grids[i][two_y][two_x] = '*'.colorize(:blue)
      end
    end

    system 'clear'
    puts "i: #{i}"
    puts grid_display grids[i]
  end
end
# print first_wire_coords, second_wire_coords

intersections = first_wire_coords & second_wire_coords
steps = intersections.map { |intersection|
  {
    intersection: intersection,
    first_wire_steps: first_wire_coords.index(intersection) + 1,
    second_wire_steps: second_wire_coords.index(intersection) + 1,
  }
}

puts steps.map { |step|
  step[:first_wire_steps] + step[:second_wire_steps]
}.min
