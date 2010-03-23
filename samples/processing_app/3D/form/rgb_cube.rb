# RGB Cube.
# 
# The three primary colors of the additive color model are red, green, and blue.
# This RGB color cube displays smooth transitions between these colors. 

class RgbCube < Processing::App

  def setup
    size 640, 360, P3D
    
    no_stroke
    color_mode RGB, 2

	@xmag = 0
	@ymag = 0
	@new_xmag = 0
	@new_ymag = 0
	
	# since each point is used three times
	@box_points = {
		:top_front_left 	=> [-1,  1,  1],
		:top_front_right 	=> [ 1,  1,  1],
		:top_back_right 	=> [ 1,  1, -1],
		:top_back_left 		=> [-1,  1, -1],
		:bottom_front_left 	=> [-1, -1,  1],
		:bottom_front_right	=> [ 1, -1,  1],
		:bottom_back_right	=> [ 1, -1, -1],
		:bottom_back_left 	=> [-1, -1, -1]
	}
	# a box from defined points
	@box = {
		:top 	=> [@box_points[:top_front_left], 	 @box_points[:top_front_right], 	@box_points[:top_back_right], 	  @box_points[:top_back_left]],
		:front 	=> [@box_points[:top_front_left], 	 @box_points[:top_front_right], 	@box_points[:bottom_front_right], @box_points[:bottom_front_left]],
		:left 	=> [@box_points[:top_front_left], 	 @box_points[:bottom_front_left], 	@box_points[:bottom_back_left],   @box_points[:top_back_left]],
		:back	=> [@box_points[:top_back_left], 	 @box_points[:top_back_right], 		@box_points[:bottom_back_right],  @box_points[:bottom_back_left]],
		:right	=> [@box_points[:top_back_right], 	 @box_points[:bottom_back_right], 	@box_points[:bottom_front_right], @box_points[:top_front_right]],
		:bottom => [@box_points[:bottom_front_left], @box_points[:bottom_front_right],  @box_points[:bottom_back_right],  @box_points[:bottom_back_left]]
	}
  end
  
  def draw
  
  	background 1
  	
  	push_matrix
  	
  	translate width/2, height/2, -30
  	
  	@new_xmag = mouseX / width.to_f * TWO_PI
  	@new_ymag = mouseY / height.to_f * TWO_PI
  	
  	diff = @xmag - @new_xmag
  	@xmag -= diff / 4 if diff.abs > 0.01
  	
  	diff = @ymag - @new_ymag
  	@ymag -= diff / 4 if diff.abs > 0.01
  	
  	rotate_x -@ymag
  	rotate_y -@xmag
  	
  	scale 90
  	
  	begin_shape QUADS
  	
  	[:top, :front, :left, :back, :right, :bottom].each { |s|
  		@box[s].each { |p|
  			fill_from_points p
  			vertex_from_points p
  		}
  	}
  	
  	end_shape
  	
  	pop_matrix
  
  end
  
  def fill_from_points ( points )
  	fill points[0] + 1, points[1] + 1, points[2] + 1 # "+1" translates -1,1 to 0,2
  end
  
  def vertex_from_points ( points )
  	vertex points[0], points[1], points[2]
  end
  
end

RgbCube.new :title => "Rgb Cube"