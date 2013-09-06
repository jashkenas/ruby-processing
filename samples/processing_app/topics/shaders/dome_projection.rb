#
# DomeProjection
# 
# This sketch uses use environmental mapping to render the output 
# on a full spherical dome.
# 
# Based on the FullDome_template code from Christopher Warnow: 
# https://github.com/mphasize/FullDome
# 
#

attr_reader :fbo, :cube_map_shader, :dome_sphere, :env_map_texture_id

ENV_MAP_SIZE = 1024

def setup
  size(640, 640, P3D) 
  init_cube_map  
end

def draw
  background(0)
  draw_cube_map 
end

def draw_scene   
  background(0)
  stroke(255, 0, 0)
  stroke_weight(2)
  
  (-width ... 2 * width).step(50) do |i|	
    line(i, -height, -100, i, 2 * height, -100)
  end
  (-height ... 2 * height).step(50) do |i|	
    line(-width, i, -100, 2 * width, i, -100)
  end
  
  lights
  no_stroke
  translate(mouse_x, mouse_y, 200)
  rotate_x(frame_count * 0.01)
  rotate_y(frame_count * 0.01) 
  box(100) 
end

java_import "java.nio.IntBuffer"

def init_cube_map
  sphere_detail(50)
  @dome_sphere = create_shape(SPHERE, height/2.0)
  dome_sphere.rotate_x(HALF_PI)
  dome_sphere.set_stroke(false)

  pgl = beginPGL

  @env_map_texture_id = IntBuffer.allocate(1)
  pgl.gen_textures(1, env_map_texture_id)
  pgl.bind_texture(PGL::TEXTURE_CUBE_MAP, env_map_texture_id.get(0))
  pgl.texParameteri(PGL::TEXTURE_CUBE_MAP, PGL::TEXTURE_WRAP_S, PGL::CLAMP_TO_EDGE)
  pgl.texParameteri(PGL::TEXTURE_CUBE_MAP, PGL::TEXTURE_WRAP_T, PGL::CLAMP_TO_EDGE)
  pgl.texParameteri(PGL::TEXTURE_CUBE_MAP, PGL::TEXTURE_WRAP_R, PGL::CLAMP_TO_EDGE)
  pgl.texParameteri(PGL::TEXTURE_CUBE_MAP, PGL::TEXTURE_MIN_FILTER, PGL::NEAREST)
  pgl.texParameteri(PGL::TEXTURE_CUBE_MAP, PGL::TEXTURE_MAG_FILTER, PGL::NEAREST)
  (PGL::TEXTURE_CUBE_MAP_POSITIVE_X ... PGL::TEXTURE_CUBE_MAP_POSITIVE_X + 6).each do |i|
    pgl.texImage2D(i, 0, PGL::RGBA8, ENV_MAP_SIZE, ENV_MAP_SIZE, 0, PGL::RGBA, PGL::UNSIGNED_BYTE, nil)
  end

  # Init fbo, rbo
  @fbo = IntBuffer.allocate(1)
  rbo = IntBuffer.allocate(1)
  pgl.genFramebuffers(1, fbo)
  pgl.bindFramebuffer(PGL::FRAMEBUFFER, fbo.get(0))
  pgl.framebufferTexture2D(PGL::FRAMEBUFFER, PGL::COLOR_ATTACHMENT0, PGL::TEXTURE_CUBE_MAP_POSITIVE_X, env_map_texture_id.get(0), 0)

  pgl.genRenderbuffers(1, rbo)
  pgl.bindRenderbuffer(PGL::RENDERBUFFER, rbo.get(0))
  pgl.renderbufferStorage(PGL::RENDERBUFFER, PGL::DEPTH_COMPONENT24, ENV_MAP_SIZE, ENV_MAP_SIZE)

  # Attach depth buffer to FBO
  pgl.framebufferRenderbuffer(PGL::FRAMEBUFFER, PGL::DEPTH_ATTACHMENT, PGL::RENDERBUFFER, rbo.get(0))   

  pgl.enable(PGL::TEXTURE_CUBE_MAP)
  pgl.active_texture(PGL::TEXTURE1)
  pgl.bind_texture(PGL::TEXTURE_CUBE_MAP, env_map_texture_id.get(0))    

  endPGL

  # Load cubemap shader.
  @cube_map_shader = load_shader("cubemapfrag.glsl", "cubemapvert.glsl")
  cube_map_shader.set("cubemap", 1)
end

def draw_cube_map
  regenerateEnvMap
  drawDomeMaster
end

def drawDomeMaster
  ortho
  reset_matrix
  shader(cube_map_shader)
  shape(dome_sphere)
  reset_shader
end

# Called to regenerate the envmap
def regenerateEnvMap     
  pgl = beginPGL

  # bind fbo
  pgl.bindFramebuffer(PGL::FRAMEBUFFER, fbo.get(0))

  # generate 6 views from origin(0, 0, 0)
  pgl.viewport(0, 0, ENV_MAP_SIZE, ENV_MAP_SIZE)   
  perspective(90.0 * DEG_TO_RAD, 1.0, 1.0, 1025.0) 
  (PGL::TEXTURE_CUBE_MAP_POSITIVE_X ... PGL::TEXTURE_CUBE_MAP_NEGATIVE_Z).each do |face|
    reset_matrix
    case face
    when PGL::TEXTURE_CUBE_MAP_POSITIVE_X
      camera(0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, -1.0, 0.0)
    when PGL::TEXTURE_CUBE_MAP_NEGATIVE_X
      camera(0.0, 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, -1.0, 0.0)
    when PGL::TEXTURE_CUBE_MAP_POSITIVE_Y
      camera(0.0, 0.0, 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, -1.0) 
    when PGL::TEXTURE_CUBE_MAP_NEGATIVE_Y
      camera(0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0)
    when PGL::TEXTURE_CUBE_MAP_POSITIVE_Z
      camera(0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, -1.0, 0.0)   
    end
    
    scale(-1, 1, -1)
    translate(-width * 0.5, -height * 0.5, -500)
    pgl.framebufferTexture2D(PGL::FRAMEBUFFER, PGL::COLOR_ATTACHMENT0, face, env_map_texture_id.get(0), 0)
    draw_scene# Draw objects in the scene
    flush# Make sure that the geometry in the scene is pushed to the GPU    
    no_lights # Disabling lights to avoid adding many times
    pgl.framebufferTexture2D(PGL::FRAMEBUFFER, PGL::COLOR_ATTACHMENT0, face, 0, 0)
  end
  
  endPGL
end


