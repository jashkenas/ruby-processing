# Triangle Flower 
# by Ira Greenberg. 
# 
# Using rotate() and triangle() functions generate a pretty 
# flower. Uncomment the line "// rotate(rot+=radians(spin));"
# in the triBlur() function for a nice variation.

class TriangleFlower < Processing::App

  def setup
    
    size 200, 200
    
    background 0
    smooth
    
    @fill_color = 0.0
    @shift = 1.0
    @rot = 0.0
    @fade = 255.0 / ( width / 2.0 / @shift )
    @spin = 360.0 / ( width / 2.0 / @shift )
    
    @p = []
    @p.push Point.new -width / 2.0, height / 2.0
    @p.push Point.new  width / 2.0, height / 2.0
    @p.push Point.new  0.0,        -height / 2.0
    
    no_stroke
    translate width/2, height/2
    
    while @p[0].x < 0 do
	    tri_blur
	end
  end
  
  def tri_blur
  
  	fill @fill_color
  	@fill_color += @fade
  	
  	rotate @spin
  	
  	# try these lines also ..
  	#@rot += radians @spin
  	#rotate @rot
  	
  	@p[0].x += @shift
  	@p[0].y -= @shift / 2
  	@p[1].x -= @shift
  	@p[1].y -= @shift / 2
  	@p[2].y += @shift
  	
  	triangle @p[0].x, @p[0].y, @p[1].x, @p[1].y, @p[2].x, @p[2].y
  end
  
end

class Point

	attr_accessor :x, :y
	
	def initialize ( x, y )
	
		@x, @y = x, y
	end

end

TriangleFlower.new :title => "Triangle Flower"