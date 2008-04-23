# This one has a long lineage:
# It was originally adapted to Shoes in Ruby,
# from a Python example for Nodebox, and then, now
# to Ruby-Processing.

# For fun, try running it via jirb, and 
# playing with the attr_accessors, as 
# well as the background.

# This example now demonstrates the use of sliders.

# -- omygawshkenas

require 'ruby-processing'

class Sketch < Processing::App
  attr_accessor :x_wiggle, :y_wiggle, :magnitude, :bluish
  has_slider :bluish, 0.0..1.0
  has_slider :alpha, 0.0..1.0
  
  def setup
    @x_wiggle, @y_wiggle = 10.0, 0
    @magnitude = 8.15
    @bluish = 0.9
    @alpha = 0.0
    @background = [0.06, 0.03, 0.18]
    @toggle = true
    color_mode RGB, 1
    smooth
  end
  
  def alpha=(num)
    @background[3] = num
  end
  
  def background=(*args)
    @background = args.flatten
  end
  
  def draw_background
    fill *@background if @background[0]
    rect 0, 0, width, height
  end
  
  def draw
    draw_background
    
    # Seed the random numbers for consistent placement from frame to frame
    srand(0)
    horiz, vert, mag = @x_wiggle, @y_wiggle, @magnitude
    blu = bluish
    x, y = (self.width / 2), -27
    c = 0.0
    
    64.times do |i|
      x += Math.cos(horiz)*mag
      y += Math.log10(vert)*mag + Math.sin(vert) * 2
      fill(Math.sin(@y_wiggle + c), rand * 0.2, rand * blu, 0.5)
      s = 42 + Math.cos(vert) * 17
      oval(x-s/2, y-s/2, s, s)
      vert += rand * 0.25
      horiz += rand * 0.25
      c += 0.1
    end
    
    @x_wiggle += 0.05
    @y_wiggle += 0.1
  end
  
  def mouse_clicked
    self.background = [0.06, 0.03, 0.18, 0.04] if @toggle
    self.background = [0.06, 0.03, 0.18] if !@toggle
    @toggle = !@toggle
  end
end

# Try setting full screen to true.
Sketch.new(:width => 600, :height => 600, :title => "WishyWorm", :full_screen => false)