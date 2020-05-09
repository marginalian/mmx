#!/usr/bin/env ruby

# suppress warnings from ruby, especially:
# "Pattern matching is experimental"
$VERBOSE = nil

# Usage:
#
# call this executable file from the root of any
# repo that includes mmx as a git submodule:
#
#   ./mmx/bin/fret

require_relative '../lib/mmx'

def fail
  puts "\nFAILURE"
  exit 0
end

fail unless Dir.exist?('./wiki')
fail unless Mmx::Fret.('./wiki').all?(&:valid)

puts "\nSUCCESS"
