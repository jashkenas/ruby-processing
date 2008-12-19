# An IRB shell for live coding. 
# This flavor will either load up empty Ruby-Processing, 
# or will start with your sketch.

require 'irb'
sketch = ARGV[0] || 'ruby-processing.rb'
SKETCH_PATH = File.dirname(sketch) unless defined?(SKETCH_PATH)
ARGV[0] = nil # To keep IRB from trying to run it multiple times.
require sketch
IRB.setup(__FILE__)
IRB.start()
