require 'ruby-processing/app' # require Processing::Proxi

class Cube

	include Processing::Proxy # mixin Processing::Proxi
	
	attr_accessor :vertices
	attr_accessor :w, :h, :d
	attr_accessor :position, :speed, :rotation # PVector
	
	def initialize ( w, h, d )
	
		@w, @h, @d = w, h, d
		
		w2 = @w/2
		h2 = @h/2
		d2 = @d/2
		
		tfl = PVector.new -w2, h2, d2	# four points making the top quad:
		tfr = PVector.new  w2, h2, d2	# "tfl" is "top front left", etc
		tbr = PVector.new  w2, h2,-d2
		tbl = PVector.new -w2, h2,-d2
		
		bfl = PVector.new -w2,-h2, d2	# bottom quad points
		bfr = PVector.new  w2,-h2, d2
		bbr = PVector.new  w2,-h2,-d2
		bbl = PVector.new -w2,-h2,-d2
		
		@vertices = [
			[tfl, tfr, tbr, tbl],		# top
			[tfl, tfr, bfr, bfl],		# front
			[tfl, tbl, bbl, bfl],		# left
			[tbl, tbr, bbr, bbl],		# back
			[tbr, tfr, bfr, bbr],		# right
			[bfl, bfr, bbr, bbl]
		]
	end
	
	def draw ( side_colors = nil )
		
		@vertices.each_with_index { |quad, i| # each face
				
			begin_shape QUADS
			
			fill side_colors[i] if side_colors && i < side_colors.length
		
			quad.each { |pvec|
				
				vertex pvec.x, pvec.y, pvec.z
			}
							
			end_shape

		}
	end
	
end