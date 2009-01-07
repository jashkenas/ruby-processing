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
class SampleApplication < Processing::App

  # Now we define a setup method, for code that gets
  # run one time when the app is started.
  def setup
    background 0
    no_stroke
    smooth
    @rotation = 0
  end
  
  # And the draw method which will be called repeatedly.
  # Delete this if you don't need animation.
  def draw
    fill 0, 20
    rect 0, 0, width, height
    
    translate width/2, height/2
    rotate @rotation

    fill 255
    ellipse 0, -60, 20, 20

    @rotation += 0.1
  end
  
end

# Now that the sketch is defined, we can start one up.
# The following line does this, passing in the title, width, and height.
SampleApplication.new(:width => 200, :height => 200, :title => "SampleApplication")