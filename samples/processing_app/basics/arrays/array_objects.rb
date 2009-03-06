require 'ruby-processing'

# * Demonstrates the syntax for creating an array of custom objects. 

class ArrayObjects < Processing::App

	UNIT = 40

  def setup
    
    @num = width/UNIT ** 2
    @mods = []
    
    basis = (height/UNIT).to_i
    
    basis.times do |i|
      basis.times do |j|
    		@mods << CustomObject.new( j*UNIT, i*UNIT, UNIT/2, UNIT/2, random( 0.05, 0.8 ) )
    	end
    end
    
    background 176
    no_stroke
  end
  
  def draw
  	stroke(second * 4)
  	
  	@mods.each do |mod|
  		mod.update; mod.draw
  	end
  end

	# the custom object
	
	class CustomObject
	
		def initialize( mx, my, x, y, speed )
			@mx, @my      = my, mx                # This is backwards because the Processing example is backwards.
			@x, @y        = x.to_i, y.to_i
			@xdir, @ydir  = 1, 1
		  @speed        = speed
			@size         = UNIT
		end
		
		def update
			@x += @speed * @xdir
			if @x >= @size || @x <= 0
				@xdir *= -1
				@x += @xdir
				@y += @ydir
			end
			if @y >= @size || @x <= 0
				@ydir *= -1
				@y += @ydir
			end
		end
		
		def draw
			$app.point( @mx + @x - 1, @my + @y - 1 )
		end
	
	end
  
end

ArrayObjects.new :title => "Array Objects", :width => 200, :height => 200