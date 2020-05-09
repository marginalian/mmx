#!/usr/bin/env ruby

test_files = Dir.glob(File.join("#{__dir__}/../test/", "**", "*.rb"))

test_files.each do |file_path|
  puts "\n-------------------------------------"
  puts file_path.split("..").last
  test_output = `ruby #{file_path}`

  if test_output.lines[-5].squeeze.strip == "."
    puts test_output.lines.last
  else
    puts test_output
  end
end
