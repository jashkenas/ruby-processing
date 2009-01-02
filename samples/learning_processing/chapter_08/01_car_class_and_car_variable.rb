require 'ruby-processing'

class CarClassAndCarVariable < Processing::App

  def setup
    # Initialize a car object
    @my_car = Car.new(self)
    rect_mode CENTER
  end
  
  def draw
  background 255
  
  # Operate the car object in draw
  # by calling object methods using the dots syntax.
  @my_car.move
  @my_car.display_car
  end
    
end


class Car # Define a class below the rest of the program.

  def initialize(app)
    @app = app
    @c = @app.color 175
    @xpos = @app.width/2
    @ypos = @app.height/2
    @xspeed = 1
  end

  def display_car # A new function of class Car
    @app.stroke 0
    @app.fill @c
    @app.rect @xpos, @ypos, 20, 10
  end

  def move
    @xpos = @xpos + @xspeed
    @xpos = 0 if @xpos > @app.width
  end
end

CarClassAndCarVariable.new :title => "Car Class And Car Variable", :width => 200, :height => 200
