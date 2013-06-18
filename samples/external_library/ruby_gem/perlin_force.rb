require 'perlin_noise'

attr_reader :md, :points, :p, :n2d

def setup
  size(800, 600)
  @n2d = Perlin::Noise.new 2, :curve => Perlin::Curve::CUBIC
  md = false
  @points = []
  background(255)
  smooth(8)
end

def draw
  if (md)
    500.times do
      points << Point.new(rand(0 ... width), rand(0 ... height))
    end
  end
  noise_detail(8,0)

  (points.size - 1).downto(1) do |i|
    @p = points[i]
    p.update n2d
    if (p.finished)
      points.delete_at(i)
    end
  end
  # puts(points.size)
end

def mousePressed
  @md = true
end

def mouseReleased
  @md = false
end

def keyPressed
  background(255)
  (points.size - 1).downto(1) do |i|
    @p = points[i]
    points.delete_at(i)
  end
end

class Point
  include Processing::Proxy

  MAX_SPEED = 3000000

  attr_reader :finished, :x, :y, :xv, :yv, :width, :height

  def initialize(x = 0, y = 0)
    @x, @y = x, y
    @xv, @yv = 0, 0
    @finished = false
    @width = $app.width
    @height = $app.height
  end

  def update n2d
    stroke(0, 16)
    @xv = cos(n2d[x * 0.01, y * 0.01] * TWO_PI)
    @yv = -sin(n2d[x * 0.01, y * 0.01] * TWO_PI)

    if ((x > width) || (x < 0))
      @finished = true
    end

    if ((y > height) || (y < 0))
      @finished = true
    end

    if (xv > MAX_SPEED)
      @xv = MAX_SPEED
    else
      @xv = -MAX_SPEED if (xv < -MAX_SPEED)
    end

    if (yv>MAX_SPEED)
      @yv = MAX_SPEED
    else
      @yv = -MAX_SPEED if (yv < -MAX_SPEED)
    end

    @x += xv
    @y += yv

    line(x + xv, y + yv, x, y )
  end
end
