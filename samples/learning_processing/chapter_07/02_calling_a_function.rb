require 'ruby-processing'

class CallingAFunction < Processing::App

  def setup
    smooth
    draw_black_circle
  end
  
  def draw
    background 255
    draw_black_circle
  end
  
  def draw_black_circle
    fill 0
    ellipse 50, 50, 20, 20
  end
  
end

CallingAFunction.new :title => "Calling A Function", :width => 100, :height => 100