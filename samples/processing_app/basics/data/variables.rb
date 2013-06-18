# Variables are used for storing values. In this example, changing 
# the values of variables @one and @two significantly changes the composition. 

load_library :control_panel
attr_reader :panel
def setup
  size 200, 200  
  stroke 153    
  @one = 20 # Change these with the sliders
  @two = 50    
  control_panel do |c|
    c.slider :one, -20..100
    c.slider :two, -20..100
    @panel = c
  end  
end


def draw
  panel.set_visible(true)
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



