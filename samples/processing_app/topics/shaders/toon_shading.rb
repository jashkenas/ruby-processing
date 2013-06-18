#
# Toon Shading.
# 
# Example showing the use of a custom lighting shader in order  
# to apply a "toon" effect on the scene. Based on the glsl tutorial 
# from lighthouse 3D:
# http://www.lighthouse3d.com/tutorials/glsl-tutorial/toon-shader-version-ii/
#

attr_reader :toon, :shader_enabled

def setup
  size(640, 360, P3D)
  @shader_enabled = true  
  no_stroke
  fill(204)
  @toon = load_shader("ToonFrag.glsl", "ToonVert.glsl")
end

def draw
  if (shader_enabled == true)
    shader(toon)
  end
  
  no_stroke 
  background(0) 
  dir_y = (mouse_y / height.to_f - 0.5) * 2
  dir_x = (mouse_x / width.to_f - 0.5) * 2
  directional_light(204, 204, 204, -dir_x, -dir_y, -1)
  translate(width/2, height/2)
  sphere(120)
end  

def mouse_pressed
  if (shader_enabled)
    @shader_enabled = false
    reset_shader
    
  else
    @shader_enabled = true
  end
end

