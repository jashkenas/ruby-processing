# Mandelbrot Set example
# by Jordan Scales (http://jordanscales.com)
# 27 Dec 2012

class Mandelbrot < Processing::App

  # default size 900x600
  # no need to loop
  def setup
    size 900, 600
    no_loop
  end
  
  # main drawing method
  def draw
    (0..900).each do |x|
      (0..600).each do |y|
        c = Complex.new(map(x, 0, 900, -3, 1.5), map(y, 0, 600, -1.5, 1.5))
    
        # mandel will return 0 to 20 (20 is strong)
        #   map this to 0, 255 (and flip it)
        set(x, y, color(255 - map(mandel(c,20), 0, 20, 0, 255).to_i))
      end
    end
  end

  # maps a value in one range to another
  #    : 6 from 0 to 10 => 12 from 0 to 20
  def map(val, in_min, in_max, out_min, out_max)
    val.to_f / (in_max - in_min) * (out_max - out_min) + out_min
  end

  # calculates the "accuracy" of a given point in the mandelbrot set
  #    : how many iterations the number survives without becoming chaotic
  def mandel(z, max = 10)
    score = 0
    c = z.clone
    while score < max do
      # z = z^2 + c
      z.square
      z.add c
      break if z.abs > 2

      score += 1
    end

    score
  end

end

# rolled my own Complex class
#   stripped of all functionality, except for what I needed (abs, square, add, to_s)
#   
#   Using this class, runs in ~12.5s on my MacBook Air
#     compared to ~22s using ruby's Complex struct
class Complex

  attr_accessor :real, :imag

  def initialize(real, imag)
    @real = real
    @imag = imag
  end

  # squares a complex number - overwriting it
  def square
    r = @real * @real - @imag * @imag
    i = 2 * @real * @imag

    @real = r
    @imag = i
  end

  # adds a given complex number
  def add(c)
    @real += c.real
    @imag += c.imag
  end

  # computes the magnitude
  def abs
    Math.sqrt(@real * @real + @imag * @imag)
  end

  def to_s
    "#{@real} + #{@imag}i"
  end

end