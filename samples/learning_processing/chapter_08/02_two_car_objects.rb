require 'ruby-processing'

class TwoCarObjects < Processing::App
  load_library :control_panel

  def setup
    control_panel do |c|
      c.slider :red_car_speed, -5..15
      c.slider :blue_car_speed, -5..15
    end
    
    # Initialize car objects
    @red_car  = Car.new(self, color(255,0,0), 0, 100)
    @blue_car  = Car.new(self, color(0,0,255), 0, 10)
    @red_car_speed = 1
    @blue_car_speed = 2
    rect_mode CENTER
  end
  
  def draw
  background 255
  
  # Operate the car object in draw
  # by calling object methods using the dots syntax.
  @red_car.move(@red_car_speed)
  @red_car.display_car
  @blue_car.move(@blue_car_speed)
  @blue_car.display_car
  end
    
end


class Car # Define a class below the rest of the program.
  attr_accessor :temp_color, :temp_x_position, :temp_y_position, :temp_x_speed
  LENGTH = 20
  HEIGHT = 10

  def initialize(app, temp_color, temp_x_position, temp_y_position)
    @app = app
    @c = temp_color
    @xpos = temp_x_position
    @ypos = temp_y_position
  end

  def display_car # A new function of class Car
    @app.stroke 0
    @app.fill @c
    @app.rect @xpos, @ypos, LENGTH, HEIGHT
  end

  def move(speed)
    @xpos += speed
    @xpos = 0 if @xpos > @app.width + LENGTH/2
    @xpos = @app.width if @xpos < -LENGTH/2
  end
end

TwoCarObjects.new :title => "Car Class And Car Variable", :width => 200, :height => 200

