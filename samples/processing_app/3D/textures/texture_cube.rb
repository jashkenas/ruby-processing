# TexturedCube
# by Dave Bollinger.
# 
# Drag mouse to rotate cube. Demonstrates use of u/v coords in 
# vertex ) and effect on texture(). The textures get distorted using
# the P3D renderer as you can see, but they look great using OPENGL.

class TextureCube < Processing::App

  def setup
    
    size 649, 360, P3D
    
    @rotx = PI/4
    @roty = PI/4
    
    @tex = load_image "berlin-1.jpg"
    texture_mode NORMALIZED
    fill 255
    stroke 44, 48, 32
    
  end
  
  def draw
  
  	background 0
  	
  	no_stroke
  	
  	translate width/2, height/2, -100
  	
  	rotate_x @rotx
  	rotate_y @roty
  	
  	scale 90
  	
  	texture_cube
  
  end
  
  def texture_cube
  
	# Given one texture and six faces, we can easily set up the uv coordinates
	# such that four of the faces tile "perfectly" along either u or v, but the other
	# two faces cannot be so aligned.  This code tiles "along" u, "around" the X/Z faces
	# and fudges the Y faces - the Y faces are arbitrarily aligned such that a
	# rotation along the X axis will put the "top" of either texture at the "top"
	# of the screen, but is not otherwised aligned with the X/Z faces. (This
	# just affects what type of symmetry is required if you need seamless
	# tiling all the way around the cube)
	
	begin_shape QUADS
	
	texture @tex
	
	# +Z "front" face
	vertex -1, -1,  1, 0, 0
	vertex  1, -1,  1, 1, 0
	vertex  1,  1,  1, 1, 1
	vertex -1,  1,  1, 0, 1
	
	# -Z "back" face
	vertex  1, -1, -1, 0, 0
	vertex -1, -1, -1, 1, 0
	vertex -1,  1, -1, 1, 1
	vertex  1,  1, -1, 0, 1
	
	# +Y "bottom" face
	vertex -1,  1,  1, 0, 0
	vertex  1,  1,  1, 1, 0
	vertex  1,  1, -1, 1, 1
	vertex -1,  1, -1, 0, 1
	
	# -Y "top" face
	vertex -1, -1, -1, 0, 0
	vertex  1, -1, -1, 1, 0
	vertex  1, -1,  1, 1, 1
	vertex -1, -1,  1, 0, 1
	
	# +X "right" face
	vertex  1, -1,  1, 0, 0
	vertex  1, -1, -1, 1, 0
	vertex  1,  1, -1, 1, 1
	vertex  1,  1,  1, 0, 1
	
	# -X "left" face
	vertex -1, -1, -1, 0, 0
	vertex -1, -1,  1, 1, 0
	vertex -1,  1,  1, 1, 1
	vertex -1,  1, -1, 0, 1
	
	end_shape
  
  end
  
  def mouse_dragged
  
  	rate = 0.01
  	@rotx += ( pmouse_y - mouse_y ) * rate
  	@roty += ( mouse_x - pmouse_x ) * rate
  
  end
  
end

TextureCube.new :title => "Texture Cube"