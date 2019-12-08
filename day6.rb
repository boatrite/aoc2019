#!/usr/bin/env ruby

require 'rgl/adjacency'
require 'rgl/dot'
require 'rgl/traversal'

# input = <<~INPUT
# COM)B
# B)C
# C)D
# D)E
# E)F
# B)G
# G)H
# D)I
# E)J
# J)K
# K)L
# INPUT

input = File.read("./day6input.txt")

orbits = input
  .split("\n")
  .flat_map { |orbit| orbit.split ")" }
objects = orbits.uniq
graph = RGL::DirectedAdjacencyGraph[*orbits]
checksum = graph
  .vertices
  .reduce(0) { |acc, vertex|
    acc += graph.bfs_search_tree_from(vertex).edges.count
  }

puts checksum
