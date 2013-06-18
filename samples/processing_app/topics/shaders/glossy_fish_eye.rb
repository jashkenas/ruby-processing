#
# Glossy Fish Eye
# 
# A fish-eye shader is used on the main surface and 
# a glossy specular reflection shader is used on the
# offscreen canvas. 
#

attr_reader :ball, :canvas, :glossy, :fisheye, :img, :use_fish_eye

def setup
  size(640, 640, P3D)  
  @canvas = create_graphics(width, height, P3D)
  @use_fish_eye = true
  @fisheye = load_shader("FishEye.glsl")
  fisheye.set("aperture", 180.0)
  
  @glossy = load_shader("GlossyFrag.glsl", "GlossyVert.glsl")  
  glossy.set("AmbientColour", 0.0, 0.0, 0.0)
  glossy.set("DiffuseColour", 0.9, 0.2, 0.2)
  glossy.set("SpecularColour", 1.0, 1.0, 1.0)
  glossy.set("AmbientIntensity", 1.0)
  glossy.set("DiffuseIntensity", 1.0)
  glossy.set("SpecularIntensity", 0.7)
  glossy.set("Roughness", 0.7)
  glossy.set("Sharpness", 0.0)
  
  @ball = create_shape(SPHERE, 50)
  ball.set_stroke(false)
end

def draw
  canvas.begin_draw
  canvas.shader(glossy)
  canvas.no_stroke
  canvas.background(0)
  canvas.push_matrix
  canvas.rotate_y(frame_count * 0.01)
  canvas.point_light(204, 204, 204, 1000, 1000, 1000)
  canvas.pop_matrix  
  (0 ... canvas.width + 100).step(100) do |x|
    (0 ... canvas.width + 100).step(100) do |y|
      (0 ... canvas.width + 100).step(100) do |z|
        canvas.push_matrix
        canvas.translate(x, y, -z)
        canvas.shape(ball)
        canvas.pop_matrix
      end
    end
  end
  canvas.end_draw   
  shader(fisheye) if use_fish_eye  
  image(canvas, 0, 0, width, height)
end

def mousePressed
  if (use_fish_eye)
    @use_fish_eye = false
    reset_shader    
  else
    @use_fish_eye = true
  end
end
