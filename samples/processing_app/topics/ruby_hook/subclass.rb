# An example demonstrating the use of a hook to decouple subclasses in
# ruby-processing. The base class here is Spin, and we have included
# post_initialize as the hook (it does nothing in the base class). SpinArm
# and SpinSpots both subclass Spin, but only SpinSpots requires the hook to
# change the initialization. Note the use the hook means the subclass does
# not need to call super

def setup
  size 640, 360
  @arm = SpinArm.new({ x: width/2, y: height/2, s: 0.01 })
  @spots = SpinSpots.new({ x: width/2, y: height/2, s: -0.02, d: 90.0 })
end

def draw
  background 204
  @arm.display
  @spots.display
end


class Spin

  attr_accessor :x, :y, :speed
  attr_accessor :angle

  def initialize(args = {})
    @x, @y = args[:x], args[:y]
    @speed = args[:s]
    @angle = args[:angle] || 0.0
    post_initialize(args)  # this is the hook
  end

  def update
    @angle += speed
  end

  def post_initialize args
    nil
  end

end


class SpinArm < Spin # inherit from (or "extend") class Spin
  # NB: initialize inherited from Spin class

  def display
    stroke_weight 1
    stroke 0
    push_matrix
    translate x, y
    update
    rotate angle
    line 0, 0, 165, 0
    pop_matrix
  end
end


class SpinSpots < Spin
  attr_accessor :dim

  def post_initialize args
    @dim = args[:d]
  end

  def display
    no_stroke
    push_matrix
    translate x, y
    update
    rotate angle
    ellipse(-dim/2, 0, dim, dim)
    ellipse(dim/2, 0, dim, dim)
    pop_matrix
  end
end

