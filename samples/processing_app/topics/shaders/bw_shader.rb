# Texture from Jason Liebig's FLICKR collection of vintage labels and wrappers:
# http://www.flickr.com/photos/jasonliebigstuff/3739263136/in/photostream/

attr_reader :label, :can, :angle, :bw_shader

def setup
  size(640, 360, P3D)  
  @label = load_image("lachoy.jpg")
  @can = create_can(100, 200, 32, label)
  @bw_shader = load_shader("bwfrag.glsl")
  @angle = 0
end

def draw    
  background(0)  
  shader(bw_shader)    
  translate(width/2, height/2)
  rotate_y(angle)  
  shape(can)  
  @angle += 0.01
end

def create_can(r, h, detail, tex)
  texture_mode(NORMAL)
  sh = create_shape
  sh.begin_shape(QUAD_STRIP)
  sh.no_stroke
  sh.texture(tex)
  (0 .. detail).each do |i|
    angle = TWO_PI / detail
    x = sin(i * angle)
    z = cos(i * angle)
    u = i.to_f / detail
    sh.normal(x, 0, z)
    sh.vertex(x * r, -h/2, z * r, u, 0)
    sh.vertex(x * r, +h/2, z * r, u, 1)    
  end
  sh.end_shape 
  return sh
end
