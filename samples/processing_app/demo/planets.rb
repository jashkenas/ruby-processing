# Planets, by Andres Colubri
#
# Sun and mercury textures from http://planetpixelemporium.com
# Star field picture from http://www.galacticimages.com/

attr_reader :starfield, :sun, :suntex, :planet1, :surftex1, :cloudtex, :planet2, :surftex2

def setup
  size(1024, 768, P3D)  
  @starfield = load_image("starfield.jpg")
  @suntex = load_image("sun.jpg")  
  @surftex1 = load_image("planet.jpg")    
  @surftex2 = load_image("mercury.jpg")  
  no_stroke
  fill(255)
  sphere_detail(40)
  @sun = create_shape(SPHERE, 150)
  @sun.set_texture(suntex)  
  @planet1 = create_shape(SPHERE, 150)
  planet1.set_texture(surftex1)  
  @planet2 = create_shape(SPHERE, 50)
  planet2.set_texture(surftex2)
end

def draw
  # Even we draw a full screen image after this, it is recommended to use
  # background to clear the screen anyways, otherwise A3D will think
  # you want to keep each drawn frame in the framebuffer, which results in 
  # slower rendering.
  background(0)  
  # Disabling writing to the depth mask so the 
  # background image doesn't occludes any 3D object.
  hint(DISABLE_DEPTH_MASK)
  image(starfield, 0, 0, width, height)
  hint(ENABLE_DEPTH_MASK)   
  push_matrix
  translate(width/2, height/2, -300)   
  push_matrix
  rotate_y(PI * frame_count / 500)
  shape(sun)
  pop_matrix
  point_light(255,  255,  255,  0,  0,  0)  
  rotate_y(PI * frame_count / 300)
  translate(0, 0, 300)
  shape(planet2)    
  pop_matrix  
  no_lights
  point_light(255,  255,  255,  0,  0,  -150)   
  translate(0.75 * width,  0.6 * height,  50)
  shape(planet1)
end
