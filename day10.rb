#!/usr/bin/env ruby

require 'json'
require 'colorize'

map = <<~MAP
#.........
...A......
...B..a...
.EDCG....a
..F.c.b...
.....c....
..efd.c.gb
.......c..
....f...c.
...e..d..c
MAP

map = <<~MAP
.#..#
.....
#####
....#
...##
MAP

grid = map.split("\n").map { |row| row.split("") }

def display(grid)
  system "clear"
  puts grid.map { |row| row.join(" ") }.join("\n")
end

lines_of_sight = [
  { dr: 0, dc: 1 },
  { dr: 1, dc: 0 },
  { dr: 1, dc: 1 },
  { dr: 1, dc: 2 },
  { dr: 1, dc: 3 },
  { dr: 2, dc: 1 },
  { dr: 2, dc: 2 },
  { dr: 2, dc: 3 },
  { dr: 3, dc: 1 },
  { dr: 3, dc: 2 },
  { dr: 3, dc: 3 },
  { dr: 3, dc: 4 },
]

def apply_los(los, grid, r, c)
  max_cols = grid.count - 1
  max_rows = grid.first.count - 1

  grid = JSON.parse(grid.to_json)
  grid[r][c] = grid[r][c].blue

  loop do
    r += los[:dr]
    c += los[:dc]
    break if r > max_rows || c > max_cols
    grid[r][c] = grid[r][c].red
  end

  grid
end

ASTEROID = '#'

def asteroid_positions(grid)
  grid.flat_map.with_index do |row, r|
    row.map.with_index do |cell, c|
      { r: r, c: c } if cell == ASTEROID
    end.compact
  end.compact
end

def count(lines_of_sight, start_grid)
  max_cols = start_grid.count - 1
  max_rows = start_grid.first.count - 1
  display start_grid

  counts = { }

  asteroid_positions(start_grid).each do |asteroid_pos|
    counts[asteroid_pos] = 0
    lines_of_sight.each do |los|
      [-1, 1].each do |r_mod|
        [-1, 1].each do |c_mod|
          grid = JSON.parse(start_grid.to_json)
          r = asteroid_pos[:r]
          c = asteroid_pos[:c]
          prev_start = grid[r][c]
          grid[r][c] = grid[r][c].blue
          loop do
            r += los[:dr] * r_mod
            c += los[:dc] * c_mod
            break if r > max_rows || c > max_cols || r < 0 || c < 0
            if grid[r][c] == ASTEROID
              grid[r][c] = grid[r][c].red
              display grid
              puts "Found, Total: #{counts[asteroid_pos]}"
              counts[asteroid_pos] += 1
              grid[r][c] = ASTEROID
              break
            else
              old = grid[r][c]
              grid[r][c] = grid[r][c].red
              display grid
              puts "Nothing"
              grid[r][c] = old
            end
            sleep 1
          end
        end
      end
    end
  end
end

puts count(lines_of_sight, grid)
