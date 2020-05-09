#!/usr/bin/env ruby

# Usage:
#
# call this executable file from the root of any
# repo that includes mmx as a git submodule:
#
#   ./mmx/bin/kill_topo.rb
#
# converts all topo files to leaf

require_relative '../lib/mmx'

topo_paths = Dir.glob("wiki/**/*.topo")
topo_paths.each do |path|
  leaf_output = Mmx::Topo.new(path, []).convert(:leaf)
  leaf_path = path.gsub("topo", "leaf")
  File.write(leaf_path, leaf_output)
end
