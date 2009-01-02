require 'ruby-processing'

class ObjectOrientedZoog < Processing::App
  load_ruby_library "control_panel"

  def setup
    smooth
    control_panel do |c|
      c.slider :zoog_jiggle_factor, 0..width/10
    end
    
    # Initalize zoog
    @zoog = Zoog.new(self, 100, 125, 60, 60, 16)
    @zoog_jiggle_factor = 10
    
    rect_mode CENTER
    ellipse_mode CENTER
  end
  
  def draw
    background 255
    
    # mouse_x position determines speed factor
    # factor = constrain(mouse_x/10, 0, 5)
    
    @zoog.jiggle(@zoog_jiggle_factor)
    @zoog.display
  end
  
end

class Zoog
  attr_accessor :temp_x_position, :temp_y_position, :temp_width, :temp_height, :temp_eye_size
  
  def initialize(app, temp_x_position, temp_y_position, temp_zoog_width, temp_zoog_height, temp_eye_size)
    @app = app
    @x, @y = temp_x_position, temp_y_position
    @w, @h = temp_zoog_width, temp_zoog_height
    @eye_size = temp_eye_size
  end
  
  # Move zoog
  def jiggle(speed)
    @x = @x + speed * @app.random(-1,1)
    @y = @y + speed * @app.random(-1,1)
    
    @x = @app.constrain(@x, 0, @app.width)
    @y = @app.constrain(@y, 0, @app.height)
  end
  
  def display
    # Draw zoog's arms
    (@y - @h/3).step((@y + @h/2), 10) do |i|
    @app.stroke 0
    @app.line @x-@w/4, i, @x+@w/4, i
    end
    
    # Draw zoog's body
    @app.stroke 0
    @app.fill 255
    @app.rect @x, @y, @w/6, @h
    
    # Draw zoog's head
    @app.stroke 0
    @app.fill 255
    @app.ellipse @x, @y-@h, @w, @h
    
    # Draw zoog's eyes
    @app.fill 0
    @app.ellipse @x-@w/3, @y-@h, @eye_size, @eye_size*2
    @app.ellipse @x+@w/3, @y-@h, @eye_size, @eye_size*2
    
    # Draw zoog's legs
    @app.stroke 0
    @app.line @x-@w/12, @y+@h/2, @x-@w/4, @y+@h/2+10
    @app.line @x+@w/12, @y+@h/2, @x+@w/4, @y+@h/2+10
  end
  
end  

ObjectOrientedZoog.new :title => "Object Oriented Zoog", :width => 200, :height => 200