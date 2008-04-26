require 'ruby-processing'

class Space < Processing::App
  load_java_library "opengl"

  class << self; attr_accessor :instance; end

  class Velocity 
    attr_accessor :dx, :dy, :dz
    def initialize(dx = 0, dy = 0, dz = 0)
      @dx, @dy, @dz = dx, dy, dz
    end
  end

  class PObject
    def method_missing(meth, *args, &block)
      Space.instance.send(meth, *args, &block)
    end
  end

  class Position < PObject
    attr_accessor :x, :y, :z
    def initialize(x = 0, y = 0, z = 0)
      @x, @y, @z = x, y, z
    end
    def move(vel)
      if vel
        @x += vel.dx
        @y += vel.dy
        @z += vel.dz
      end
      translate @x, @y, @z
    end
  end

  class Rotation < PObject
    attr_accessor :x, :y, :z
    def initialize(x = 0, y = 0, z = 0)
      @x, @y, @z = x, y, z
    end
    def move(spin)
      if spin
        @x += spin.dx
        @y += spin.dy
        @z += spin.dz
      end
      rotate_x @x
      rotate_y @y
      rotate_z @z
    end
  end

  class Shape < PObject
    attr_accessor :position, :velocity, :rotation, :spin, :size
    def initialize(pos = Position.new, rot = Rotation.new, sz = 10)
      @position, @rotation, @size = pos, rot, sz
    end
    def move
      @size = 0 if @size < 0
      position.move(@velocity)
      rotation.move(@spin)
      end
  end

  class Box < Shape
    def draw
      box size
    end
  end

  def initialize(*args)
    self.class.instance = self
    super
  end

  def setup
    render_mode OPENGL
    fill 204
    @vel    = Velocity.new 0, 0, 0
    @spin   = Velocity.new 0, 0, 0
    @growth = 0
    @object = Box.new(Position.new(0, 200, -20), Rotation.new, 50)
  end

  # KEYS = {UP => :up, DOWN => :down, LEFT => :left, RIGHT => :right, SHIFT => :shift}
  # class Keyboard
  #   def method_missing(meth,*args,&block)
  #   end
  # end

  def key_pressed
    if key == CODED
      shift = false
      case keyCode
      when UP
        if shift
          @vel.dy = -20
        else
          @vel.dz = -20
        end
      when DOWN
        if shift
          @vel.dy = 20
        else
          @vel.dz = 20
        end
      when LEFT
        @vel.dx = -5
      when RIGHT
        @vel.dx = 5
      else
        puts "unknown key: #{keyCode}"
      end
    else
      case keyCode
      when ?W
        @growth -= 1
      when ?E
        @growth += 1
      when ?S
        @spin.dy -= PI/40
      when ?D
        @spin.dy += PI/40
      when ?X
        @spin.dx -= PI/40
      when ?C
        @spin.dx += PI/40
      else
        puts "unknown key: #{keyCode}"
      end
    end
  end

  def key_released
    @vel, @spin, @growth = Velocity.new(0,0,0), Velocity.new(0,0,0), 0
  end

  def draw
    lights
    background 0
    no_stroke
    @object.velocity = @vel
    @object.spin = @spin
    @object.size += @growth
    @object.move
    @object.draw
  rescue => e
    puts e.to_s, *e.backtrace
    raise e
  end
end

Space.new :full_screen => true