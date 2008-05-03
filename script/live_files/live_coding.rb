# An IRB shell for live coding. 
# This flavor comes loaded with your sketch.

require 'irb'
require ARGV[0]
ARGV[0] = nil
APP = Processing::App.current
IRB.start
