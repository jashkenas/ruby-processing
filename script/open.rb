#!/usr/bin/env ruby

# For all you bash-less folks.
# This script lets you open up Ruby-Processing sketches
# without having to install JRuby.

path = ARGV[0]
unless path
  puts "Usage: script/open path/to/my_sketch.rb" 
  exit
end
unless File.exists? path
  puts "Couldn't find: #{path}"
  exit
end

puts `java -cp "script/base_files/jruby-complete.jar" org.jruby.Main #{path}`