require 'ruby-processing'

class DefiningAFunction < Processing::App

  def setup
  
  end
  
  def draw
  
  end
  
  # This example defines a function, but it is
  # not called.  So nothing happens.
  def draw_black_circle
    fill 0
    ellipse 50, 50, 20, 20
  end
  
end

DefiningAFunction.new :title => "Defining A Function", :width => 200, :height => 200