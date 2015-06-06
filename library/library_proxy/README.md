### Using the LibraryProxy in your sketches
In the sketch you should `load_library :library_proxy` and your library class should inherit 
from LibraryProxy and implement pre(), draw() and post() methods (can be empty method if not 
required). For simplicity initialize your `processing library` in the sketch `setup`.

### Example library

```ruby
require 'forwardable'

# A custom Array created using forwardable (that can also access the PApplet pre,
# post and draw loops by extending our new LibraryProxy class. Also has access
# to custom background(int), fill(int) and stroke(int) methods.
class CustomArray < LibraryProxy
  extend Forwardable
  def_delegators(:@objs, :each, :<<)
  include Enumerable

  attr_reader :app

  # We must initialize class with the PApplet instance
  def initialize(app)
    @app = app
    @objs = []
  end

  def add_object(mx, my, x, y, speed)
    self << Particle.new(x.to_i, y.to_i, mx, my, Sketch::UNIT, speed, 1, 1)
  end

  # Access the processing post loop (gets called after draw)
  def post
    each do |obj|
      update_x obj
      next unless obj.y >= Sketch::UNIT || obj.x <= 0
      obj.ydir *= -1
      obj.y += obj.ydir
    end
  end

  def update_x(obj)
    obj.x += obj.speed * obj.xdir
    return if (0..Sketch::UNIT).cover? obj.x
    obj.xdir *= -1
    obj.x += obj.xdir
    obj.y += obj.ydir
  end

  # We need this to fulfill the contract of implementing abstract methods of
  # LibraryProxy which is an alias for Java::ProcessingCore::AbstractLibrary
  def pre
  end

  # Access the processing draw loop here, using our custom background and fill
  # note: use of 'app' to access ellipse functionality as would otherwise be
  # required for background and fill
  def draw
    background(0)
    fill(255)
    each do |obj|
      app.ellipse(obj.mx + obj.x, obj.my + obj.y, 6, 6)
    end
  end
end

# The Particle object

Particle = Struct.new(:x, :y, :mx, :my, :size, :speed, :xdir, :ydir)
```
### Example sketch

```ruby
# A minimalist sketch that demonstrates a possible approach to creating a custom
# array of objects using forwardable. Also demonstrates how to use LibraryProxy.

load_library :library_proxy     # loads the JRubyArt LibraryProxy abstract class
require_relative 'custom_array' # loads our custom 'library' class

UNIT = 40

def setup
  size 640, 360
  wide_count = width / UNIT
  height_count = height / UNIT
  custom_array = CustomArray.new(self)
  height_count.times do |i|
    wide_count.times do |j|
      custom_array.add_object(j * UNIT, i * UNIT, UNIT / 2, UNIT / 2, rand(0.05..0.8))
    end
  end
  no_stroke
end

# does nothing here see custom_array.rb
def draw
end
```