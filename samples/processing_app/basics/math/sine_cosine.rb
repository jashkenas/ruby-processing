# Sine Cosine. 
# 
# Linear movement with sin() and cos(). 
# Numbers between 0 and PI*2 (TWO_PI which is roughly 6.28) 
# are put into these functions and numbers between -1 and 1 are 
# returned. These values are then scaled to produce larger movements. 

class SineCosine < Processing::App

  def setup
    
    size 200, 200
    no_stroke
    smooth
    
    @i = 45
    @j = 225
    @pos1 = 0.0
    @pos2 = 0.0
    @pos3 = 0.0
    @pos4 = 0.0
    @sc = 40
    
  end
  
  def draw
  
  	background 0
  	
  	fill 51
  	rect 60, 60, 80, 80
  	
  	fill 255
  	ellipse @pos1, 36, 32, 32
  	
  	fill 153
  	ellipse 36, @pos2, 32, 32
  	
  	fill 255
  	ellipse @pos3, 164, 32, 32
  	
  	fill 153
  	ellipse 164, @pos4, 32, 32
  	
  	@i += 3
  	@j -= 3
  	
  	ang1 = radians @i
  	ang2 = radians @j
  	
  	@pos1 = width/2 + (@sc * cos( ang1 ))
  	@pos2 = width/2 + (@sc * sin( ang1 ))
  	@pos3 = width/2 + (@sc * cos( ang2 ))
  	@pos4 = width/2 + (@sc * sin( ang2 ))
  
  end
  
end

SineCosine.new :title => "Sine Cosine"