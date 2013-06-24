#
# Noise-Based GLSL Heightmap by Amnon Owed (May 2013)
# https://github.com/AmnonOwed
# http://vimeo.com/amnon
# 
# Creating a GLSL heightmap running on shader-based procedural noise.
# 
# c = cycle through the color maps
# 
# Tested with Processing 2.0.1 Final
# 
# Photographs by Folkert Gorter (@folkertgorter / http://superfamous.com/) made available under a CC Attribution 3.0 license.
#

DIM = 300 # the grid dimensions of the heightmap
attr_reader :blur_factor # the blur for the displacement map (to make it smoother)
attr_reader :resize_factor # the resize factor for the displacement map (to make it smoother)
attr_reader :displace_strength 
attr_reader :positions 
attr_reader :tex_coords 
attr_reader :height_map # PShape to hold the geometry, textures, texture coordinates etc.
attr_reader :displace # GLSL shader

attr_reader :images # array to hold 2 input images
attr_reader :current_color_map # variable to keep track of the current colorMap

def setup
  size(1280, 720, P3D) # use the P3D OpenGL renderer
  @blur_factor = 3 
  @resize_factor = 0.25 
  displace_strength = 0.25 # the displace strength of the GLSL shader displacement effect
  # load the images from the _Images folder (relative path from this sketch's folder)
  @images = []  
  images << load_image(data_path("Texture01.jpg"))
  images << load_image(data_path("Texture02.jpg"))
  @current_color_map = 0
  # load the PShader with a fragment and a vertex shader
  @displace = load_shader("displaceFrag.glsl", "displaceVert.glsl") 
  displace.set("displaceStrength", displace_strength) # set the displace_strength
  displace.set("colorMap", images[current_color_map]) # set the initial colorMap
  # create the heightmap PShape (see custom creation method) and put it in the global height_map reference
  @height_map = create_plane(DIM, DIM)
end

def draw
  pointLight(255, 255, 255, 2*(mouse_x - width / 2), 2*(mouse_y - height / 2), 500) # required for texLight shader

  translate(width / 2, height / 2)   # translate to center of the screen
  rotate_x(radians(60))          # fixed rotation of 60 degrees over the X axis
  rotate_z(frame_count*0.005)    # dynamic frameCount-based rotation over the Z axis

  background(0) # black background
  perspective(PI/3.0, width.to_f / height, 0.1, 1000000) # perspective for close shapes
  scale(750) # scale by 750 (the model itself is unit length

  displace.set("time", millis() / 5000.0) # feed time to the GLSL shader
  shader(displace)                        # use shader
  shape(height_map)                       # display the PShape

  # write the fps and the current colorMap in the top-left of the window
  frame.set_title("FrameRate: #{frame_rate.to_i} | colorMap: #{current_color_map}")
end

# custom method to create a PShape plane with certain xy DIMensions
def create_plane(xsegs, ysegs) 

  # STEP 1: create all the relevant data
  
  @positions = [] # arrayList to hold positions
  @tex_coords = [] # arrayList to hold texture coordinates

  usegsize = 1 / xsegs.to_f # horizontal stepsize
  vsegsize = 1 / ysegs.to_f # vertical stepsize

  xsegs.times do |x|
    ysegs.times do |y|
      u = x / xsegs.to_f
      v = y / ysegs.to_f

      # generate positions for the vertices of each cell (-0.5 to center the shape around the origin)
      positions << PVector.new(u - 0.5, v - 0.5, 0)
      positions << PVector.new(u + usegsize - 0.5, v - 0.5, 0)
      positions << PVector.new(u + usegsize - 0.5, v + vsegsize - 0.5, 0)
      positions << PVector.new(u - 0.5, v +  vsegsize - 0.5, 0)

      # generate texture coordinates for the vertices of each cell
      tex_coords << PVector.new(u, v)
      tex_coords << PVector.new(u + usegsize, v)
      tex_coords << PVector.new(u + usegsize, v + vsegsize)
      tex_coords << PVector.new(u, v + vsegsize)
    end
  end

  # STEP 2: put all the relevant data into the PShape

  texture_mode(NORMAL) # set texture_mode to normalized (range 0 to 1)
  tex = load_image(data_path "Texture01.jpg")
  
  mesh = create_shape # create the initial PShape
  mesh.begin_shape(QUADS) # define the PShape type: QUADS
  mesh.no_stroke
  mesh.texture(tex) # set a texture to make a textured PShape
  # put all the vertices, uv texture coordinates and normals into the PShape
  positions.each_with_index { |p, i|
    t = tex_coords[i]
    mesh.vertex(p.x, p.y, p.z, t.x, t.y)
  }
  mesh.end_shape

  return mesh # our work is done here, return DA MESH! -)
end

def key_pressed
  case key
  when '1', '2'
    @current_color_map = key.to_i % 2 #images.size
    displace.set("colorMap", images[current_color_map]) 
  else
    puts "key pressed: #{key}"
  end # cycle through colorMaps (set variable and set colorMap in PShader)
end

