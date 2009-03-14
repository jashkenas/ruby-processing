# An IRB shell for live coding. 
# This flavor will either load up empty Ruby-Processing, 
# or will start with your sketch.

require "#{File.dirname(__FILE__)}/base.rb"

require 'irb'
ARGV[0] = nil # To keep IRB from trying to run it multiple times.
IRB.setup(__FILE__)
Processing.load_and_run_sketch
IRB.start()
