#
# Bouncy Bubbles  
# based on code from Keith Peters. 
# 
# Multiple-object collision.
#

SPRING = 0.05
GRAVITY = 0.03
FRICTION = -0.9
NUM_BALLS = 12

attr_reader :balls, :id

def setup
  size(640, 360)  
  @balls = []
  (0 ... NUM_BALLS).each do |i|
    balls << Ball.new(rand(width), rand(height), rand(30 .. 70), i, balls)
  end
  noStroke
  fill(255, 204)
end

def draw
  background(0)
  (0 ... NUM_BALLS).each do |i| 
    balls[i].collide 
    balls[i].move 
    balls[i].display
  end
end

class Ball
  attr_accessor :vx, :vy
  attr_reader :x, :y, :diameter, :others, :id, :width, :height
  
  def initialize(xin, yin, din, idin, oin)
    @x = xin
    @y = yin
    @diameter = din
    @id = idin
    @vx = 0
    @vy = 0
    @others = oin
    @width = $app.width
    @height = $app.height
  end 
  
  def collide
    ((id + 1) ... NUM_BALLS).each do |i|
      dx = others[i].x - x
      dy = others[i].y - y
      sq_dist = dx*dx + dy*dy
      min_dist = (others[i].diameter/2 + diameter/2)
      sq_min_dist = min_dist * min_dist
      if (sq_dist < sq_min_dist)  
        angle = atan2(dy, dx)
        target_x = x + cos(angle) * min_dist
        target_y = y + sin(angle) * min_dist
        ax = (target_x- others[i].x) * SPRING
        ay = (target_y - others[i].y) * SPRING
        @vx -= ax
        @vy -= ay
        others[i].vx += ax
        others[i].vy += ay
      end
      
    end
    
    def move
      @vy += GRAVITY
      @x += vx
      @y += vy
      if (x + diameter/2 > width)
        @x = width - diameter/2
        @vx *= FRICTION         
      elsif (x - diameter/2 < 0)
        @x = diameter/2
        @vx *= FRICTION
      end
      
      if (y + diameter/2 > height)
        @y = height - diameter/2
        @vy *= FRICTION 
      elsif (y - diameter/2 < 0)
        @y = diameter/2
        @vy *= FRICTION
      end
    end
    
    def display
      ellipse(x, y, diameter, diameter)
    end
  end
end
