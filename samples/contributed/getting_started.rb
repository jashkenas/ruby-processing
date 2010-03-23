# Let's define a setup method, for code that gets
# run one time when the app is started.
def setup
  size 200, 200
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