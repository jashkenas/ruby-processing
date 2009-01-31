require 'ruby-processing'
require 'pp'

#
# Ported from http://processing.org/learning/topics/chain.html
#
# One mass is attached to the mouse position and the other is attached the position of the other mass. 
# The gravity in the environment pulls down on both.
#
class Chain < Processing::App

  def setup
    smooth
    fill(0)
    
    # Inputs: spring1, spring2, mass, gravity
    @gravity = 6.0
    @mass    = 2.0
    @s1      = Spring2d.new(self, 0.0, width/2, @mass, @gravity)
    @s2      = Spring2d.new(self, 0.0, width/2, @mass, @gravity)
  end
  
  def draw
    background(204)
    @s1.update(mouse_x, mouse_y)
    @s1.display(mouse_x, mouse_y)
    @s2.update(@s1.x, @s1.y)
    @s2.display(@s1.x, @s1.y)
  end

end

class Spring2d
  
  attr_accessor :x, :y
  
  def initialize(app, xpos, ypos, m, g)
    @app       = app
    self.x         = xpos # The x-coordinate
    self.y         = ypos # The y-coordinate
    @mass      = m
    @gravity   = g
    @vx, @vy   = 0, 0 # The x- and y-axis velocities
    @radius    = 20
    @stiffness = 0.2
    @damping   = 0.7
  end

  def update(target_x, target_y)
    force_x = (target_x - self.x) * @stiffness
    ax = force_x / @mass
    @vx = @damping * (@vx + ax)
    self.x += @vx
    
    force_y = (target_y - self.y) * @stiffness
    force_y += @gravity
    ay = force_y / @mass
    @vy = @damping * (@vy + ay)
    self.y += @vy
  end
  
  def display(nx, ny)
    @app.no_stroke
    @app.ellipse(self.x, self.y, @radius*2, @radius*2)
    @app.stroke(255)
    @app.line(self.x, self.y, nx, ny)
  end
end

Chain.new(:width => 200, :height => 200, :title => "Chain", :full_screen => false)