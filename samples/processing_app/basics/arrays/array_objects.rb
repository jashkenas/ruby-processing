require 'ruby-processing'

# * Demonstrates the syntax for creating an array of custom objects. 

class ArrayObjects < Processing::App

	UNIT = 40.0

  def setup
    
    @num = width/UNIT ** 2
    @mods = []
    
    i = 0; while i < height/UNIT
    	j = 0; while j < height/UNIT
    		j += 1
    		@mods << AModule.new( j*UNIT, i*UNIT, UNIT/2, UNIT/2, random( 0.05, 0.8 ) )
    	end
    	i += 1
    end
    
    background 176
    no_stroke
  end
  
  def draw
  	stroke( second * 4 )
  	
  	@mods.each do |mod|
  		mod.update
  		mod.draw( g )
  	end
  end

	# the custom object
	
	class AModule
	
		def initialize( mx, my, x, y, speed )
			@mx = my
			@my = mx
			@x = x.to_i
			@y = y.to_i
			@speed = speed
			@xdir = 1
			@ydir = 1
			@size = UNIT
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
		
		def draw( context )
			context.point( @mx + @x - 1, @my + @y - 1 )
		end
	
	end
  
end

ArrayObjects.new :title => "Array Objects", :width => 200, :height => 200