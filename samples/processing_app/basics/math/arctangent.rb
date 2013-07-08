# Move the mouse to change the direction of the eyes. 
# The atan2() function computes the angle from each eye 
# to the cursor. 

def setup
  size 640, 360
  @eyes = [
  Eye.new(420, 230, 220),
  Eye.new(250,  16, 120), 
  Eye.new(164, 185,  80)
  ]
  no_stroke
end

def draw
  background 102
  
  @eyes.each do |eye|
    eye.update mouse_x, mouse_y
    eye.display self
  end
end

class Eye
  def initialize(x, y, sz) # contructor, called by Eye.new
    @x, @y, @size = x, y, sz
  end
  
  def update(mx, my)
    @angle = atan2(my - @y, mx - @x)
  end
  
  def display( context )
    context.push_matrix
    context.translate @x, @y
    context.fill 255
    context.ellipse 0, 0, @size, @size
    context.rotate @angle
    context.fill 153
    context.ellipse @size/4, 0, @size/2, @size/2
    context.pop_matrix
  end
end

