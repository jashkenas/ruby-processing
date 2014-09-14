# Based on http://processing.org/learning/topics/circlecollision.html
# by Joe Holt
load_library :vecmath


# This inner class demonstrates the use of Ruby-Processing's emulation of
# Java inner classes. The Balls are able to call Processing::App methods.
class Ball
  attr_accessor :position, :r, :m, :velocity, :current
  def initialize(r = 0.0, velocity = nil, position = Vec2D.new)
    @position, @velocity, @r = position, velocity, r
    @m = r * 0.1
  end
  
  def move
    @position += velocity
  end
  
  def draw
    d = r * 2
    ellipse position.x, position.y, d, d
    @current = position.copy
  end
  
  def erase
    d = r * 2
    rect current.x, current.y, d, d
  end
end

attr_reader :balls


def setup
  size 400, 400
  no_stroke
  frame_rate 30
  rect_mode RADIUS    
  @balls = []
  5.times { balls << Ball.new(10, Vec2D.new(2.15, -1.35), empty_space(15)) }
  2.times { balls << Ball.new(40, Vec2D.new(-1.65, 0.42), empty_space(45)) }    
  @frame_time = nil
  @frame_count = 0
end


def draw
  t = Time.now
  fps = 1.0 / (t - @frame_time) if @frame_time
  @frame_time = t
  @frame_count += 1
  
  # erase previous screen
  if @frame_count == 1
    background 51
  else
    fill 51
    balls.each { |ball| ball.erase }
  end
  
  # move the balls 
  fill 240
  balls.each do |ball|
    ball.move
    ball.draw
    check_boundary_collision ball
  end
  check_object_collisions
end


def empty_space(r)
  pos = nil
  while !pos || !empty_space?(pos, r) do
    pos = Vec2D.new(rand(r..width - r), rand(r..height - r))
  end
  return pos
end


def empty_space?(position, r)
  balls.each do |ball|
    return false if position.dist(ball.position) < r + ball.r
  end
  return true
end


def check_object_collisions
  
  (0...(balls.length)).each do |ia|
    ((ia+1)...(balls.length)).each do |ib|
      
      ba = balls[ia]
      bb = balls[ib]
      
      # get distances between the balls components
      bVect = bb.position - ba.position   
      # calculate magnitude of the vector separating the balls
      bVectMag = bVect.mag
      next if bVectMag >= ba.r + bb.r
      # get angle of bVect
      theta  = atan2(bVect.y, bVect.x)
      # precalculate trig values
      sine = sin(theta)
      cosine = cos(theta)
      
      # bTemp will hold rotated ball positions. You just
      # need to worry about bTemp[1] position
      bTemp = [Ball.new, Ball.new]
      # bb's position is relative to ba's
      # so you can use the vector between them (bVect) as the 
      # reference point in the rotation expressions.
      # bTemp[0].x and bTemp[0].y will initialize
      # automatically to 0.0, which is what you want
      # since bb will rotate around ba
      bTemp[1].position.x  = cosine * bVect.x + sine * bVect.y
      bTemp[1].position.y  = cosine * bVect.y - sine * bVect.x
      
      # rotate Temporary velocities
      vTemp = [Vec2D.new, Vec2D.new]
      vTemp[0].x  = cosine * ba.velocity.x + sine * ba.velocity.y
      vTemp[0].y  = cosine * ba.velocity.y - sine * ba.velocity.x
      vTemp[1].x  = cosine * bb.velocity.x + sine * bb.velocity.y
      vTemp[1].y  = cosine * bb.velocity.y - sine * bb.velocity.x
      
      # Now that velocities are rotated, you can use 1D
      # conservation of momentum equations to calculate 
      # the final velocity along the x-axis.
      vFinal = [Vec2D.new, Vec2D.new]
      # final rotated velocity for ba
      vFinal[0].x = ((ba.m - bb.m) * vTemp[0].x + 2 * bb.m * vTemp[1].x) / (ba.m + bb.m)
      vFinal[0].y = vTemp[0].y
      # final rotated velocity for ba
      vFinal[1].x = ((bb.m - ba.m) * vTemp[1].x + 2 * ba.m * vTemp[0].x) / (ba.m + bb.m)
      vFinal[1].y = vTemp[1].y      

      # Rotate ball positions and velocities back
      # Reverse signs in trig expressions to rotate 
      # in the opposite direction
      # rotate balls
      bFinal = [Ball.new, Ball.new]
      bFinal[0].position.x = cosine * bTemp[0].position.x - sine * bTemp[0].position.y
      bFinal[0].position.y = cosine * bTemp[0].position.y + sine * bTemp[0].position.x
      bFinal[1].position.x = cosine * bTemp[1].position.x - sine * bTemp[1].position.y
      bFinal[1].position.y = cosine * bTemp[1].position.y + sine * bTemp[1].position.x
      
      # update balls to screen position
      bb.position = ba.position + bFinal[1].position     
      ba.position = ba.position + bFinal[0].position

      
      # update velocities
      ba.velocity.x = cosine * vFinal[0].x - sine * vFinal[0].y
      ba.velocity.y = cosine * vFinal[0].y + sine * vFinal[0].x
      bb.velocity.x = cosine * vFinal[1].x - sine * vFinal[1].y
      bb.velocity.y = cosine * vFinal[1].y + sine * vFinal[1].x
    end
  end
  
end

# reverse ball velocity if at sketch boundary
def check_boundary_collision(ball)  
  ball.velocity.x *= -1 unless (ball.r..width - ball.r).include? ball.position.x 
  ball.velocity.y *= -1 unless (ball.r..height - ball.r).include? ball.position.y 
end


