# Here we introduce a slightly more sophisticated version of a Ruby-Processing
# sketch. The code inside of the setup is run a single time, at the beginning.
def setup
  size 200, 200
  smooth
  background 255
  # In Ruby, methods and variables are under_scored instead of camelCased
  no_fill
  stroke 0
  # You might notice that there are no parenthesis or semicolons.
  # That's because they're optional.
  ellipse 60, 60, 100, 100
  # This line works too:
  ellipse(60, 60, 100, 100);
end

# And the code inside of draw, if there were any, would be drawn over and over.
def draw
  
end