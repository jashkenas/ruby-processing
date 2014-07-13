#
# Ported from http://processing.org/learning/topics/chain.html
#
# One mass is attached to the mouse position and the other is attached the position of the other mass. 
# The gravity in the environment pulls down on both.
#
load_libraries :control_panel

attr_reader :gravity, :panel

def setup
  size 640, 340  
  fill 0
  
  # Control panel for changing gravity
  control_panel do |c|
    c.slider :gravity, 0..30, 6
    @panel = c
  end
  
  @mass    = 2.0
  @s1      = Spring2d.new(width/2, height/2, @mass, gravity)
  @s2      = Spring2d.new(width/2, height/2, @mass, gravity)
  

end

def draw
  panel.set_visible(true) if self.visible
  background 204
  @s1.update(mouse_x, mouse_y, gravity)
  display(@s1, mouse_x, mouse_y)
  
  @s2.update(@s1.x, @s1.y, gravity)
  display(@s2, @s1.x, @s1.y)
end

def display(spring, nx, ny)
  no_stroke
  ellipse(spring.x, spring.y, spring.diameter, spring.diameter)
  stroke 255
  line(spring.x, spring.y, nx, ny)
end



class Spring2d
  include Processing::Proxy
  
  attr_reader :x, :y, :gravity
  
  def initialize(xpos, ypos, mass, gravity)
    @x         = xpos # The x-coordinate
    @y         = ypos # The y-coordinate
    @gravity   = gravity
    @mass      = mass
    @vx, @vy   = 0, 0 # The x- and y-axis velocities
    @radius    = 20
    @stiffness = 0.2
    @damping   = 0.7
  end
  
  def update(target_x, target_y, gravity)
    force_x = (target_x - self.x) * @stiffness
    ax = force_x / @mass
    @vx = @damping * (@vx + ax)
    @x += @vx
    @gravity = gravity
    force_y = (target_y - self.y) * @stiffness
    force_y += gravity
    ay = force_y / @mass
    @vy = @damping * (@vy + ay)
    @y += @vy
  end
  
  def diameter
    @radius * 2
  end
  
end