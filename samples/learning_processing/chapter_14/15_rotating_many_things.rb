require 'ruby-processing'

# A Rotater class
class Rotater

  def initialize(temp_x, temp_y, temp_speed, temp_w)
    @x, @y = temp_x, temp_y
    # Angle is always initialized to 0
    @theta = 0 
    @speed = temp_speed
    @w = temp_w
  end

  # Increment angle
  def spin
    @theta += @speed
  end

  # Display rectangle
  def display
    # push_matrix  and popMatrix are called inside the class' display method. 
    # This way, every Rotater object is rendered with its own independent translation and rotation!
    $app.push_matrix  
    $app.translate @x, @y
    $app.rotate @theta
    $app.rect 0, 0, @w, @w
    $app.pop_matrix 
  end

end

class RotatingManyThingsSketch < Processing::App

  def setup
    rect_mode CENTER
    stroke 0
    fill 0, 100
    @rotaters = Array.new(20) { Rotater.new(rand(width), rand(height), rand * 0.2 - 0.1, rand(48)) }
  end

  def draw
    background 255

    # All Rotaters spin and are displayed
    @rotaters.each do |r|
      r.spin
      r.display
    end
  end

end

RotatingManyThingsSketch.new :title => "Rotating Many Things", :width => 200, :height => 200

