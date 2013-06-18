require 'perlin_noise'

def setup
  size 200, 200
  n1d = Perlin::Noise.new 2
  0.step(100, 0.01) do |x|
    puts n1d[x, x +1]
  end
end

