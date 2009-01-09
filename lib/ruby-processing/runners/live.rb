# An IRB shell for live coding. 
# This flavor will either load up empty Ruby-Processing, 
# or will start with your sketch.

require "#{File.dirname(__FILE__)}/base.rb"

require 'irb'
ARGV[0] = nil # To keep IRB from trying to run it multiple times.
require Processing::SKETCH_PATH
IRB.setup(__FILE__)
IRB.start()