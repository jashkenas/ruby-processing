##
# Fish Eye
# 
# This fish-eye shader is useful for dome projection.
##

attr_reader :fisheye, :canvas, :use_fish_eye 

def setup 
  size(640, 640, P3D)  
  @canvas = create_graphics(width, height, P3D)
  @fisheye = load_shader("FishEye.glsl")
  @use_fish_eye = true
  fisheye.set("aperture", 180.0)  
end

def draw 
  canvas.begin_draw
  canvas.background(0)
  canvas.stroke(255, 0, 0)
  (0...width).step(10){ |i| canvas.line(i, 0, i, height)}
  (0...height).step(10){ |i| canvas.line(0, i, width, i)}
  canvas.lights
  canvas.no_stroke
  canvas.translate(mouse_x, mouse_y, 100)
  canvas.rotate_x(frame_count * 0.01)
  canvas.rotate_y(frame_count * 0.01)  
  canvas.box(100)  
  canvas.end_draw    
  shader(fisheye) if use_fish_eye
  image(canvas, 0, 0, width, height)
end

def mouse_pressed 
  if (use_fish_eye) 
    @use_fish_eye = false
    reset_shader    
  else 
    @use_fish_eye = true
  end
end
