class Cube

	include Processing::Proxy # mixin Processing::Proxi
	
	attr_accessor :vertices
	attr_accessor :w, :h, :d
	attr_accessor :position, :speed, :rotation # Vec3D
	
	def initialize (dim)
	
		@w, @h, @d = dim, dim, dim
		
		w2 = @w / 2
		h2 = @h / 2
		d2 = @d / 2
		
		tfl = Vec3D.new(-w2, h2, d2) 	# four points making the top quad:
		tfr = Vec3D.new(w2, h2, d2)  	# "tfl" is "top front left", etc
		tbr = Vec3D.new(w2, h2,-d2)  
		tbl = Vec3D.new(-w2, h2,-d2) 
		
		bfl = Vec3D.new(-w2,-h2, d2) 	# bottom quad points
		bfr = Vec3D.new(w2,-h2, d2)  
		bbr = Vec3D.new(w2,-h2,-d2)  
		bbl = Vec3D.new(-w2,-h2,-d2) 
		
		@vertices = [
			[tfl, tfr, tbr, tbl],		# top
			[tfl, tfr, bfr, bfl],		# front
			[tfl, tbl, bbl, bfl],		# left
			[tbl, tbr, bbr, bbl],		# back
			[tbr, tfr, bfr, bbr],		# right
			[bfl, bfr, bbr, bbl]
		]
	end
	
	def draw (side_colors = nil)
		
		@vertices.each_with_index { |quad, i| # each face
				
			begin_shape QUADS
			
			fill side_colors[i] if side_colors && i < side_colors.length
		
			quad.each { |vec|
				
				vertex vec.x, vec.y, vec.z
			}
							
			end_shape

		}
	end
	
end