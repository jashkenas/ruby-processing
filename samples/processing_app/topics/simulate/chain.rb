require 'ruby-processing'

#
# Ported from http://processing.org/learning/topics/chain.html
#
# One mass is attached to the mouse position and the other is attached the position of the other mass. 
# The gravity in the environment pulls down on both.
#
class Chain < Processing::App
  
  attr_reader :gravity
  
  load_library :control_panel

  def setup
    smooth
    fill 0
    
    # Inputs: spring1, spring2, mass, gravity
    @gravity = 6.0
    @mass    = 2.0
    @s1      = Spring2d.new(width/2, height/2, @mass)
    @s2      = Spring2d.new(width/2, height/2, @mass)
    
    # Control panel for changing gravity
    control_panel do |c|
      c.slider :gravity, 0..30
    end
  end
  
  def draw
    background 204
    @s1.update(mouse_x, mouse_y)
    display(@s1, mouse_x, mouse_y)

    @s2.update(@s1.x, @s1.y)
    display(@s2, @s1.x, @s1.y)
  end
  
  def display(spring, nx, ny)
    no_stroke
    ellipse(spring.x, spring.y, spring.diameter, spring.diameter)
    stroke 255
    line(spring.x, spring.y, nx, ny)
  end

end

class Spring2d
  
  attr_reader :x, :y
  
  def initialize(xpos, ypos, mass)
    @x         = xpos # The x-coordinate
    @y         = ypos # The y-coordinate
    @mass      = mass
    @vx, @vy   = 0, 0 # The x- and y-axis velocities
    @radius    = 20
    @stiffness = 0.2
    @damping   = 0.7
  end

  def update(target_x, target_y)
    force_x = (target_x - self.x) * @stiffness
    ax = force_x / @mass
    @vx = @damping * (@vx + ax)
    @x += @vx
    
    force_y = (target_y - self.y) * @stiffness
    force_y += $app.gravity
    ay = force_y / @mass
    @vy = @damping * (@vy + ay)
    @y += @vy
  end
  
  def diameter
    @radius * 2
  end
  
end

Chain.new(:width => 200, :height => 200, :title => "Chain", :full_screen => false)