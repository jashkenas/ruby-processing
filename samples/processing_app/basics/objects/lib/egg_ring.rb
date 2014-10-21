require_relative 'ring'
require_relative 'egg'

class EggRing
   attr_reader :ovoid, :circle

  def initialize(app, x, y, t, sp)
    @ovoid = Egg.new(app, x, y, t, sp)
    @circle = Ring.new(app)
    circle.start(x, y - sp / 2)
  end

  def transmit
    ovoid.wobble
    ovoid.display
    circle.grow
    circle.display
    circle.on = true unless circle.on
  end
end
