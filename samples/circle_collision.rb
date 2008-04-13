# Based on http://processing.org/learning/topics/circlecollision.html
# by Joe Holt

require 'ruby-processing'

class Vect2D
  attr_accessor :vx, :vy
  def initialize(vx = 0.0, vy = 0.0)
    @vx = vx
    @vy = vy
  end
end


class Ball
  attr_accessor :x, :y, :r, :m, :vec
  def initialize(r = 0.0, vec = nil, x = 0.0, y = 0.0)
    @x = x
    @y = y
    @r = r
    @m = r*0.1
    @vec = vec
  end

  def draw
    r = @r * 2
    P.ellipse @x, @y, r, r
    @px = @x
    @py = @y
  end

  def erase
    r = @r * 2
    P.rect @px, @py, r, r
  end
end


class Sketch < Processing::App
  include Math  

  def setup
    smooth
    noStroke
    frameRate 30
    rectMode RADIUS

    @balls = []
    5.times { @balls << Ball.new(10, Vect2D.new(2.15, -1.35), *emptySpace(15)) }
    2.times { @balls << Ball.new(40, Vect2D.new(-1.65, 0.42), *emptySpace(45)) }

    @frame_time = nil
    @frame_count = 0
  end


  def draw
    t = Time.now
    if @frame_time
        fps = 1.0 / (t - @frame_time)
#        printf "%0.1ffps\n", fps
    end
    @frame_time = t
    @frame_count += 1

    # erase previous screen
    if @frame_count == 1
      background 51
    else
      fill 51
      @balls.each { |ball| ball.erase }
    end

    # move the balls 
    fill 240
    @balls.each do |ball|
      ball.x += ball.vec.vx
      ball.y += ball.vec.vy
      ball.draw
      checkBoundaryCollision ball
    end
    checkObjectCollisions

  end


  def emptySpace(r)
    x = y = nil
    while !x || !emptySpace?(x, y, r) do
      x = rand(width)
      y = rand(height)
    end
    return x, y
  end


  def emptySpace?(x, y, r)
    @balls.each do |ball|
      vx = x - ball.x
      vy = y - ball.y
      mag = sqrt(vx * vx + vy * vy)
      return false if mag < r + ball.r
    end
    return true
  end


  def checkObjectCollisions

    (0...@balls.length).each do |ia|
      (ia+1...@balls.length).each do |ib|

        ba = @balls[ia]
        bb = @balls[ib]
  
        # get distances between the balls components
        bVect = Vect2D.new
        bVect.vx = bb.x - ba.x
        bVect.vy = bb.y - ba.y

        # calculate magnitude of the vector separating the balls
        bVectMag = sqrt(bVect.vx * bVect.vx + bVect.vy * bVect.vy)
        next if bVectMag >= ba.r + bb.r
        # get angle of bVect
        theta  = atan2(bVect.vy, bVect.vx)
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
        bTemp[1].x  = cosine * bVect.vx + sine * bVect.vy
        bTemp[1].y  = cosine * bVect.vy - sine * bVect.vx

        # rotate Temporary velocities
        vTemp = [Vect2D.new, Vect2D.new]
        vTemp[0].vx  = cosine * ba.vec.vx + sine * ba.vec.vy
        vTemp[0].vy  = cosine * ba.vec.vy - sine * ba.vec.vx
        vTemp[1].vx  = cosine * bb.vec.vx + sine * bb.vec.vy
        vTemp[1].vy  = cosine * bb.vec.vy - sine * bb.vec.vx

        # Now that velocities are rotated, you can use 1D
        # conservation of momentum equations to calculate 
        # the final velocity along the x-axis.
        vFinal = [Vect2D.new, Vect2D.new]
        # final rotated velocity for ba
        vFinal[0].vx = ((ba.m - bb.m) * vTemp[0].vx + 2 * bb.m * 
          vTemp[1].vx) / (ba.m + bb.m)
        vFinal[0].vy = vTemp[0].vy
        # final rotated velocity for ba
        vFinal[1].vx = ((bb.m - ba.m) * vTemp[1].vx + 2 * ba.m * 
          vTemp[0].vx) / (ba.m + bb.m)
        vFinal[1].vy = vTemp[1].vy

        # hack to avoid clumping
        bTemp[0].x += vFinal[0].vx
        bTemp[1].x += vFinal[1].vx

        # Rotate ball positions and velocities back
        # Reverse signs in trig expressions to rotate 
        # in the opposite direction
        # rotate balls
        bFinal = [Ball.new, Ball.new]
        bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y
        bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x
        bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y
        bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x

        # update balls to screen position
        bb.x = ba.x + bFinal[1].x
        bb.y = ba.y + bFinal[1].y
        ba.x = ba.x + bFinal[0].x
        ba.y = ba.y + bFinal[0].y

        # update velocities
        ba.vec.vx = cosine * vFinal[0].vx - sine * vFinal[0].vy
        ba.vec.vy = cosine * vFinal[0].vy + sine * vFinal[0].vx
        bb.vec.vx = cosine * vFinal[1].vx - sine * vFinal[1].vy
        bb.vec.vy = cosine * vFinal[1].vy + sine * vFinal[1].vx
      end
    end

  end


  def checkBoundaryCollision(ball)

    if ball.x > width-ball.r
      ball.x = width-ball.r
      ball.vec.vx *= -1
    elsif ball.x < ball.r
      ball.x = ball.r
      ball.vec.vx *= -1
    end
    if ball.y > height-ball.r
      ball.y = height-ball.r
      ball.vec.vy *= -1
    elsif ball.y < ball.r
      ball.y = ball.r
      ball.vec.vy *= -1
    end

  end

end


P = Sketch.new(:width => 400, :height => 400, :title => "CircleCollision2")
