#!/usr/bin/env ruby

require 'rgl/adjacency'
require 'rgl/dot'
require 'rgl/dijkstra'

input = <<~INPUT
COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L
K)YOU
I)SAN
INPUT

input = File.read("./day6input.txt")

orbits = input
  .split("\n")
  .flat_map { |orbit| orbit.split ")" }
objects = orbits.uniq
graph = RGL::AdjacencyGraph[*orbits]
transfers = (graph.dijkstra_shortest_path(Hash.new(1), 'SAN', 'YOU') - ['SAN', 'YOU']).count - 1

puts transfers
