
# Saturation is the strength or purity of the color and represents the 
# amount of gray in proportion to the hue. A "saturated" color is pure 
# and an "unsaturated" color has a large percentage of gray. 
# Move the cursor vertically over each bar to alter its saturation. 

def setup
  size 640, 360
  color_mode HSB, 360
  no_stroke    
  @bar_width = 20
  @saturation = Array.new( width/@bar_width, 0 )    
end

def draw
  i = 0; j = 0; while i <= (width-@bar_width)    
  if (mouseX > i) && (mouseX < (i+@bar_width))
    @saturation[j] = mouseY
  end    
  fill i, @saturation[j], height/1.5
  rect i, 0, @bar_width, height    
  j += 1; i += @bar_width; end
end

