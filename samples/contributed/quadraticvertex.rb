# sketch by Jan Vantomme
# Part of a series of articles on Processing 2.
# Blog post here:
# http://vormplus.be/blog/article/drawing-shapes-with-quadratic-vertices
# translated for ruby-processing by Martin Prout (needs some drying)
# Note how to specify fill and background using hexadecimal string for color, 
# this is different from vanilla processing
#

attr_reader :debug, :save_one 

def setup
  size 450, 320 
  @debug = false
  @save_one = false
  smooth 8
end

def draw
  background color('#BDF018')
  translate width/2, height/2 
  step_angle = TWO_PI / 6
  fill color('#ffffff')
  no_stroke
  cr = map(mouse_x, 0, width, 20, 200)
  begin_shape
  7.times do |i| 
    x = cos(step_angle * i) * 100
    y = sin(step_angle * i) * 100
    cx = cos(step_angle * i - (step_angle / 2 )) * cr
    cy = sin(step_angle * i - (step_angle / 2 )) * cr    
    if (i == 0) 
      vertex x, y 
    else 
      quadratic_vertex cx, cy, x, y 
    end
  end
  end_shape(CLOSE)
  
  if (debug)    
    # draw lines between points
    stroke_weight(1)
    no_fill
    stroke(0)
    
    begin_shape
    7.times do |i|      
      x = cos(step_angle * i) * 100
      y = sin(step_angle * i) * 100      
      cx = cos(step_angle * i - (step_angle / 2)) * cr
      cy = sin(step_angle * i - (step_angle / 2)) * cr      
      if ( i > 0 ) 
        vertex cx, cy 
      end
      vertex x, y 
    end
    end_shape CLOSE
    
    # draw points
    stroke_weight 8
    
    7.times do |i|       
      x = cos(step_angle * i ) * 100
      y = sin(step_angle * i ) * 100      
      cx = cos(step_angle * i - (step_angle / 2 )) * cr
      cy = sin(step_angle * i - (step_angle / 2 )) * cr      
      stroke 0 
      point x, y       
      stroke 255, 0, 0 
      point cx, cy 
    end
  end
  
  if (save_one) 
    save_frame("images/quadraticvertex-#####.png")
    @save_one = false
  end
end

def key_pressed
  case key
  when 's'
    @save_one = true
  when 'd'
    @debug = !debug
  end
end

