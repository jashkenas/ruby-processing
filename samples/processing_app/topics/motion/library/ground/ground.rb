class Ground  
  attr_accessor :x, :y, :len, :rot 
  attr_reader :x1, :y1, :x2, :y2 
  
  def initialize(x1, y1, x2, y2)
    @x1, @y1, @x2, @y2 = x1, y1, x2, y2
    @x = (x1 + x2) / 2.0
    @y = (y1 + y2) / 2.0
    @len = dist(x1, y1, x2, y2)
    @rot = Math.atan2((y2 - y1), (x2 - x1))
  end
  
  def dist(x1, y1, x2, y2)
    Math.sqrt( (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2) )
  end
end

class Orb
  attr_accessor :x, :y, :r  
  def initialize (x, y, r)
    @x, @y, @r = x, y, r
  end

  def move v
    @x += v.x
    @y += v.y
  end
end

class Vect
  attr_accessor :x, :y

  def initialize(x, y)
    @x, @y = x, y
  end
  
  def add v
    @x += v.x
    @y += v.y
  end
end

