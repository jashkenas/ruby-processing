require 'ruby-processing'

# Variables are used for storing values. In this example, changing 
# the values of variables @one and @two significantly changes the composition. 

class Variables < Processing::App
  
  load_library :control_panel
  
  def setup
    stroke 153
    
    @one = 20 # Change these with the sliders
    @two = 50
    
    control_panel do |c|
      c.slider :one, -20..100
      c.slider :two, -20..100
    end
  end


  def draw
    background 0
    
    c = @one * 8
    d = @one * 9
    e = @two - @one
    f = @two * 2
    g = f  + e
    
    line @one, f, @two,  g
    line @two, e, @two,  g
    line @two, e, d,     c
    line @one, e, d-e,   c
  end
  
end

Variables.new :title => "Variables", :width => 200, :height => 200