#!/usr/bin/env ruby

# suppress warnings from ruby, especially:
# "Pattern matching is experimental"
$VERBOSE = nil

# Usage:
#
# call this executable file from the root of any
# repo that includes mmx as a git submodule:
#
#   ./mmx/bin/build

require "yaml"
require "ostruct"

require_relative "../lib/mmx"

def fail
  puts "FAILURE"
  exit 0
end

fail unless Dir.exist?("./wiki")
fail unless Mmx::Fret.("./wiki").all?(&:valid)

FileUtils.remove_dir("site") if File.exists?("site")
FileUtils.remove_dir("site-md") if File.exists?("site-md")

config_path = "#{__dir__}/../../config.yml"

if File.exist?(config_path)
  yaml_to_struct = File.method(:read) >> YAML.method(:load) >> OpenStruct.method(:new)
  $config = yaml_to_struct.(config_path)
end

Dir.glob("wiki/*/")
  .map(&Mmx::Project)
  .filter(&:valid?)
  .each(&:convert)

invalid_projects = Dir.glob("wiki/*/")
  .map(&Mmx::Project)
  .reject(&:valid?)

if invalid_projects.length > 0
  puts "\nCould not build these invalid projects:"
  puts invalid_projects.map(&:name).join(", ")
end

puts "\nSUCCESS"
