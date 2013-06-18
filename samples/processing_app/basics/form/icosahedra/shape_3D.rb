
# fjenett, 2010-03-11:
# Left this in although it's not needed as an example for 
# how to extend classes.

class Shape3D

	attr_accessor :x, :y, :z
	attr_accessor :w, :h, :d
	
	def initialize (*args)
		@x, @y, @z = 0.0, 0.0, 0.0
		@w, @h, @d = 0.0, 0.0, 0.0
	end
	
	def rotate_x ( theta )
	end
	
	def rotate_y ( theta )
	end
	
	def rotate_z ( theta )
	end

end