# An IRB shell for live coding. 
# This flavor will either load up empty Ruby-Processing, 
# or will start with your sketch.

require 'irb'
sketch = ARGV[0] || 'ruby-processing'
ARGV[0] = nil
require sketch
@app = Processing::App.current
IRB.setup(__FILE__)
IRB.start()
