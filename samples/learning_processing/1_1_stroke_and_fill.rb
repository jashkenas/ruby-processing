# So, let's get started: The first thing you may notice is
# that there is a bunch more code around the edges here 
# than in the Learning Processing example. Ruby-Processing
# doesn't perform any special munging or pre-processing, 
# so what you see here is *just Ruby* taking advantage
# of the Processing library.

# Hence, this line, which loads in Processing.
require 'ruby-processing'

# Here we begin to define the Sketch by making it a 
# Processing App.
class StrokeAndFill < Processing::App

  # Now we define a setup method, for code that gets
  # run one time when the app is started.
  def setup
    background 255
    stroke 0
    fill 150
    rect 50, 50, 75, 100    
  end
  
  # And the draw method has nothing inside of it.
  # If it did, the code inside would be run repeatedly.
  def draw
  
  end
  
end

# Now that the sketch is defined, we can start one up.
# The following line does this, passing in the title, width, and height.
StrokeAndFill.new :title => "Stroke And Fill", :width => 200, :height => 200