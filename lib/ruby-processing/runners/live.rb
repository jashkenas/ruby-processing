# An IRB shell for live coding. 
# This flavor will either load up empty Ruby-Processing, 
# or will start with your sketch.

root = File.dirname(__FILE__)
require "#{root}/base.rb"
Processing.load_and_run_sketch

ARGV.clear # So that IRB doesn't try to load them as files.

require 'irb'
IRB.setup(__FILE__)
IRB.start
