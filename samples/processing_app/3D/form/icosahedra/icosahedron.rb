
# fjenett, 2010-03-11:
# Mixing in Processing::Proxy makes classes behave like inner classes(*) of
# a Processing sketch (any class that's defined in a sketch and that is
# inside a .pde file). This is needed for a class to be able to call any
# drawing commands etc.
# (*) Ruby does not know inner classes btw. ...


require 'shape_3D' 			# load shape_3D.rb

class Icosahedron < Shape3D 		# extends Shape3D

	include Processing::Proxy 	# mixin Processing::Proxy

	attr_accessor :top_point, :top_pent
	attr_accessor :bottom_point, :bottom_pent
	attr_accessor :angle, :radius
	attr_accessor :tri_dist, :tri_ht
	attr_accessor :a, :b, :c

	def initialize ( *args )

		super args 		# call Shape3D.new( args )

		@radius = args.first
		@top_pent = Array.new 5
		@bottom_pent = Array.new 5
		@angle = 0.0

		init

	end

	def init

		@c = dist( cos(0) * @radius,
				   sin(0) * @radius,
				   cos(radians( 72 )) * @radius,
				   sin(radians( 72 )) * @radius )

		@b = @radius

		@a = sqrt(@c*@c - @b*@b)

		@tri_ht = sqrt( @c*@c - (@c/2) * (@c/2) )

		@top_pent.each_with_index { |v, i|

			@top_pent[i] = PVector.new( cos(@angle) * @radius,
						    sin(@angle) * @radius,
						    @tri_ht / 2 )

			@angle += radians 72
		}

		@top_point = PVector.new 0, 0, @tri_ht / 2 + @a

		@angle = 72.0/2

		@bottom_pent.each_with_index { |v, i|

			@bottom_pent[i] = PVector.new( cos(@angle) * @radius,
						       sin(@angle) * @radius,
						       -@tri_ht / 2 )
			@angle += radians 72
		}

		@bottom_point = PVector.new 0, 0, -(@tri_ht / 2 + @a)

	end

	def draw

		[@top_pent, @bottom_pent].each { |pent| # top and bottom pentagram

			(0...pent.length).each { |i|

				begin_shape

					# next or first
					n = i+1
					n = n % @top_pent.length # wrap around

					# choose point depending on pentagram
					pnt = @top_point
					pnt = @bottom_point if pent == @bottom_pent

					# draw triangle
					vertex @x + pent[i].x,  @y + pent[i].y, 	@z + pent[i].z
					vertex @x + pnt.x,	@y + pnt.y, 		@z + pnt.z
					vertex @x + pent[n].x,  @y + pent[n].y, 	@z + pent[n].z

				end_shape CLOSE
			}
		}

		begin_shape TRIANGLE_STRIP

		0.upto(6) { |i| # stitch pentagrams together with triangles

			j = i
			j = j % @top_pent.length

			n = i+2
			n = n % @bottom_pent.length

			vertex @x + @top_pent[j].x,  	@y + @top_pent[j].y,	@z + @top_pent[j].z
			vertex @x + @bottom_pent[n].x,  @y + @bottom_pent[n].y, @z + @bottom_pent[n].z
		}

		end_shape

	end

end