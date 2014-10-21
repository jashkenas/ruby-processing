###########################
# More OO version no use of
# Processing::Proxy
###########################
require_relative 'lib/egg_ring'

attr_reader :egg_one, :egg_two

def setup
  size 640, 360
  @egg_one = EggRing.new(self, width * 0.45, height * 0.5, 0.1, 120)
  @egg_two = EggRing.new(self, width * 0.65, height * 0.8, 0.05, 180)
end

def draw
  background 0
  egg_one.transmit
  egg_two.transmit
end
